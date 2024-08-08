import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_ai/Controller/ChatController.dart';
import 'package:gemini_ai/Widgets/ChatItems.dart';
import 'package:gemini_ai/Utils/ColourConstant.dart';
import 'package:gemini_ai/Widgets/CustomTextFields.dart';
import 'package:gemini_ai/Models/DataModel.dart';
import 'package:gemini_ai/Controller/ImagePickerController.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final imagePickerController = Get.put(ImagePickerController());
  final chatController = Get.put(ChatController());
  static const _apiKey = 'AIzaSyA-IIkkkaUUgwiY53TRCIGdTGwC9_N5vXk';


  @override
  void initState() {
    super.initState();
    chatController.scrollAnimation();
    chatController.streamSocket.getResponse;
    chatController.model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );
    chatController.chat = chatController.model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhite,
      appBar: AppBar(
        backgroundColor: appBlue,
        title: const Text('Gemini AI'),
      ),
      body: Obx(() {
        chatController.scrollAnimation();
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<List<DataModel>>(
              stream: chatController.streamSocket.getResponse,
              initialData: [
                DataModel('No Data Found', 'No Data Found', 'No Data Found')
              ],
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (chatController.list.isEmpty) {
                    return const Expanded(
                        child: Center(
                            child: Text('Greetings!\n How i can help you',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white))));
                  }
                  return Expanded(
                    child: ListView.builder(
                      controller: chatController.scrollController,
                      itemCount: chatController.list.length,
                      itemBuilder: (context, index) {
                        final data = chatController.list[index];
                        if (chatController.list.indexWhere((item) => item.prompt == data.prompt && item.isMe == data.isMe) != index) {
                          return const SizedBox.shrink();
                        }
                        return ChatItems(
                          text: data.prompt,
                          isFromUser: data.isMe,
                          type: data.type,
                          image: data.image,
                        );
                      },
                    )
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: CustomTextFields(
                          imageFile: imagePickerController.image.value,
                          controller: chatController.textController,
                          click: () {
                            if (chatController.textController.text.isEmpty) {
                              _showError('Please enter prompt');
                            } else {
                              if (imagePickerController.image.value == null) {
                                chatController.sendChatMessage(
                                    chatController.textController.text);
                              } else {
                                chatController.sendImageMessage(
                                    chatController.textController.text);
                              }
                            }
                          },
                          cameraClick: () {
                            imagePickerController.pickImage();
                          },
                          isLoading: chatController.loading.value))
                ],
              ),
            )
          ],
        );
      }),
    );
  }



  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
