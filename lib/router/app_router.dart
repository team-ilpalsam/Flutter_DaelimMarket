import 'package:get/get.dart';
import 'package:daelim_market/screen/main/chat/chat_screen.dart';
import 'package:daelim_market/screen/main/detail/image_viewer_screen.dart';
import 'package:daelim_market/screen/main/main_screen.dart';
import 'package:daelim_market/screen/main/detail/detail_screen.dart';
import 'package:daelim_market/screen/main/mypage/mypage_screen.dart';
import 'package:daelim_market/screen/main/mypage/mypage_setting_screen.dart';
import 'package:daelim_market/screen/main/mypage/mypage_history_screen.dart';
import 'package:daelim_market/screen/main/search/search_screen.dart';
import 'package:daelim_market/screen/main/upload/upload_screen.dart';
import 'package:daelim_market/screen/splash_screen.dart';
import 'package:daelim_market/screen/welcome/account_done_screen.dart';
import 'package:daelim_market/screen/welcome/account_setting_screen.dart';
import 'package:daelim_market/screen/welcome/login/forgot/forgot_screen.dart';
import 'package:daelim_market/screen/welcome/login/login_screen.dart';
import 'package:daelim_market/screen/welcome/register/register_vefiry_screen.dart';
import 'package:daelim_market/screen/welcome/register/register_screen.dart';
import 'package:daelim_market/screen/welcome/welcome_screen.dart';

class AppRouter {
  static List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => const SplashScreen(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: '/welcome',
      page: () => const WelcomeScreen(),
      transition: Transition.noTransition,
    ),

    // 회원가입
    GetPage(
      name: '/register',
      page: () => RegisterScreen(),
      transition: Transition.noTransition,
    ),

    // 회원가입 인증 안내 페이지
    GetPage(
      name: '/register/authlink',
      page: () => RegisterVefiryScreen(
        email: Get.parameters['email'] ?? '',
      ),
      transition: Transition.cupertino,
    ),

    // 계정 설정 페이지
    GetPage(
      name: '/register/setting',
      page: () => AccountSettingScreen(),
      transition: Transition.noTransition,
    ),

    // 계정 설정 완료 페이지
    GetPage(
      name: '/register/setting/done',
      page: () => AccountDoneScreen(),
      transition: Transition.noTransition,
    ),

    // 로그인
    GetPage(
      name: '/login',
      page: () => LoginScreen(),
      transition: Transition.noTransition,
    ),

    // 비밀번호 찾기 페이지
    GetPage(
      name: '/login/forgot',
      page: () => ForgotScreen(),
      transition: Transition.noTransition,
    ),

    // 메인 페이지
    GetPage(
      name: '/main',
      page: () => MainScreen(),
      transition: Transition.noTransition,
    ),

    // 상세 페이지
    GetPage(
      name: '/detail',
      page: () => DetailScreen(
        productId: Get.parameters['productId']!,
      ),
      transition: Transition.cupertino,
    ),

    // 검색 페이지
    GetPage(
      name: '/search',
      page: () => SearchScreen(),
      transition: Transition.noTransition,
    ),

    // 판매 물건 등록 페이지
    GetPage(
      name: '/main/upload',
      page: () => UploadScreen(),
      fullscreenDialog: true,
      transition: Transition.cupertino,
    ),

    // 이미지 자세히 보기
    GetPage(
      name: '/detail/image',
      page: () => ImageViewerScreen(
        src: Get.parameters['src']!,
      ),
      fullscreenDialog: true,
      transition: Transition.cupertino,
    ),

    // 마이페이지 설정 페이지
    GetPage(
      name: '/mypage_setting',
      page: () => MypageSettingScreen(),
      transition: Transition.cupertino,
    ),

    // 마이페이지 스크린 페이지
    GetPage(
      name: '/mypage_screen',
      page: () => MypageScreen(),
      transition: Transition.cupertino,
    ),

    // 채팅 설정 페이지
    GetPage(
      name: '/chat',
      page: () => ChatScreen(
        userUID: Get.parameters['userUID']!,
      ),
      transition: Transition.cupertino,
    ),

    // 내역 스크린 페이지
    GetPage(
      name: '/history',
      page: () => MyHistoryScreen(
        history: Get.parameters['history']!,
      ),
      transition: Transition.cupertino,
    ),
  ];
}
