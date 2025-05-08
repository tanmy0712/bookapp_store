import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageHelper {
  static final _storage = FirebaseStorage.instance;

  static Future<String?> uploadImage(
      String filePath,
      String folder,
      ) async {
    try {
      if (filePath.isEmpty || filePath.startsWith('http')) {
        return filePath;
      }

      final fileBytes = await XFile(filePath).readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final storagePath = '$folder/$fileName';

      final ref = _storage.ref().child(storagePath);
      await ref.putData(fileBytes);

      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  static Future<bool> deleteImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty) return false;

      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Tìm đường dẫn file trong Firebase Storage từ URL
      final index = pathSegments.indexWhere((segment) => segment == 'o');
      if (index == -1 || index + 1 >= pathSegments.length) return false;

      final encodedPath = pathSegments[index + 1];
      final filePath = Uri.decodeFull(encodedPath).split('?').first;

      final ref = _storage.ref().child(filePath);
      await ref.delete();

      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }
}