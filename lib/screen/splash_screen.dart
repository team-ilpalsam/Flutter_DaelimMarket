import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/service/connection_check_service.dart';
import 'package:daelim_market/const/image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  String userNickname = '';

  _asyncMethod() async {
    await ConnectionCheckService().connectionCheck(context);

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
              context.go('/register/setting');
            } else {
              await const FlutterSecureStorage().write(
                  key: 'nickname', value: '${userData.data()?['nickName']}');
              nickName =
                  await const FlutterSecureStorage().read(key: 'nickname');
              context.go('/main');
            }
          } else {
            WarningSnackBar.show(
              context: context,
              text: '이메일 인증이 안 된 계정이에요.',
              paddingHorizontal: 20.w,
            );
            context.go('/login');
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
          context: context,
          text: '자동 로그인에 실패했어요.',
        );
        // 로그인 실패 시 FlutterSecureStorage 내 데이터 모두 삭제
        await const FlutterSecureStorage().deleteAll();
        context.go('/welcome');
      }
    } else {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
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
