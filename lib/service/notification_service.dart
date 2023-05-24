import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notification = FlutterLocalNotificationsPlugin();

class NotificationService {
  initializeNotification() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'daelim_market', // id
      '대림마켓', // title
      importance: Importance.max,
    );
    const initializationSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingAndroid,
      iOS: initializationSettingIOS,
    );

    await notification.initialize(initializationSettings);
    await notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
