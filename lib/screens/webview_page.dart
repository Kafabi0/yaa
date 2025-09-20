// lib/screens/webview_page.dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HybridWebView extends StatelessWidget {
  final String url;
  const HybridWebView({super.key, required this.url});

  Future<void> _openInBrowser() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      // 👉 Kalau Web/Windows/Linux/MacOS → langsung buka di browser
      _openInBrowser();
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 👉 Kalau Android/iOS → embed WebView
    return Scaffold(
      appBar: AppBar(title: const Text("Artikel Kesehatan")),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
