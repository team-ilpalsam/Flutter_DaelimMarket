import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:daelim_market/screen/widgets/alert_dialog.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/styles/image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    var result = await (Connectivity().checkConnectivity());
    // 인터넷 연결 확인
    if (result == ConnectivityResult.none) {
      AlertDialogWidget.oneButton(
        context: context,
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
    } else {
      // FlutterSecureStorage의 email, password, uid 데이터를 변수에 대입
      String? email = await const FlutterSecureStorage().read(key: "email");
      String? password =
          await const FlutterSecureStorage().read(key: "password");
      String? uid = await const FlutterSecureStorage().read(key: "uid");

      // 만약 FlutterSecureStorage에서 받아온 데이터가 있을 경우
      if (email != null && uid != null) {
        try {
          // 로그인 시도
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password!)
              .then((value) async {
            // 계정 인증 여부 확인
            if (value.user!.emailVerified == true) {
              context.go('/main');
            } else {
              WarningSnackBar.show(
                context: context,
                text: '이메일 인증이 안 된 계정이에요.',
                paddingHorizontal: 20.w,
              );
              context.go('/login');
            }
          });
        } on FirebaseAuthException {
          WarningSnackBar.show(
            context: context,
            text: '자동 로그인에 실패했어요.',
            paddingHorizontal: 20.w,
          );
          // 로그인 실패 시 FlutterSecureStorage 내 데이터 모두 삭제
          await const FlutterSecureStorage().deleteAll();
          context.go('/welcome');
        }
      } else {
        context.go('/welcome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(
        textLessLogo,
        height: 214.w,
      ),
    ));
  }
}
