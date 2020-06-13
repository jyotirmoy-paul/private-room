import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({
    this.documentRef,
  });

  final DocumentReference documentRef;

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController _controller;

  void bindUrl() async {
    final snapshots =
        widget.documentRef.collection(kChatMetaDataCollection).snapshots();
    await for (var snapshot in snapshots) {
      for (var metaData in snapshot.documents) {
        setState(() {
          _controller.loadUrl(metaData.data[kVisitUrl]);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    bindUrl();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: kBlack,
          width: 2.0,
        ),
      ),
    );

    return Expanded(
      child: Container(
        decoration: decoration,
        child: WebView(
          initialUrl: 'https://www.google.com',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _controller = controller;
          },
        ),
      ),
    );
  }
}
