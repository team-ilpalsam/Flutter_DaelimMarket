import 'package:daelim_market/router/app_router.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 비동기 메소드 사용시 필수
  WidgetsFlutterBinding.ensureInitialized();

  // intl 초기화
  await initializeDateFormatting('ko_KR', null);

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 운영체제의 상태 바와 네비게이션 바의 색상 조정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: dmWhite,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: dmWhite,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // 세로 방향 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const DaelimMarket());
}

class DaelimMarket extends StatelessWidget {
  const DaelimMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            scaffoldBackgroundColor: dmWhite,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.config,
        );
      },
    );
  }
}
