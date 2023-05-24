import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notification = FlutterLocalNotificationsPlugin();

class NotificationService {
  initializeNotification() async {
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
  }
}
