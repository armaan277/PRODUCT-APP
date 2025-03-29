import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class RefundPolicyFaqsScreen extends StatelessWidget {
  final String url;
  const RefundPolicyFaqsScreen({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(url),
        ),
      ),
    );
  }
}
