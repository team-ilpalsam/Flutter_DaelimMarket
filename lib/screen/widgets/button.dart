import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;

  const BlueButton({
    required this.text,
    this.color = dmBlue,
    this.textColor = dmWhite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(5.r),
        ),
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.04929,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18.sp,
            fontWeight: bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  final Color? color;

  const LoadingButton({super.key, this.color = dmBlue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(5.r),
        ),
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.04929,
      child: Center(
        child: SizedBox(
          width: 21.w,
          height: 21.h,
          child: CircularProgressIndicator(
            color: dmWhite,
            strokeWidth: 3.w,
          ),
        ),
      ),
    );
  }
}
