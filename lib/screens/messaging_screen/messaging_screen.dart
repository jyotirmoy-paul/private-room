import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:privateroom/screens/messaging_screen/widgets/bottom_sheet_menu.dart';
import 'package:privateroom/screens/messaging_screen/widgets/chat_bubble.dart';
import 'package:privateroom/screens/messaging_screen/webview_screen.dart';
import 'package:privateroom/services/encoding_decoding_service.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';

class MessagingScreen extends StatefulWidget {
  final roomData;
  final password;
  final name;

  MessagingScreen({
    @required this.roomData,
    @required this.password,
    @required this.name,
  });

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final _textMessageController = TextEditingController();

  bool showBrowser = false;
  DocumentReference _documentRef;
  CollectionReference _chatDataCollectionRef;

  void toggleBrowser() {
    setState(() {
      showBrowser = !showBrowser;
    });
  }

  void sendMessage(String message) {
    var _ref = _chatDataCollectionRef.document();
    var documentId = _ref.documentID;

    Map<String, dynamic> data = {
      kUserName: widget.name,
      kTimestamp: DateFormat('HH:mm, dd MMM yyyy').format(DateTime.now()),
      kMessageBody: message,
      kIsDoodle: false,
    };

    String encryptedData = EncodingDecodingService.encodeAndEncrypt(
      data,
      documentId, // using doc id as IV
      widget.password,
    );

    _ref.setData({
      'data': encryptedData,
      'id': documentId,
      'date': DateTime.now().toIso8601String().toString(),
    });
  }

  @override
  void initState() {
    super.initState();

    _documentRef = Firestore.instance
        .collection(kChatCollection)
        .document(widget.roomData[kRoomId]);

    _chatDataCollectionRef = _documentRef.collection(kChatDataCollection);
  }

  @override
  Widget build(BuildContext context) {
    // bottom text area widgets
    final menuButton = Positioned.fill(
      child: Align(
        alignment: Alignment.centerLeft,
        child: MaterialButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (ctx) => SingleChildScrollView(
                child: BottomSheetMenu(
                  toggleBrowser: toggleBrowser,
                  name: widget.name,
                  password: widget.password,
                  chatDataCollectionReference: _chatDataCollectionRef,
                ),
              ),
            );
          },
          minWidth: 0,
          elevation: 5.0,
          color: kWhite,
          child: Icon(
            FontAwesomeIcons.angleDoubleUp,
            size: 25.0,
            color: kImperialRed,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
      ),
    );
    final textArea = Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 50),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 65,
            ),
            child: Card(
              color: Colors.transparent,
              elevation: 0.0,
              margin: EdgeInsets.all(0.0),
              child: TextField(
                controller: _textMessageController,
                style: kGeneralTextStyle.copyWith(color: kBlack, fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: kLabelTextStyle.copyWith(fontSize: 15),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final sendButton = Align(
      alignment: Alignment.centerRight,
      child: MaterialButton(
        onPressed: () {
          String message = _textMessageController.text.trim();
          _textMessageController.clear();

          if (message.isEmpty) {
            return;
          }
          sendMessage(message);
        },
        minWidth: 0,
        elevation: 5.0,
        color: kImperialRed,
        child: Icon(
          FontAwesomeIcons.chevronRight,
          size: 25.0,
          color: kWhite,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );

    final bottomTextArea = Container(
      color: kImperialRed.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Stack(
        children: <Widget>[
          menuButton,
          textArea,
          sendButton,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            showBrowser
                ? WebViewScreen(documentRef: _documentRef)
                : SizedBox.shrink(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatDataCollectionRef.orderBy('date').snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data.documents.isEmpty)
                    return Center(
                      child: Text(
                        'Send your first text in this Room',
                        style: kTitleTextStyle,
                      ),
                    );

                  List<Widget> widgets = [];
                  List<DocumentSnapshot> ds =
                      snapshot.data.documents.reversed.toList();

                  for (var chatData in ds) {
                    widgets.add(ChatBubble(
                      chatData: chatData.data,
                      name: widget.name,
                      password: widget.password,
                    ));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: widgets.length,
                    itemBuilder: (ctx, index) {
                      return widgets[index];
                    },
                  );
                },
              ),
            ),
            bottomTextArea,
          ],
        ),
      ),
    );
  }
}
