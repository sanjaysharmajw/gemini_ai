import 'package:flutter/material.dart';
import 'package:gemini_ai/Models/DataModel.dart';
import 'package:gemini_ai/Controller/ImagePickerController.dart';
import 'package:gemini_ai/Utils/StreamSocket.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatController extends GetxController {
  var loading = false.obs;
  var list = <DataModel>[].obs;
  late final GenerativeModel model;
  final  imagePickerController = Get.put(ImagePickerController());
  ChatSession? chat;
  StreamSocket streamSocket = StreamSocket();
  final textController = TextEditingController();

  ScrollController scrollController = ScrollController();

  Future<void> sendChatMessage(String message) async {
    loading.value = true;
    try {
      list.add(DataModel('', 'text', message, isMe: true));
      streamSocket.addResponse(list);
      var response = await chat!.sendMessage(
        Content.text(message),
      );
      if (response.text == null) {
        _showError('No response from API.');
        return;
      } else {
        list.add(DataModel('', 'text', response.text!, isMe: false));
        streamSocket.addResponse(list);
        loading.value = false;
        scrollAnimation();
      }
    } catch (e) {
      _showError(e.toString());
      loading.value = false;
    } finally {
      textController.clear();
      imagePickerController.image.value=null;
      loading.value = false;
    }
  }

  void _showError(String message) {
    // Implement your error handling here, for example, showing a Snackbar
  }



  Future<void> sendImageMessage(String message) async {
    try {
      loading.value = true;
      list.add(
          DataModel(imagePickerController.image.value!.path.toString(), 'image', message, isMe: true));
      list.add(DataModel(imagePickerController.image.value!.path.toString(), 'text', message, isMe: true));
      streamSocket.addResponse(list);
      scrollAnimation();
      final firstImage = await imagePickerController.image.value!.readAsBytes();
      final prompt = TextPart(message);
      final imageParts = [
        DataPart('image/jpeg', firstImage),
      ];
      final response = await model.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      var text = response.text;
      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        list.add(DataModel('', 'text', text, isMe: false));
        streamSocket.addResponse(list);
          loading.value = false;
        scrollAnimation();
      }
    } catch (e) {
      _showError(e.toString());
        loading.value = false;

    } finally {
      textController.clear();
      imagePickerController.image.value=null;
      loading.value = false;
    }
  }

  // Scroll Chat
  Future<void> scrollAnimation() async {
    return await Future.delayed(
        const Duration(milliseconds: 100),
            () => scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear));
  }

}
