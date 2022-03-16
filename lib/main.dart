import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // 권한
import 'package:webview_flutter/webview_flutter.dart'; // 웹뷰
import 'package:app_settings/app_settings.dart'; // ios 설정
import 'notification.dart'; // 알림


void main() {
  runApp(MyApp());
}

getPermission() async {
  var status = await Permission.contacts.status;
  if (status.isDenied) {
    if (Platform.isIOS) {
      return Row(
        children: const <Widget>[
          ElevatedButton(
            onPressed: AppSettings.openLocationSettings,
            child: Text('Open Location Settings'),
          ),
        ],
      ); // 허락해달라고 팝업띄우는 코드
    } else {
      [
        Permission.camera,
        Permission.locationAlways,
        Permission.storage,
        Permission.location,
        Permission.bluetooth
      ].request();
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initNotification();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MY APP',
      home: Scaffold(
        body: Center(child: WebViewExample()),
      ),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    showNotification();
    // Enable hybrid composition.
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        body: WebView(
          initialUrl: 'https://blog.naver.com/cieldinoegg',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (_webViewController == null) {
      return true;
    }
    if (await _webViewController!.canGoBack()) {
      _webViewController!.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
