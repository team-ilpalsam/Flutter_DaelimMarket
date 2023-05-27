import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/alert_dialog.dart';
import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/screen/widgets/welcome_appbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:daelim_market/main.dart';
import 'package:image_picker/image_picker.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({
    super.key,
  });

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
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

  late TextEditingController nickNameController = TextEditingController();
  XFile? _pickedImage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: dmWhite,
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const WelcomeAppbar(
                        title: '계정 설정',
                      ),
                      SizedBox(
                        height: 23.h,
                      ),
                      Text(
                        '게시물에는 닉네임으로 표시돼요!',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18.sp,
                          fontWeight: bold,
                          color: dmBlack,
                        ),
                      ),
                      // Contents
                      SizedBox(
                        height: 50.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              AlertDialogWidget.twoButtons(
                                  context: context,
                                  content: "프로필 사진을 선택해주세요!",
                                  button: [
                                    "앨범에서 선택",
                                    "카메라로 촬영"
                                  ],
                                  color: [
                                    dmBlue,
                                    dmBlue
                                  ],
                                  action: [
                                    () {
                                      Navigator.pop(context);
                                      try {
                                        ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery)
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
                                            .pickImage(
                                                source: ImageSource.camera)
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
                                  ]);
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
                                            image: Image.file(
                                                    File(_pickedImage!.path))
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
                                  left: 73.w,
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
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Text(
                        '닉네임(8자 이내)',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 21.sp,
                          fontWeight: bold,
                          color: dmBlack,
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      TextField(
                        enabled: _isLoading ? false : true,
                        controller: nickNameController,
                        cursorHeight: 24.h,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣0-9]')),
                          LengthLimitingTextInputFormatter(8),
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        style: welcomeInputTextDeco,
                        decoration: welcomeInputDeco(),
                        cursorColor: dmBlack,
                      ),

                      // Bottom
                      const Expanded(child: SizedBox()),
                      nickNameController.text.length >= 2
                          ? GestureDetector(
                              onTap: () async {
                                _isLoading
                                    ? null
                                    : AlertDialogWidget.twoButtons(
                                        context: context,
                                        content: '저장 하시겠습니까?',
                                        button: ['취소', '확인'],
                                        color: [dmLightGrey, dmBlue],
                                        action: [
                                          () {
                                            Navigator.pop(context);
                                          },
                                          () async {
                                            Navigator.pop(context);
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            if (nickNameController
                                                    .text.length >=
                                                2) {
                                              // 닉네임에 공백 혹은 특수문자가 포함될 경우
                                              if (!RegExp(r'^[a-zA-Z가-힣0-9]+$')
                                                  .hasMatch(nickNameController
                                                      .text)) {
                                                WarningSnackBar.show(
                                                    context: context,
                                                    text:
                                                        '닉네임에 사용할 수 없는 문자가 있어요.');
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                return;
                                              }
                                              // 정상일 경우
                                              else {
                                                await updateNickname(
                                                    nickNameController.text);
                                              }
                                            }
                                            if (_pickedImage != null) {
                                              await updateProfileImage(
                                                  _pickedImage!);
                                            }
                                            if (mounted) {
                                              nickNameController.clear();
                                            }
                                          }
                                        ],
                                      );
                              },
                              child: _isLoading == true // Loading 상태일 경우
                                  ? const LoadingButton(
                                      color: dmLightGrey,
                                    )
                                  : const BlueButton(text: '입력 완료'))
                          : const BlueButton(text: '입력 완료', color: dmLightGrey),
                      bottomPadding,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Firebase Firestore에 user 컬렉션에서 닉네임 업데이트
  updateNickname(String nickName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('nickName', isEqualTo: nickName)
          .get();

      if (snapshot.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .update({'nickName': nickName});

        setState(() {
          _isLoading = false;
        });

        context.go('/register/setting/done');
      } else {
        WarningSnackBar.show(
          context: context,
          text: '중복된 닉네임입니다.',
          paddingBottom: 0,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      if (mounted) {
        WarningSnackBar.show(context: context, text: '닉네임 변경 중 오류가 발생했어요.');
      }
    }
  }

  // Firebase Firestore에 user 컬렉션에서 프로필 이미지 업데이트
  updateProfileImage(XFile imagePath) async {
    try {
      // 기존 이미지 업로드
      final userRef = FirebaseStorage.instance
          .ref()
          .child('profile/$uid/$uid.${_pickedImage!.path.split('.').last}');
      UploadTask uploadTask =
          userRef.putData(File(imagePath.path).readAsBytesSync());
      // 만약 사진 업로드 성공 시
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      // 사진의 다운로드 가능한 url을 불러온 후
      final url = await taskSnapshot.ref.getDownloadURL();

      debugPrint(url);

      await FirebaseFirestore.instance
          .collection('user')
          .doc('$uid')
          .update({'profile_image': url});
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        WarningSnackBar.show(context: context, text: '프로필 사진 업로드 중 오류가 발생했어요.');
      }
    }
  }
}
