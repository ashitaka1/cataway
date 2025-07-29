import 'package:flutter/material.dart';
import 'package:viam_sdk/viam_sdk.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

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
  RobotClient? robot;
  Camera? camera;
  bool isConnected = false;
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
    robot?.close();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationController.text = prefs.getString('location') ?? '';
      _apiKeyController.text = prefs.getString('apiKey') ?? '';
      _apiKeyIdController.text = prefs.getString('apiKeyId') ?? '';
      _cameraNameController.text = prefs.getString('cameraName') ?? 'webcam';
    });
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', _locationController.text);
    await prefs.setString('apiKey', _apiKeyController.text);
    await prefs.setString('apiKeyId', _apiKeyIdController.text);
    await prefs.setString('cameraName', _cameraNameController.text);
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
      robot = await RobotClient.atAddress(
        _locationController.text,
        RobotClientOptions.withApiKey(
            _apiKeyIdController.text, _apiKeyController.text),
      );

      await _getCamera();
      await _saveCredentials();

      setState(() {
        isConnected = true;
        isLoading = false;
      });

      debugPrint('Successfully connected to robot');
    } catch (e) {
      setState(() {
        isConnected = false;
        isLoading = false;
        errorMessage = 'Failed to connect: $e';
      });
      debugPrint('Connection failed: $e');
    }
  }

  Future<void> _getCamera() async {
    if (robot == null) return;

    try {
      camera = Camera.fromRobot(robot!, _cameraNameController.text);
      debugPrint('Camera ${_cameraNameController.text} initialized');
    } catch (e) {
      debugPrint('Failed to get camera: $e');
      setState(() {
        errorMessage = 'Failed to get camera: $e';
      });
      rethrow;
    }
  }

  Future<void> _refreshImage() async {
    if (camera == null || isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      debugPrint('Fetching image from camera: ${_cameraNameController.text}');
      final viamImage = await camera!.image();
      final imageBytes = Uint8List.fromList(viamImage.raw);

      setState(() {
        currentImage = imageBytes;
        isLoading = false;
      });

      debugPrint('Image fetched successfully, ${imageBytes.length} bytes');
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to get image: $e';
      });
      debugPrint('Image fetch failed: $e');
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connection Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            isConnected ? Icons.check_circle : Icons.error,
                            color: isConnected ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(isConnected ? 'Connected' : 'Disconnected'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Connection Form
              if (!isConnected) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Machine Address',
                            hintText: 'your-robot-name.xxxxxxxxxxxx.viam.cloud',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _apiKeyIdController,
                          decoration: const InputDecoration(
                            labelText: 'API Key ID',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _apiKeyController,
                          decoration: const InputDecoration(
                            labelText: 'API Key',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _cameraNameController,
                          decoration: const InputDecoration(
                            labelText: 'Camera Name',
                            hintText: 'webcam',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLoading ? null : connectToRobot,
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Text('Connect'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: _clearCredentials,
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Camera Controls
              if (isConnected) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Camera: ${_cameraNameController.text}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: isLoading ? null : _refreshImage,
                          icon: isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.refresh),
                          label: const Text('Capture Image'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Image Display
                Card(
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 200,
                      maxHeight: 500,
                    ),
                    child: currentImage != null
                        ? Image.memory(
                            currentImage!,
                            fit: BoxFit.contain,
                          )
                        : Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      size: 48, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('No image captured yet'),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],

              // Error Display
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              'Error',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.red,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
