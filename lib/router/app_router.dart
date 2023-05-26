// import 'package:daelim_market/screen/welcome/account_setting_screen.dart';
import 'package:daelim_market/screen/main/chat/chat_screen.dart';
import 'package:daelim_market/screen/main/detail/image_viewer_screen.dart';
import 'package:daelim_market/screen/main/main_screen.dart';
import 'package:daelim_market/screen/main/detail/detail_screen.dart';
import 'package:daelim_market/screen/main/mypage/mypage_screen.dart';
import 'package:daelim_market/screen/main/mypage/mypage_setting_screen.dart';
import 'package:daelim_market/screen/main/mypage/post_page_screen.dart';
import 'package:daelim_market/screen/main/upload/upload_screen.dart';
import 'package:daelim_market/screen/splash_screen.dart';
import 'package:daelim_market/screen/welcome/account_done_screen.dart';
import 'package:daelim_market/screen/welcome/account_setting_screen.dart';
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
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashScreen(),
        ),
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
        pageBuilder: (context, state) => const CupertinoPage(
          child: RegisterScreen(),
        ),
      ),

      GoRoute(
        name: 'registerAuthLink',
        path: '/register/authlink',
        pageBuilder: (context, state) => CupertinoPage(
          child: RegisterVefiryScreen(
            email: state.queryParams['email'] ?? '',
          ),
        ),
      ),

      // 계정 설정 페이지
      GoRoute(
        name: 'accountSetting',
        path: '/register/setting',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AccountSettingScreen(),
        ),
      ),

      // 계정 설정 완료 페이지
      GoRoute(
        name: 'accountSettingDone',
        path: '/register/setting/done',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AccountDoneScreen(),
        ),
      ),

      // 로그인
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const CupertinoPage(
          child: LoginScreen(),
        ),
      ),

      // 비밀번호 찾기 페이지
      GoRoute(
        path: '/login/forgot',
        pageBuilder: (context, state) => const CupertinoPage(
          child: ForgotScreen(),
        ),
      ),

      // 메인 페이지
      GoRoute(
        name: 'main',
        path: '/main',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const MainScreen(),
        ),
      ),

      // 상세 페이지
      GoRoute(
        name: 'detail',
        path: '/detail',
        pageBuilder: (context, state) => CupertinoPage(
          child: DetailScreen(
            productId: state.queryParams['productId']!,
          ),
        ),
      ),

      // 판매 물건 등록 페이지
      GoRoute(
        name: 'upload',
        path: '/main/upload',
        pageBuilder: (context, state) => const CupertinoPage(
          fullscreenDialog: true,
          child: UploadScreen(),
        ),
      ),

      // 이미지 자세히 보기
      GoRoute(
        name: 'imageviewer',
        path: '/detail/image',
        pageBuilder: (context, state) => CupertinoPage(
          fullscreenDialog: true,
          child: ImageViewerScreen(
            src: state.queryParams['src']!,
          ),
        ),
      ),

      // 마이페이지 설정 페이지
      GoRoute(
        name: 'mypagesetting',
        path: '/mypage_setting',
        pageBuilder: (context, state) => const CupertinoPage(
          child: MypageSettingScreen(),
        ),
      ),

      // 마이페이지 스크린 페이지
      GoRoute(
        name: 'mypagescreen',
        path: '/mypage_screen',
        pageBuilder: (context, state) => const CupertinoPage(
          child: MypageScreen(),
        ),
      ),

      // 채팅 설정 페이지
      GoRoute(
        name: 'chat',
        path: '/chat',
        pageBuilder: (context, state) => CupertinoPage(
          child: ChatScreen(
            userUID: state.queryParams['userUID']!,
          ),
        ),
      ),

      // 포스트 스크린 페이지
      GoRoute(
        name: 'postpagescreen',
        path: '/post_page_screen',
        pageBuilder: (context, state) => CupertinoPage(
          child: PostPageScreen(),
        ),
      ),
    ],
  );
}
