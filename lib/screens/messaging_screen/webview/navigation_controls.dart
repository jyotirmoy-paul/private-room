import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls(
      this._webViewControllerFuture, this.toggleBrowser, this.toggleFullScreen)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;
  final Function toggleBrowser;
  final Function toggleFullScreen;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(FontAwesomeIcons.redo),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.chevronLeft),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      }
                    },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.chevronRight),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      }
                    },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.expand),
              onPressed: () => toggleFullScreen(),
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.times),
              onPressed: () => toggleBrowser(),
            ),
          ],
        );
      },
    );
  }
}
