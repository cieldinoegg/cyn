import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // 권한
import 'package:webview_flutter/webview_flutter.dart'; // 웹뷰
import 'package:app_settings/app_settings.dart'; // ios 설정
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // 알림

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
      debugShowCheckedModeBanner: false,
      title: 'MY APP',
      home: Scaffold(
        body: Center(child: WebViewExample()),
      ),
    );
  }
}

var Link = 'https://blog.naver.com/cieldinoegg';

class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    showNotification();
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        body: WebView(
          initialUrl: Link,
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

final notifications = FlutterLocalNotificationsPlugin();

// 앱로드시 실행할 기본설정
initNotification() async {
  // 안드로이드용 아이콘파일 이름
  var androidSetting = AndroidInitializationSettings('app_icon');
  // ios 앱 로드시 유저에게 권한요청
  var iosSetting = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings =
      InitializationSettings(android: androidSetting, iOS: iosSetting);

  await notifications.initialize(
      initializationSettings,
      // 알림 누를때 온 페이지로 이동
      onSelectNotification: (String? payload) async {
    //onSelectNotification은 알림을 선택했을때 발생
    if (payload != null) {
      Link = noticeLink;
      WebViewExampleState();
    }
  });
}

var noticeLink;

showNotification() async {
  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 서버에서 알림이 오면 정보 받기
  String noticeName = '제목';
  String noticeInform = '내용';
  noticeLink = 'https://blog.naver.com/cieldinoegg/222611323546';

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(1, noticeName, noticeInform,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: noticeLink // 부가정보
      );
}
