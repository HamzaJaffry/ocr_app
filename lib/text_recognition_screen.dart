import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class TextRecognitionScreen extends StatefulWidget {
  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInitializeCamera();
  }

  Future<void> _requestPermissionAndInitializeCamera() async {
    var status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      _cameraController =
          CameraController(firstCamera, ResolutionPreset.medium);
      _initializeControllerFuture = _cameraController!.initialize();
      setState(() {});
    } else {
      print('Camera permission denied');
    }
  }

  Future<void> _takePictureAndRecognizeText() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController!.takePicture();
      await _recognizeText(File(image.path));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _recognizeText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textDetector = GoogleMlKit.vision.textRecognizer();

    try {
      final RecognizedText recognizedText =
          await textDetector.processImage(inputImage);
      await textDetector.close();

      if (recognizedText.text.isNotEmpty) {
        await flutterTts.speak(recognizedText.text);
      } else {
        print("No text recognized");
      }
    } catch (e) {
      print("Error recognizing text: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _cameraController != null) {
            return CameraPreview(_cameraController!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePictureAndRecognizeText,
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    flutterTts.stop();
    super.dispose();
  }
}
