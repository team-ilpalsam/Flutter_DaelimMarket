import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../screen/widgets/alert_dialog.dart';

class ConnectionCheckService {
  connectionCheck(BuildContext context) async {
    var result = await (Connectivity().checkConnectivity());
    // 인터넷 연결 확인
    if (result == ConnectivityResult.none) {
      AlertDialogWidget.oneButton(
        content: '인터넷 연결을 확인하세요.',
        button: '확인',
        action: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
      );
    }
  }
}
