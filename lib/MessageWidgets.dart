
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:typewritertext/typewritertext.dart';

class MessageWidget extends StatelessWidget {

  final String text, type, image;
  final bool isFromUser ;
  const MessageWidget({
    super.key,
    required this.text,
    required this.isFromUser,
    required this.type,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment:
        isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: isFromUser
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child:  type == 'image' ? Image.file(
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover ,
                  File(image.toString())):
              TypeWriter.text(
                text,
                duration: const Duration(milliseconds: 50),
                softWrap: true,
                maintainSize: true,
              )

              // MarkdownBody(
              //   selectable: true,
              //   data: text,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}