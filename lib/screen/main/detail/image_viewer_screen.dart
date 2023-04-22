import 'dart:ui';

import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ImageViewerScreen extends StatefulWidget {
  final String src;

  const ImageViewerScreen({super.key, required this.src});

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  int? _width;
  int? _height;

  Future<void> getImageSize(String imageUrl) async {
    final ByteData data =
        await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
    final Uint8List bytes = data.buffer.asUint8List();

    final decodedImage = await decodeImageFromList(bytes);

    setState(() {
      _width = decodedImage.width;
      _height = decodedImage.height;
    });
  }

  @override
  void initState() {
    super.initState();
    getImageSize(widget.src);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dmBlack,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
                child: _height != null
                    ? InteractiveViewer(
                        maxScale: 5.0,
                        constrained: true,
                        child: _height! > MediaQuery.of(context).size.height &&
                                _width! == MediaQuery.of(context).size.width
                            ? Image.network(
                                widget.src,
                                width: MediaQuery.of(context).size.width,
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Image.network(
                                  fit: BoxFit.fitWidth,
                                  widget.src,
                                ),
                              ),
                      )
                    : const Center(
                        child: CupertinoActivityIndicator(
                        color: dmWhite,
                      ))),
            Positioned(
              top: 0,
              left: 0,
              child: Column(
                children: [
                  topPadding,
                  window.viewPadding.top > 0
                      ? SizedBox(height: 20.h)
                      : SizedBox(height: 84.h),
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
