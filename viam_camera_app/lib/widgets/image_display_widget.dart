import 'package:flutter/material.dart';
import 'dart:typed_data';

class ImageDisplayWidget extends StatelessWidget {
  final Uint8List? imageData;

  const ImageDisplayWidget({
    super.key,
    this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 200,
          maxHeight: 500,
        ),
        child: imageData != null
            ? Image.memory(
                imageData!,
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
                      Icon(Icons.camera_alt, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('No image captured yet'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}