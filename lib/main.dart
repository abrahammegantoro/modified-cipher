import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();

  await _requestPermission();

  FlutterDownloader.initialize();

  runApp(MyApp(settingsController: settingsController));
}

Future<void> _requestPermission() async {
  PermissionStatus status = await Permission.storage.request();
  if (!status.isGranted) {}
}
