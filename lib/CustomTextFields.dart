
import 'dart:io';

import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback click,cameraClick;
  final bool isLoading;
  final bool image ;
  final File? imageFile ;

  const CustomTextFields({super.key, required this.controller, required this.focusNode, required this.click, required this.cameraClick, required this.isLoading,
   required this.image,  this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black12,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: imageFile==null?true:false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        imageFile!)
                  ),
                ),
              ),
              Row(
                children: [
                   Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        focusNode: focusNode,
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera),
                        onPressed: cameraClick,
                      ),
                      IconButton(
                        icon: isLoading?const CircularProgressIndicator():const Icon(Icons.send),
                        onPressed: click,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
