import 'dart:ui';

import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ImageViewerScreen extends StatelessWidget {
  final String src;

  ImageViewerScreen({super.key, required this.src});

  final transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dmBlack,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                transformationController: transformationController,
                minScale: 0.1,
                maxScale: 5.0,
                constrained: true,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.network(
                    fit: BoxFit.fitWidth,
                    src,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Column(
                children: [
                  topPadding,
                  window.viewPadding.top > 0
                      ? SizedBox(height: 7.h)
                      : SizedBox(height: 71.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Image.asset(
                        'assets/images/icons/icon_close_circle.png',
                        alignment: Alignment.topLeft,
                        height: 18.h,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
