
import 'dart:io';
import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {

  final TextEditingController controller;

  final VoidCallback click, cameraClick;
  final bool isLoading;
  final File? imageFile;

  const CustomTextFields({
    super.key,
    required this.controller,
    required this.click,
    required this.cameraClick,
    required this.isLoading,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
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
            children: [
              Visibility(
                visible:imageFile != null?true:false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: imageFile != null
                                ? Image.file(imageFile!,
                                    height: 100, width: 100, fit: BoxFit.cover)
                                : Image.asset("assets/demo.jpg",
                                    height: 100, width: 100)),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0),
                      child: TextField(
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
                        icon: isLoading
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.send),
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
