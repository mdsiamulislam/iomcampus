
// lib/services/file_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  static Future<String?> getDownloadPath() async {
    try {
      Directory? directory;

      if (Platform.isAndroid) {
        // Try to get the downloads directory
        directory = await getExternalStorageDirectory();
        if (directory != null) {
          final downloadDir = Directory('${directory.path}/Download');
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
          return downloadDir.path;
        }
      }

      // Fallback to app documents directory
      directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      print('Error getting download path: $e');
      return null;
    }
  }

  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      // For Android 11+, also request manage external storage if needed
      if (status.isGranted) {
        var manageStatus = await Permission.manageExternalStorage.status;
        if (!manageStatus.isGranted) {
          manageStatus = await Permission.manageExternalStorage.request();
        }
      }

      return status.isGranted;
    }
    return true; // iOS handles permissions differently
  }
}