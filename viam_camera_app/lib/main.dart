import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'widgets/connection_status_widget.dart';
import 'widgets/connection_form_widget.dart';
import 'widgets/camera_controls_widget.dart';
import 'widgets/image_display_widget.dart';
import 'widgets/error_display_widget.dart';
import 'services/credentials_service.dart';
import 'services/robot_service.dart';

void main() {
  runApp(const ViamCameraApp());
}

class ViamCameraApp extends StatelessWidget {
  const ViamCameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viam Camera App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CameraStreamPage(title: 'Viam Camera Stream'),
    );
  }
}

class CameraStreamPage extends StatefulWidget {
  const CameraStreamPage({super.key, required this.title});

  final String title;

  @override
  State<CameraStreamPage> createState() => _CameraStreamPageState();
}

class _CameraStreamPageState extends State<CameraStreamPage> {
  final RobotService _robotService = RobotService();
  bool isLoading = false;
  String? errorMessage;
  Uint8List? currentImage;

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _apiKeyIdController = TextEditingController();
  final TextEditingController _cameraNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _apiKeyController.dispose();
    _apiKeyIdController.dispose();
    _cameraNameController.dispose();
    _robotService.disconnect();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await CredentialsService.loadCredentials();
    setState(() {
      _locationController.text = credentials['location']!;
      _apiKeyController.text = credentials['apiKey']!;
      _apiKeyIdController.text = credentials['apiKeyId']!;
      _cameraNameController.text = credentials['cameraName']!;
    });
  }

  Future<void> _saveCredentials() async {
    await CredentialsService.saveCredentials(
      location: _locationController.text,
      apiKey: _apiKeyController.text,
      apiKeyId: _apiKeyIdController.text,
      cameraName: _cameraNameController.text,
    );
  }

  Future<void> _clearCredentials() async {
    await CredentialsService.clearCredentials();
    setState(() {
      _locationController.clear();
      _apiKeyController.clear();
      _apiKeyIdController.clear();
      _cameraNameController.text = 'webcam';
    });
  }

  Future<void> connectToRobot() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _robotService.connectToRobot(
        location: _locationController.text,
        apiKeyId: _apiKeyIdController.text,
        apiKey: _apiKeyController.text,
      );

      await _robotService.initializeCamera(_cameraNameController.text);
      await _saveCredentials();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to connect: $e';
      });
    }
  }

  Future<void> _refreshImage() async {
    if (!_robotService.isConnected || isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final imageBytes = await _robotService.captureImage();

      setState(() {
        currentImage = imageBytes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to get image: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Connection Status
              ConnectionStatusWidget(
                isConnected: _robotService.isConnected,
              ),
              const SizedBox(height: 16),

              // Connection Form
              if (!_robotService.isConnected) ...[
                ConnectionFormWidget(
                  locationController: _locationController,
                  apiKeyController: _apiKeyController,
                  apiKeyIdController: _apiKeyIdController,
                  cameraNameController: _cameraNameController,
                  isLoading: isLoading,
                  onConnect: connectToRobot,
                  onClear: _clearCredentials,
                ),
              ],

              // Camera Controls
              if (_robotService.isConnected) ...[
                CameraControlsWidget(
                  cameraName: _cameraNameController.text,
                  isLoading: isLoading,
                  onCaptureImage: _refreshImage,
                ),
                const SizedBox(height: 16),

                // Image Display
                ImageDisplayWidget(
                  imageData: currentImage,
                ),
              ],

              // Error Display
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                ErrorDisplayWidget(
                  errorMessage: errorMessage!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
