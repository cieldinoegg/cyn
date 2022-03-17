import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // 알림

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

  var initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting
  );

  await notifications.initialize(
      initializationSettings,
      // 알림 누를때 온 페이지로 이동
      // onSelectNotification: (payload) {
      //  updateUrl(payload);
      // } 구현중..
  );
}

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
  String noticeLink = 'https://velog.io/@gwd0311/Flutter-%ED%91%B8%EC%8B%9C%EC%95%8C%EB%A6%BC-%EA%B5%AC%ED%98%84';

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,
      noticeName,
      noticeInform,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: noticeLink // 부가정보
  );
}