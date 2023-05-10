import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/main.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/alert_dialog.dart';

class MypageSettingScreen extends StatefulWidget {
  final VoidCallback? onTap;
  final String? userEmail;

  const MypageSettingScreen({
    this.onTap,
    this.userEmail,
    super.key,
  });

  @override
  State<MypageSettingScreen> createState() => _MypageSettingScreenState();
}

class _MypageSettingScreenState extends State<MypageSettingScreen> {
  late TextEditingController nickNameController;

  @override
  void initState() {
    nickNameController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    nickNameController.dispose();
    super.dispose();
  }

  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    debugPrint(_pickedImage?.path);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainAppbar.show(
                title: '프로필 수정',
                leading: GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Image.asset(
                    'assets/images/icons/icon_back.png',
                    alignment: Alignment.topLeft,
                    height: 18.h,
                  ),
                ),
                action: GestureDetector(
                  onTap: () async {
                    String nickName = nickNameController.text;
                    await FirebaseUtils.updateUserData(nickName);

                    context.go('/main');
                    DoneSnackBar.show(
                      context: context,
                      text: '성공적으로 등록했어요!',
                      paddingBottom: 0,
                    );

                    nickNameController.clear();
                  },
                  child: Text(
                    '저장',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18.sp,
                      fontWeight: bold,
                      color: dmBlue,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 56.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          AlertDialogWidget.twoButtons(
                            context: context,
                            content: "프로필 사진을 선택해주세요!",
                            button: ["앨범에서 선택", "카메라로 촬영"],
                            color: [dmBlue, dmBlue],
                            action: [
                              () {
                                Navigator.pop(context);
                                try {
                                  ImagePicker()
                                      .pickImage(source: ImageSource.gallery)
                                      .then((xfile) {
                                    if (xfile == null) return;
                                    setState(() {
                                      _pickedImage = XFile(xfile.path);
                                    });
                                  });
                                } catch (e) {
                                  WarningSnackBar.show(
                                      context: context,
                                      text: '사진을 불러오는 중 실패했어요.');
                                }
                              },
                              () {
                                try {
                                  ImagePicker()
                                      .pickImage(source: ImageSource.camera)
                                      .then((xfile) {
                                    if (xfile == null) return;
                                    setState(() {
                                      _pickedImage = XFile(xfile.path);
                                    });
                                  });
                                } catch (e) {
                                  WarningSnackBar.show(
                                      context: context,
                                      text: '사진을 불러오는 중 실패했어요.');
                                }
                              },
                            ],
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 105.w,
                              height: 105.h,
                              decoration: BoxDecoration(
                                image: _pickedImage != null
                                    ? DecorationImage(
                                        image:
                                            Image.file(File(_pickedImage!.path))
                                                .image,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                shape: BoxShape.circle,
                                color: dmLightGrey,
                                border: Border.all(
                                  color: dmDarkGrey,
                                  width: 1.w,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 73.h,
                              left: 73.h,
                              child: Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dmWhite,
                                  border: Border.all(
                                    color: dmLightGrey,
                                    width: 1.w,
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/icons/icon_camera.png',
                                    width: 15.w,
                                    height: 12.h,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Text(
                      "닉네임(12자 이내)",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18.sp,
                        fontWeight: medium,
                        color: dmBlack,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 40.h,
                      child: TextField(
                        controller: nickNameController,
                        style: mainInputTextDeco,
                        decoration: mainInputDeco(''),
                        cursorColor: dmBlack,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "이메일",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18.sp,
                        fontWeight: medium,
                        color: dmBlack,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
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
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            email!,
                            style: mainInputTextDeco,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Divider(
                      color: dmGrey,
                      thickness: 1.w,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/');
                      },
                      child: const Text(
                        "계정 삭제",
                        style: TextStyle(
                          color: dmLightGrey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/');
                      },
                      child: const Text(
                        "로그아웃",
                        style: TextStyle(
                          color: dmLightGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FirebaseUtils {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  // Firebase Firestore의 데이터 업데이트하기
  static Future<void> updateUserData(String nickName) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userRef = _firestore.collection('user').doc(uid);
      await userRef.update({'nickName': nickName});
    }
  }
}
