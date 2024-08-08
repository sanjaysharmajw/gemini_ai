import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {

  final ImagePicker _picker = ImagePicker();
  Rx<File?> image = Rx<File?>(null); // Rx variable to make the image reactive

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
          // WebUiSettings is not required here as it depends on the context
        ],
      );
      if (croppedFile != null) {
        image.value = File(croppedFile.path); // Update the reactive variable
      }
    }
  }

  Future<void> pickImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
          // WebUiSettings is not required here as it depends on the context
        ],
      );
      if (croppedFile != null) {
        image.value = File(croppedFile.path); // Update the reactive variable
      }
    }
  }

}