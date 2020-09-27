import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:privateroom/screens/messaging_screen/webview/navigation_controls.dart';
import 'package:privateroom/services/encryption_service.dart';
import 'package:privateroom/utility/firebase_constants.dart';
import 'package:privateroom/utility/ui_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browser extends StatefulWidget {
  Browser({
    @required this.roomId,
    @required this.toggleBrowser,
    @required this.password,
  });

  final String roomId;
  final String password;
  final Function toggleBrowser;

  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final DatabaseReference ref = FirebaseDatabase.instance.reference();

  String getDecryptUrl(String data) {
    return EncryptionService.decrypt(widget.roomId, widget.password, data);
  }

  String getEncryptedUrl(String url) {
    return EncryptionService.encrypt(widget.roomId, widget.password, url);
  }

  int flex = 1;
  void toggleFullScreen() {
    setState(() {
      flex == 1 ? flex = 100 : flex = 1;
    });
  }

  void bindUrl(WebViewController controller) {
    ref.child(widget.roomId).onChildChanged.listen((event) async {
      String encryptedUrl = event.snapshot.value;
      String url = getDecryptUrl(encryptedUrl);

      print('FROM BIND URL: $url');

      // load only if the URLs are different
      String currentUrl = await controller.currentUrl();
      if (currentUrl != url) controller.loadUrl(url);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.future.then((WebViewController c) {
      bindUrl(c);
    });
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
      flex: flex,
      child: Container(
        decoration: decoration,
        child: Column(
          children: <Widget>[
            NavigationControls(
                _controller.future, widget.toggleBrowser, toggleFullScreen),
            Expanded(
              child: WebView(
                initialUrl: 'https://www.google.com',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                javascriptChannels: <JavascriptChannel>[].toSet(),
                onPageStarted: (url) {
                  print(url);

                  String encryptedUrl = getEncryptedUrl(url);
                  ref.child(widget.roomId).child(kVisitUrl).set(encryptedUrl);
                },
                gestureNavigationEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
