import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/alert_dialog.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descController;

  bool _isLoading = false;

  DateTime now = DateTime.now();

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

  @override
  void deactive() {
    super.deactivate();
  }

  List<XFile>? _pickedImages;
  List<String> downloadUrls = [];

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
                MainAppbar.leadingAndAction(
                  title: '물건 등록',
                  leading: GestureDetector(
                    onTap: () {
                      _isLoading
                          ? null
                          : AlertDialogWidget.twoButtons(
                              context: context,
                              content: '등록을 취소하시겠습니까?\n작성한 내용은 저장되지 않습니다.',
                              button: ['취소', '나갈래요'],
                              color: [dmGrey, dmBlue],
                              action: [
                                () {
                                  Navigator.pop(context);
                                },
                                () {
                                  Navigator.pop(context);
                                  context.pop();
                                }
                              ],
                            );
                    },
                    child: Image.asset(
                      'assets/images/icons/icon_back.png',
                      alignment: Alignment.topLeft,
                      height: 18.h,
                    ),
                  ),
                  action: titleController.text.length >= 3 &&
                          priceController.text.isNotEmpty &&
                          _selectedLocation != '장소 선택' &&
                          _pickedImages != null
                      ? GestureDetector(
                          onTap: () {
                            _isLoading
                                ? null
                                : AlertDialogWidget.twoButtons(
                                    context: context,
                                    content: '판매 글을 등록하시겠습니까?',
                                    button: ['아직이요', '등록할래요!'],
                                    color: [dmGrey, dmBlue],
                                    action: [
                                      () {
                                        Navigator.pop(context);
                                      },
                                      () async {
                                        Navigator.pop(context);
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        try {
                                          String id =
                                              await const FlutterSecureStorage()
                                                      .read(key: "id") ??
                                                  'null';
                                          String uid =
                                              await const FlutterSecureStorage()
                                                      .read(key: "uid") ??
                                                  'null';
                                          String productId =
                                              '${id}_${DateFormat('yyyyMMddHHmmss').format(now)}';

                                          await Future.wait(_pickedImages!
                                              .asMap()
                                              .entries
                                              .map((entry) async {
                                            final index = entry.key;
                                            final value = entry.value;

                                            Reference ref = FirebaseStorage
                                                .instance
                                                .ref()
                                                .child(
                                                    'product/$productId/${productId}_$index.${value.path.split('.').last}');
                                            final UploadTask uploadTask =
                                                ref.putData(File(value.path)
                                                    .readAsBytesSync());
                                            final TaskSnapshot taskSnapshot =
                                                await uploadTask
                                                    .whenComplete(() {});

                                            final url = await taskSnapshot.ref
                                                .getDownloadURL();

                                            downloadUrls.add(url.toString());

                                            debugPrint(uploadTask.toString());
                                            debugPrint(taskSnapshot.toString());

                                            await FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(uid)
                                                .update({
                                              'posts': FieldValue.arrayUnion(
                                                  [productId])
                                            });

                                            await FirebaseFirestore.instance
                                                .collection('product')
                                                .doc(productId)
                                                .set({
                                              'id': id,
                                              'product_id': productId,
                                              'nickName': '',
                                              'price': priceController.text,
                                              'title': titleController.text,
                                              'location':
                                                  _selectedLocation == '장소 선택'
                                                      ? '전체'
                                                      : _selectedLocation,
                                              'desc': descController.text,
                                              'images': downloadUrls,
                                              'likes': [],
                                              'uploadTime': now,
                                            });
                                          }));

                                          context.go('/main');
                                          DoneSnackBar.show(
                                            context: context,
                                            text: '성공적으로 등록했어요!',
                                            paddingHorizontal: 0,
                                            paddingBottom: 0,
                                          );
                                        } catch (e) {
                                          context.go('/main');
                                          WarningSnackBar.show(
                                            context: context,
                                            text: '판매글 등록 중 문제가 생겼어요.',
                                            paddingHorizontal: 0,
                                            paddingBottom: 0,
                                          );
                                          debugPrint(e.toString());
                                        }
                                      }
                                    ],
                                  );
                          },
                          child: _isLoading == true
                              ? const CupertinoActivityIndicator()
                              : Text(
                                  "완료",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18.sp,
                                    fontWeight: medium,
                                    color: dmBlue,
                                  ),
                                ),
                        )
                      : Text(
                          "완료",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18.sp,
                            fontWeight: medium,
                            color: dmLightGrey,
                          ),
                        ),
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
                                        text: '사진은 5장까지만 올릴 수 있어요!',
                                        paddingHorizontal: 0,
                                      );
                                      return;
                                    }
                                    setState(() {
                                      _pickedImages = xfile;
                                    });
                                  });
                                } catch (e) {
                                  WarningSnackBar.show(
                                    context: context,
                                    text: '사진을 불러오는 중 실패했어요.',
                                    paddingHorizontal: 0,
                                  );
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
                                          _isLoading
                                              ? Container()
                                              : Positioned(
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
                                                      decoration:
                                                          const BoxDecoration(
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
                          enabled: _isLoading ? false : true,
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
                          enabled: _isLoading ? false : true,
                          controller: priceController,
                          style: mainInputTextDeco,
                          decoration: mainInputDeco('가격 (1억 미만)'),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(8),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorColor: dmBlack,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      GestureDetector(
                        onTap: _isLoading
                            ? () {}
                            : () {
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
                              color: _isLoading ? dmDarkGrey : dmLightGrey,
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
                          enabled: _isLoading ? false : true,
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
                      const SizedBox(
                        height: 10,
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
