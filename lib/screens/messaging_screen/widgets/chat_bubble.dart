import 'package:flutter/material.dart';
import 'package:privateroom/services/encoding_decoding_service.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({
    @required this.chatData,
    @required this.name,
    @required this.password,
  });

  final dynamic chatData;
  final String name;
  final String password;

  // UI constants
  final borderRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    String documentId = chatData['id'];

    var chatContents = EncodingDecodingService.decryptAndDecode(
      chatData['data'],
      documentId,
      password,
    );

    bool isMe = (name == chatContents[kUserName]);

    final decorationSelfChat = BoxDecoration(
      color: kImperialRed,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        bottomLeft: Radius.circular(borderRadius),
      ),
    );

    final decorationOtherChat = BoxDecoration(
      color: kImperialRed.withOpacity(0.08),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
      ),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        margin: EdgeInsets.only(
          bottom: 10.0,
          left: isMe ? 100.0 : 0.0,
          right: isMe ? 0.0 : 100.0,
        ),
        decoration: isMe ? decorationSelfChat : decorationOtherChat,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              chatContents[kTimestamp].toString().split(', ')[0],
              style: kLightestTextStyle.copyWith(
                color: isMe ? kWhite : kBlack,
              ),
            ),
            SizedBox(height: 10),
            Text(
              chatContents[kMessageBody],
              style: kLabelTextStyle.copyWith(
                color: isMe ? kWhite : kBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
