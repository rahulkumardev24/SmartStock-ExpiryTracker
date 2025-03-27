import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageUtils {

  static Future<String> saveImagePermanently(String imagePath) async {
    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    
    // Create an 'item_images' subdirectory if it doesn't exist
    final imageDir = Directory('${directory.path}/item_images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    // Generate a unique filename using timestamp
    final filename = 'item_${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}';
    final destinationPath = '${imageDir.path}/$filename';

    // Copy the image file to the permanent location
    final File newImage = await File(imagePath).copy(destinationPath);
    return newImage.path;
  }
}
