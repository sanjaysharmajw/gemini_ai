import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini_ai/Utils/ColourConstant.dart';
import 'package:gemini_ai/Utils/Utils.dart';
import 'package:gemini_ai/Utils/font_path.dart';
import 'package:stream_typewriter_text/stream_typewriter_text.dart';
import 'package:typewritertext/typewritertext.dart';

class ChatItems extends StatelessWidget {
  final String text, type, image;
  final bool isFromUser;
  const ChatItems(
      {super.key,
      required this.text,
      required this.type,
      required this.image,
      required this.isFromUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        alignment: isFromUser ? WrapAlignment.end : WrapAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                isFromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.3),
                decoration: BoxDecoration(
                  color: isFromUser ? appBlue : appLightBlue,
                  borderRadius: isFromUser
                      ? const BorderRadius.only(
                          topRight: Radius.circular(13),
                          topLeft: Radius.circular(13),
                          bottomLeft: Radius.circular(13))
                      : const BorderRadius.only(
                          topRight: Radius.circular(13),
                          bottomRight: Radius.circular(13),
                          bottomLeft: Radius.circular(13)),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: type == 'image'
                        ? Image.file(
                            height: 250,
                            width: 250,
                            fit: BoxFit.cover,
                            File(image.toString()))
                        : isFromUser
                            ? Text(text,style: const TextStyle(
                      fontFamily: mediumFont,color: appWhite
                    ))
                            :
                    StreamTypewriterAnimatedText(
                      text: text,
                      style: const TextStyle(
                        fontFamily: mediumFont,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      //isHapticFeedbackEnabled: true,
                      speed: const Duration(milliseconds: 30),
                      pause: const Duration(milliseconds: 100),
                    )

                    // TypeWriter.text(text,
                    //             duration: const Duration(milliseconds: 10),
                    //             style: TextStyle(
                    //                 fontFamily: mediumFont,
                    //                 color: isFromUser
                    //                     ? Colors.white
                    //                     : Colors.black,
                    //                 fontSize: 15))

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,top: 10,bottom: 10),
                child: Text(Utils.getFormattedTimeEvent(DateTime.now().millisecondsSinceEpoch),style: const TextStyle(fontSize: 12,fontFamily: 'Gilroy')),
              ),
            ],
          )
        ],
      ),
    );
  }
}
