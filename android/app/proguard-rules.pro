# Keep only LatinTextRecognizer to avoid build errors from missing other language classes
-keep class com.google.mlkit.vision.text.latin.** { *; }
-keep class com.google.mlkit.vision.text.TextRecognizer { *; }
