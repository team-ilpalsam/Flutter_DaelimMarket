import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/main.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/const/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  final String userNickname = '';

  Future<void> _asyncMethod(BuildContext context) async {
    id = await const FlutterSecureStorage().read(key: 'id');
    uid = await const FlutterSecureStorage().read(key: 'uid');
    email = await const FlutterSecureStorage().read(key: 'email');
    password = await const FlutterSecureStorage().read(key: 'password');

    // 만약 FlutterSecureStorage에서 받아온 데이터가 있을 경우
    if (email != null && uid != null) {
      try {
        // 로그인 시도
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password!)
            .then((value) async {
          // 계정 인증 여부 확인
          if (value.user!.emailVerified == true) {
            var userData = await FirebaseFirestore.instance
                .collection('user') // user 컬렉션으로부터
                .doc(uid) // 넘겨받은 uid 필드의 데이터를
                .get();

            if (userData.data()?['nickName'] == '') {
              Get.offAllNamed('/register/setting');
            } else {
              await const FlutterSecureStorage().write(
                  key: 'nickname', value: '${userData.data()?['nickName']}');
              Get.offAllNamed('/main');
            }
          } else {
            WarningSnackBar.show(
              text: '이메일 인증이 안 된 계정이에요.',
              paddingHorizontal: 20.w,
            );
            Get.offAllNamed('/login');
          }
        });

        await FirebaseMessaging.instance.getToken().then((value) {
          FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .update({'token': value});
        });
      } on FirebaseAuthException {
        WarningSnackBar.show(
          text: '자동 로그인에 실패했어요.',
        );
        // 로그인 실패 시 FlutterSecureStorage 내 데이터 모두 삭제
        await const FlutterSecureStorage().deleteAll();
        Get.offAllNamed('/welcome');
      }
    } else {
      Get.offAllNamed('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    _asyncMethod(context);
    return Scaffold(
      body: Center(
        child: Image.asset(
          textLessLogo,
          height: 183.w,
        ),
      ),
    );
  }
}
