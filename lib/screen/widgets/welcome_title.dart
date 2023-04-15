import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WelcomeTitle extends StatelessWidget {
  final String? image;
  final String title;
  final VoidCallback? onTap;

  const WelcomeTitle({
    super.key,
    this.image,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 71.h,
        ),
        image == null
            ? SizedBox(
                height: 18.h,
              )
            : GestureDetector(
                onTap: onTap ??
                    () {
                      context.pop();
                    },
                child: Image.asset(
                  image!,
                  height: 18.h,
                ),
              ),
        SizedBox(
          height: 52.h,
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 32.sp,
            fontWeight: bold,
            color: dmBlack,
          ),
        )
      ],
    );
  }
}
