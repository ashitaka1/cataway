import 'package:flutter/material.dart';

class ConnectionFormWidget extends StatelessWidget {
  final TextEditingController locationController;
  final TextEditingController apiKeyController;
  final TextEditingController apiKeyIdController;
  final TextEditingController cameraNameController;
  final bool isLoading;
  final VoidCallback onConnect;
  final VoidCallback onClear;

  const ConnectionFormWidget({
    super.key,
    required this.locationController,
    required this.apiKeyController,
    required this.apiKeyIdController,
    required this.cameraNameController,
    required this.isLoading,
    required this.onConnect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Machine Address',
                hintText: 'your-robot-name.xxxxxxxxxxxx.viam.cloud',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: apiKeyIdController,
              decoration: const InputDecoration(
                labelText: 'API Key ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cameraNameController,
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
                    onPressed: isLoading ? null : onConnect,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Connect'),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onClear,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}