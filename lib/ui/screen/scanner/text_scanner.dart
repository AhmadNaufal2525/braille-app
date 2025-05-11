import 'dart:io';
import 'package:braille_app/ui/screen/scanner/result_screen.dart';
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
  bool isPermissionGranted = false;
  late final Future<void> future;

  //camera
  CameraController? cameraController;
  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    future = requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    initCameraController(snapshot.data!);

                    return Center(child: CameraPreview(cameraController!));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              backgroundColor: isPermissionGranted ? Colors.transparent : null,
              body:
                  isPermissionGranted
                      ? Column(
                        children: [
                          Expanded(child: Container()),
                          Container(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Center(
                              child: BasicButton(
                                width: 162,
                                height: 32,
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
                      : Center(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 24.0,
                            right: 24.0,
                          ),
                          child: const Text(
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

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    isPermissionGranted = status == PermissionStatus.granted;
  }

  void initCameraController(List<CameraDescription> cameras) {
    if (cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      cameraSelected(camera);
    }
  }

  Future<void> cameraSelected(CameraDescription camera) async {
    cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await cameraController!.initialize();
    await cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> scanImage() async {
    if (cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      await navigator.push(
        MaterialPageRoute(
          builder:
              (BuildContext context) => ResultScreen(text: recognizedText.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred when scanning text')),
      );
    }
  }

  void startCamera() {
    if (cameraController != null) {
      cameraSelected(cameraController!.description);
    }
  }

  void stopCamera() {
    if (cameraController != null) {
      cameraController?.dispose();
    }
  }
}
