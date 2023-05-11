import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notification = FlutterLocalNotificationsPlugin();

class DMNotificationService {
  Future<void> initializeNotification() async {
    const initializationSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingAndroid,
      iOS: initializationSettingIOS,
    );

    await notification.initialize(initializationSettings);
  }

  Future<bool> get permissionNotification async {
    if (Platform.isAndroid) {
      return true;
    }
    if (Platform.isIOS) {
      return await notification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }

    return false;
  }
}
