# Viam Camera App

A Flutter application that connects to a Viam machine and captures still images from a camera component.

## Features

- Connect to Viam machines using API credentials
- Capture still images from camera components
- Credential caching for convenient reconnection
- Cross-platform support (macOS, web, and more)

## Getting Started

### Prerequisites

- Flutter SDK (3.4.4 or later)
- A Viam machine with a camera component configured

### Installation

1. Clone this repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

#### macOS
```bash
flutter run -d macos
```

#### Web (Chrome)
```bash
flutter run -d chrome
```

### Configuration

You'll need the following information from your Viam machine:

1. **Machine Address**: Your robot's address (e.g., `my-robot.12345678.viam.cloud`)
2. **API Key ID**: From your Viam app's API key
3. **API Key**: The secret key from your Viam app
4. **Camera Name**: The name of your camera component (default: `webcam`)

### Usage

1. Launch the app
2. Enter your Viam machine credentials
3. Click "Connect"
4. Once connected, click "Capture Image" to take a photo

The app will save your credentials for future sessions.

## Project Structure

- `lib/main.dart` - Main application code
- `macos/` - macOS-specific configuration
- `web/` - Web-specific configuration

## Dependencies

- `viam_sdk: ^0.7.0` - Viam SDK for Flutter
- `shared_preferences: ^2.5.3` - For credential caching 