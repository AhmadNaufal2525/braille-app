import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:braille_app/ui/screen/home/converter.dart';
import 'package:braille_app/ui/shared/basic_button.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class TextScanner extends StatefulWidget {
  const TextScanner({super.key});

  @override
  State<TextScanner> createState() => _TextScannerState();
}

class _TextScannerState extends State<TextScanner> with WidgetsBindingObserver {
  CameraController? cameraController;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool isPermissionGranted = false;
  late Future<void> future;
  RecognizedText? _recognizedText;
  bool _isScanning = false;
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    future = requestCameraPermission().then((_) {
      if (isPermissionGranted) {
        initCamera();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanTimer?.cancel();
    stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized)
      return;

    if (state == AppLifecycleState.inactive) {
      stopCamera();
    } else if (state == AppLifecycleState.resumed) {
      startCamera();
    }
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    isPermissionGranted = status == PermissionStatus.granted;
    setState(() {});
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
    );

    cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await cameraController!.initialize();
    await cameraController!.setFlashMode(FlashMode.off);

    if (mounted) {
      setState(() {});
      startScanningLoop();
    }
  }

  void startCamera() {
    if (cameraController != null) {
      cameraController!.resumePreview();
      startScanningLoop();
    }
  }

  void stopCamera() {
    _scanTimer?.cancel();
    cameraController?.dispose();
  }

  void startScanningLoop() {
    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (_isScanning ||
          cameraController == null ||
          !cameraController!.value.isInitialized)
        return;

      _isScanning = true;

      try {
        final file = await cameraController!.takePicture();
        final inputImage = InputImage.fromFile(File(file.path));
        final recognizedText = await textRecognizer.processImage(inputImage);

        final List<TextElement> newElements = [];
        for (final block in recognizedText.blocks) {
          for (final line in block.lines) {
            newElements.addAll(line.elements);
          }
        }

        if (mounted) {
          setState(() {
            _recognizedText = recognizedText;
          });
        }
      } catch (_) {
        // Optional: log error
      } finally {
        _isScanning = false;
      }
    });
  }

  Future<void> scanImage() async {
    if (cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      // Return scanned text to previous screen
      final braille = await latinToBraille(recognizedText.text);
      navigator.pop({'text': recognizedText.text, 'braille': braille});
      print('recognized Text: ${recognizedText.text}');

    } catch (e, stackTrace) {
      print('Error scanning text: $e');
      print('Stack trace: $stackTrace');

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("An error occurred when scanning text: $e")),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (isPermissionGranted &&
                cameraController != null &&
                cameraController!.value.isInitialized)
              Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width:
                            cameraController!
                                .value
                                .previewSize!
                                .height, // Note: width/height swapped for portrait
                        height: cameraController!.value.previewSize!.width,
                        child: CameraPreview(cameraController!),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: CustomPaint(
                      painter:
                          _recognizedText == null
                              ? null
                              : TextDetectorPainter(
                                recognizedText: _recognizedText!,
                                imageSize: cameraController!.value.previewSize!,
                              ),
                    ),
                  ),
                ],
              ),
            Scaffold(
              backgroundColor: isPermissionGranted ? Colors.transparent : null,
              body:
                  isPermissionGranted
                      ? Column(
                        children: [
                          Expanded(child: Container()),
                          Container(
                            padding: const EdgeInsets.only(bottom: 50.0),
                            child: Center(
                              child: BasicButton(
                                width: 162,
                                height: 40,
                                text: 'Scan',
                                textStyle: AppTextStyle.largeWhiteBold,
                                onPress: () {
                                  scanImage();
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                      : const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Camera permission denied',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }
}

class TextDetectorPainter extends CustomPainter {
  final RecognizedText recognizedText;
  final Size imageSize;

  TextDetectorPainter({required this.recognizedText, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.yellow.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    for (final block in recognizedText.blocks) {
      final rect = scaleRectCover(block.boundingBox, imageSize, size);

      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, borderPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: block.text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: rect.width);

      // Paint text with a slight vertical offset
      textPainter.paint(canvas, Offset(rect.left, rect.top + 2));
    }
  }

  @override
  bool shouldRepaint(covariant TextDetectorPainter oldDelegate) =>
      oldDelegate.recognizedText != recognizedText;
}

// Rect _scaleRect(Rect rect, Size imageSize, Size widgetSize) {
//   // Calculate scale (uniform, to fit inside widget)
//   final scale = math.min(
//     widgetSize.width / imageSize.width,
//     widgetSize.height / imageSize.height,
//   );

//   // Calculate leftover space (black bars) to center the camera preview inside widget
//   final dx = (widgetSize.width - imageSize.width * scale) / 2;
//   final dy = (widgetSize.height - imageSize.height * scale) / 2;

//   return Rect.fromLTRB(
//     rect.left * scale + dx,
//     rect.top * scale + dy,
//     rect.right * scale + dx,
//     rect.bottom * scale + dy,
//   );
// }
Rect scaleRectCover(Rect rect, Size imageSize, Size widgetSize) {
  final scale = math.max(
    widgetSize.width / imageSize.height, // widget width / raw height
    widgetSize.height / imageSize.width, // widget height / raw width
  );

  final scaledImageWidth = imageSize.height * scale;
  final scaledImageHeight = imageSize.width * scale;

  final dx = (scaledImageWidth - widgetSize.width) / 2;
  final dy = (scaledImageHeight - widgetSize.height) / 2;

  // Swap x,y for raw to widget (because of rotation)
  final left = rect.left * scale - dx; // raw x → widget x (horizontal)
  final top = rect.top * scale - dy; // raw y → widget y (vertical)
  final right = rect.right * scale - dx;
  final bottom = rect.bottom * scale - dy;

  // Clamp to screen bounds
  return Rect.fromLTRB(
    left.clamp(0.0, widgetSize.width),
    top.clamp(0.0, widgetSize.height),
    right.clamp(0.0, widgetSize.width),
    bottom.clamp(0.0, widgetSize.height),
  );
}
