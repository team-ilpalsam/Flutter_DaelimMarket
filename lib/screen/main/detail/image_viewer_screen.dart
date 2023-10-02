import 'package:cached_network_image/cached_network_image.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ImageViewerScreen extends StatelessWidget {
  final String src;

  ImageViewerScreen({super.key, required this.src});

  final RxInt _width = 0.obs;
  final RxInt _height = 0.obs;

  Future<void> getImageSize(String imageUrl) async {
    final ByteData data =
        await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
    final Uint8List bytes = data.buffer.asUint8List();

    final decodedImage = await decodeImageFromList(bytes);

    _width.value = decodedImage.width;
    _height.value = decodedImage.height;
  }

  @override
  Widget build(BuildContext context) {
    getImageSize(src);
    return Scaffold(
      backgroundColor: dmBlack,
      body: Stack(
        children: [
          Center(
              child: Obx(
            () => _height.value != 0
                ? InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 5.0,
                    constrained: true,
                    child: _height.value > MediaQuery.of(context).size.height &&
                            _width.value == MediaQuery.of(context).size.width
                        ? CachedNetworkImage(
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            imageUrl: src,
                            placeholder: (context, url) =>
                                const CupertinoActivityIndicator(),
                            width: MediaQuery.of(context).size.width,
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: CachedNetworkImage(
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              imageUrl: src,
                              placeholder: (context, url) =>
                                  const CupertinoActivityIndicator(),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                  )
                : const Center(
                    child: CupertinoActivityIndicator(
                    color: dmWhite,
                  )),
          )),
          Positioned(
            top: 0,
            left: 0,
            child: Column(
              children: [
                SizedBox(height: 72.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
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
    );
  }
}
