import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlViewerPage extends StatefulWidget {
  final String filePath;
  final String namePage;

  HtmlViewerPage({super.key, required this.filePath, required this.namePage});

  @override
  State<HtmlViewerPage> createState() => _HtmlViewerPageState();
}

class _HtmlViewerPageState extends State<HtmlViewerPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith('file://')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse('data:text/html;base64,${widget.filePath}'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.namePage),
        ),
        body: WebViewWidget(controller: _controller));
  }
}

void fetchAndShowhtml(BuildContext context, String response, String name) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HtmlViewerPage(
        filePath: response,
        namePage: name,
      ),
    ),
  );
}
