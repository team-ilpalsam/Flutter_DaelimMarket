import 'package:cached_network_image/cached_network_image.dart';
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

    if (mounted) {
      setState(() {
        _width = decodedImage.width;
        _height = decodedImage.height;
      });
    }
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
      body: Stack(
        children: [
          Center(
              child: _height != null
                  ? InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 5.0,
                      constrained: true,
                      child: _height! > MediaQuery.of(context).size.height &&
                              _width! == MediaQuery.of(context).size.width
                          ? CachedNetworkImage(
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              imageUrl: widget.src,
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
                                imageUrl: widget.src,
                                placeholder: (context, url) =>
                                    const CupertinoActivityIndicator(),
                                fit: BoxFit.fitWidth,
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
                SizedBox(height: 72.h),
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
    );
  }
}
