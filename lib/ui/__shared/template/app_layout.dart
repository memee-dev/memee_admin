import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final Widget mobView;
  final Widget webView;
  final AppBar? mobAppBar;
  final AppBar? webAppBar;

  const AppLayout({
    super.key,
    required this.mobView,
    required this.webView,
    this.mobAppBar,
    this.webAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth > 600) {
          return Scaffold(
            appBar: webAppBar,
            body: webView,
          );
        } else {
          return Scaffold(
            appBar: mobAppBar,
            body: webView,
          );
        }
      },
    );
  }
}
