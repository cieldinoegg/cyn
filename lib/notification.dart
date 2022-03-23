import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // 알림
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
      onSelectNotification: (payload) {
          url = payload;
      }
  );
}

int groupedNotificationCounter = 2;

showNotification() async {
  var androidDetails = AndroidNotificationDetails(
    'ID',
    '가끔 오는 알림',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 정보
  String noticeName = 'N.B.N';
  String noticeInform = '우리 동네에 일어난 일을 확인해 보세요';
  String noticeLink = '이동할 링크';

  // 알림 id, 제목, 내용
  notifications.show(
      groupedNotificationCounter,
      noticeName,
      noticeInform,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: noticeLink // 부가정보
  );
  groupedNotificationCounter++;

  notifications.zonedSchedule(
      1,
      'C.Y.N',
      '어제 근처에 일어난 일을 확인해 보세요',
      makeDate(9,0,0),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time
  );
}

makeDate(hour, min, sec){ // 시간 생성 함수
  var now = tz.TZDateTime.now(tz.local);
  var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
  if (when.isBefore(now)) {
    return when.add (Duration(days: 1));
  } else {
    return when;
  }
}