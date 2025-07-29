import 'package:flutter/material.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final bool isConnected;

  const ConnectionStatusWidget({
    super.key,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}