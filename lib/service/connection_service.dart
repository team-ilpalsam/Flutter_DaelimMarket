import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionService extends GetxService {
  // iOS 시뮬레이터에서 버그 발생
  // 실기기에서는 괜찮음
  late StreamSubscription<ConnectivityResult> subscription;
  RxBool isConnetected = true.obs;

  @override
  void onInit() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet) {
        if (isConnetected.value == false) {
          InfoSnackBar.show(text: '네트워크가 연결됐어요!', paddingBottom: 0);
        }
        isConnetected.value = true;
      } else {
        isConnetected.value = false;
        Get.offAllNamed('/offline');
      }

      debugPrint(result.toString());
      debugPrint(isConnetected.value.toString());
    });
    super.onInit();
  }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }
}
