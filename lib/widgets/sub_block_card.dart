import 'package:flutter/material.dart';   
import 'dart:ui_web' as ui;    // ✅ 加這個
import 'dart:html' as html;   // ✅ for IFrameElement

class SubBlockCard extends StatelessWidget {
  const SubBlockCard({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    const String viewID = '';

    // ✅ 註冊 iframe
    ui.platformViewRegistry.registerViewFactory(
      viewID,
      (int viewId) => html.IFrameElement()
        ..src =
            "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d4564.923081374492!2d120.80978997621266!3d24.54582727813607!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3469abe42d8e979b%3A0x9d6d4ad3e3cc484f!2z5ZyL56uL6IGv5ZCI5aSn5a24IOS6jOWdquWxseagoeWNgA!5e1!3m2!1szh-TW!2stw!4v1758716611063!5m2!1szh-TW!2stw"
        ..style.border = '0'
        ..width = '650'
        ..height = '800'
        ..allowFullscreen = true,
    );

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 1000,
          height: 1000,
          child: HtmlElementView(viewType: viewID),
        ),
      ),
    );
  }
}
