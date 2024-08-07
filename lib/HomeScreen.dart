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
import 'package:gemini_ai/Widgets/MessageWidgets.dart';
import 'package:gemini_ai/Utils/StreamSocket.dart';
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
      appBar: AppBar(
        backgroundColor: appBlue,
        title: const Text('Gemini AI'),
      ),
      body: Obx(() {
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
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final data = chatController.list[index];
                          return ChatItems(
                              text: data.prompt,
                              isFromUser: data.isMe,
                              type: data.type,
                              image: data.image);
                        }),
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

  // Future<void> _sendChatMessage(String message) async {
  //   setState(() {
  //     _loading = true;
  //   });
  //
  //   try {
  //     list.add(DataModel('', 'text', message, isMe: true));
  //     streamSocket.addResponse(list);
  //
  //     var response = await _chat.sendMessage(
  //       Content.text(message),
  //     );
  //
  //     var text = response.text;
  //
  //     if (text == null) {
  //       _showError('No response from API.');
  //       return;
  //     } else {
  //       list.add(DataModel('', 'text', text, isMe: false));
  //       streamSocket.addResponse(list);
  //       setState(() {
  //         _loading = false;
  //         _scrollDown();
  //       });
  //     }
  //   } catch (e) {
  //     _showError(e.toString());
  //     setState(() {
  //       _loading = false;
  //     });
  //   } finally {
  //     _textController.clear();
  //     setState(() {
  //       _loading = false;
  //     });
  //     _textFieldFocus.requestFocus();
  //   }
  // }

  // Future<void> _sendImageMessage(String message) async {
  //   try {
  //     setState(() {
  //       _loading = true;
  //     });
  //
  //     chatController.list.add(
  //         DataModel(imagePickerController.image.value!.path.toString(), 'image', message, isMe: true));
  //     chatController.list.add(DataModel(imagePickerController.image.value!.path.toString(), 'text', message, isMe: true));
  //     streamSocket.addResponse(chatController.list);
  //
  //     setState(() {
  //       _scrollDown();
  //     });
  //
  //     final firstImage = await imagePickerController.image.value!.readAsBytes();
  //
  //     final prompt = TextPart(message);
  //
  //     final imageParts = [
  //       DataPart('image/jpeg', firstImage),
  //     ];
  //
  //     final response = await _model.generateContent([
  //       Content.multi([prompt, ...imageParts])
  //     ]);
  //
  //     var text = response.text;
  //
  //     if (text == null) {
  //       _showError('No response from API.');
  //       return;
  //     } else {
  //       chatController.list.add(DataModel('', 'text', text, isMe: false));
  //       streamSocket.addResponse(chatController.list);
  //
  //       setState(() {
  //         _loading = false;
  //         _scrollDown();
  //       });
  //     }
  //   } catch (e) {
  //     _showError(e.toString());
  //     setState(() {
  //       _loading = false;
  //     });
  //   } finally {
  //     _textController.clear();
  //     setState(() {
  //       _loading = false;
  //     });
  //     _textFieldFocus.requestFocus();
  //   }
  // }


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
