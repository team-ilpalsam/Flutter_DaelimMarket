import 'dart:io';
import 'dart:ui';

import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descController;

  final List<String> _locationList = [
    '전체',
    '다산관',
    '생활관',
    '수암관',
    '율곡관',
    '임곡관',
    '자동차관',
    '전산관',
    '정보통신관',
    '퇴계관',
    '한림관',
    '홍지관',
  ];

  String _selectedLocation = '장소 선택';

  @override
  void initState() {
    titleController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    priceController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    descController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descController.dispose();
    super.dispose();
  }

  List<XFile>? _pickedImages;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                window.viewPadding.top > 0
                    ? SizedBox(height: 7.h)
                    : SizedBox(height: 71.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Image.asset(
                          'assets/images/icons/icon_back.png',
                          alignment: Alignment.topLeft,
                          height: 18.h,
                        ),
                      ),
                      const Spacer(flex: 200),
                      Text(
                        "물건 등록",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 22.sp,
                          fontWeight: medium,
                          color: dmBlack,
                        ),
                      ),
                      const Spacer(flex: 165),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "완료",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18.sp,
                            fontWeight: medium,
                            color: dmBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Divider(
                  thickness: 1.w,
                  color: dmGrey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32.5.h),
                      Text(
                        '사진 (${_pickedImages?.length ?? '0'}/5)',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18.sp,
                          fontWeight: medium,
                          color: dmBlack,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _pickedImages?.length == null || _pickedImages!.isEmpty
                          ? GestureDetector(
                              onTap: () async {
                                try {
                                  await ImagePicker()
                                      .pickMultiImage()
                                      .then((xfile) {
                                    if (xfile == null) return;
                                    if (xfile.length > 5) {
                                      WarningSnackBar.show(
                                          context: context,
                                          text: '사진은 5장까지만 올릴 수 있어요!');
                                      return;
                                    }
                                    setState(() {
                                      _pickedImages = xfile;
                                      debugPrint(_pickedImages.toString());
                                    });
                                  });
                                } catch (e) {
                                  WarningSnackBar.show(
                                      context: context,
                                      text: '사진을 불러오는 중 실패했어요.');
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 96.w,
                                    height: 96.w,
                                    color: dmGrey,
                                  ),
                                  Image.asset(
                                      'assets/images/icons/icon_add.png',
                                      height: 43.85.h)
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _pickedImages!.map(
                                  (value) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: 10.w,
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: 96.w,
                                            height: 96.w,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image:
                                                    Image.file(File(value.path))
                                                        .image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5.h,
                                            right: 5.w,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _pickedImages!
                                                      .remove((value));
                                                });
                                              },
                                              child: Container(
                                                width: 20.w,
                                                height: 20.h,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: dmWhite,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 15.w,
                                                    color: dmBlack,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Divider(
                        thickness: 1.w,
                        color: dmGrey,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 40.h,
                        child: TextField(
                          controller: titleController,
                          style: mainInputTextDeco,
                          decoration: mainInputDeco('글 제목'),
                          cursorColor: dmBlack,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 40.h,
                        child: TextField(
                          controller: priceController,
                          style: mainInputTextDeco,
                          decoration: mainInputDeco('가격 (1억 미만)'),
                          cursorColor: dmBlack,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (_) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 250.h,
                                  child: CupertinoPicker(
                                    backgroundColor: Colors.white,
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        _selectedLocation =
                                            _locationList[index];
                                      });
                                    },
                                    itemExtent: 40.h,
                                    children: _locationList.map((value) {
                                      return Center(child: Text(value));
                                    }).toList(),
                                  ),
                                );
                              });
                        },
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.w,
                              color: dmLightGrey,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 10.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedLocation,
                                  style: mainInputTextDeco,
                                ),
                                Image.asset(
                                  'assets/images/icons/icon_arrow_down.png',
                                  height: 11.5.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 200.h,
                        child: TextField(
                          controller: descController,
                          keyboardType: TextInputType.multiline,
                          expands: true,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          style: mainInputTextDeco,
                          decoration: mainInputDeco('설명글'),
                          cursorColor: dmBlack,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
