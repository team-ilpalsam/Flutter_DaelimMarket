// import 'package:daelim_market/screen/welcome/account_setting_screen.dart';
import 'package:daelim_market/screen/main/main_screen.dart';
import 'package:daelim_market/screen/main/upload/upload_screen.dart';
import 'package:daelim_market/screen/splash_screen.dart';
import 'package:daelim_market/screen/welcome/account_done_screen.dart';
import 'package:daelim_market/screen/welcome/account_setting_screen.dart';
import 'package:daelim_market/screen/welcome/login/forgot/forgot_authcode_screen.dart';
import 'package:daelim_market/screen/welcome/login/forgot/forgot_change_screen.dart';
import 'package:daelim_market/screen/welcome/login/forgot/forgot_screen.dart';
import 'package:daelim_market/screen/welcome/login/login_screen.dart';
import 'package:daelim_market/screen/welcome/register/register_vefiry_screen.dart';
import 'package:daelim_market/screen/welcome/register/register_screen.dart';
import 'package:daelim_market/screen/welcome/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static var config = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: WelcomeScreen(),
        ),
      ),

      // 회원가입
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        name: 'registerAuthLink',
        path: '/register/authlink',
        builder: (context, state) => RegisterVefiryScreen(
          email: state.queryParams['email'] ?? '',
        ),
      ),

      GoRoute(
        name: 'accountSetting',
        path: '/register/setting',
        builder: (context, state) => const AccountSettingScreen(),
      ),

      GoRoute(
        name: 'accountSettingDone',
        path: '/register/setting/done',
        builder: (context, state) => const AccountDoneScreen(),
      ),

      // 로그인
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/login/forgot',
        builder: (context, state) => const ForgotScreen(),
      ),

      GoRoute(
        name: 'forgotAuthCode',
        path: '/login/forgot/authcode',
        builder: (context, state) => ForgotAuthCodeScreen(
          email: state.queryParams['email'] ?? '',
        ),
      ),

      GoRoute(
        name: 'changePassword',
        path: '/login/forgot/change',
        builder: (context, state) => const ForgotChangeScreen(),
      ),

      // 메인 페이지
      GoRoute(
        name: 'main',
        path: '/main',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainScreen(),
        ),
      ),

      // 판매 물건 등록 페이지
      GoRoute(
        path: '/main/upload',
        pageBuilder: (context, state) => const CupertinoPage(
          fullscreenDialog: true,
          child: UploadScreen(),
        ),
      ),
    ],
  );
}
