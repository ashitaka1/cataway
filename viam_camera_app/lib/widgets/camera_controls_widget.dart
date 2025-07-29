import 'package:flutter/material.dart';

class CameraControlsWidget extends StatelessWidget {
  final String cameraName;
  final bool isLoading;
  final VoidCallback onCaptureImage;

  const CameraControlsWidget({
    super.key,
    required this.cameraName,
    required this.isLoading,
    required this.onCaptureImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Camera: $cameraName',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isLoading ? null : onCaptureImage,
              icon: isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: const Text('Capture Image'),
            ),
          ],
        ),
      ),
    );
  }
}