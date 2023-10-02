import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/const/common.dart';
import 'package:daelim_market/main.dart';
import 'package:daelim_market/screen/main/mypage/mypage_controller.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/alert_dialog.dart';

class MypageSettingScreen extends StatelessWidget {
  MypageSettingScreen({
    super.key,
  });

  final MypageController _controller = Get.put(MypageController());
  final RxBool _isLoading = false.obs;
  final RxString _filePath = ''.obs;
  final RxString _nickName = ''.obs;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
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
                      _isLoading.value
                          ? null
                          : AlertDialogWidget.twoButtons(
                              content: '수정을 취소하시겠습니까?\n작성한 내용은 저장되지 않습니다.',
                              button: ['아직이요', '나갈래요'],
                              color: [dmGrey, dmBlue],
                              action: [
                                () {
                                  Navigator.pop(context);
                                },
                                () {
                                  Navigator.pop(context);
                                  Get.back();
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
                  action: Obx(
                    () => _nickName.value.length >= 2 || _filePath.value != ''
                        ? GestureDetector(
                            onTap: () async {
                              _isLoading.value
                                  ? null
                                  : AlertDialogWidget.twoButtons(
                                      content: '저장 하시겠습니까?',
                                      button: ['취소', '확인'],
                                      color: [dmLightGrey, dmBlue],
                                      action: [
                                        () {
                                          Navigator.pop(context);
                                        },
                                        () async {
                                          Navigator.pop(context);
                                          _isLoading.value = true;
                                          if (_nickName.value.length >= 2) {
                                            // 닉네임에 공백 혹은 특수문자가 포함될 경우
                                            if (!RegExp(r'^[a-zA-Z가-힣0-9]+$')
                                                .hasMatch(_nickName.value)) {
                                              WarningSnackBar.show(
                                                text: '닉네임에 사용할 수 없는 문자가 있어요.',
                                                paddingBottom: 0,
                                              );

                                              _isLoading.value = false;

                                              return;
                                            }
                                            // 정상일 경우
                                            else {
                                              await updateNickname(
                                                  _nickName.value);
                                            }
                                          }
                                          if (_filePath.value != '') {
                                            await updateProfileImage(
                                                _filePath.value);
                                          }
                                          _controller.getMyData();
                                          Get.back();
                                          DoneSnackBar.show(
                                            text: '내 정보를 변경했어요!',
                                            paddingBottom: 0,
                                          );
                                        }
                                      ],
                                    );
                            },
                            child: _isLoading.value == true // Loading 상태일 경우
                                ? const CupertinoActivityIndicator()
                                : Text(
                                    "저장",
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 18.sp,
                                      fontWeight: medium,
                                      color: dmBlue,
                                    ),
                                  ),
                          )
                        : // 조건에 충족하지 못 하였을 경우 회색 글씨
                        Text(
                            "저장",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 18.sp,
                              fontWeight: medium,
                              color: dmLightGrey,
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
                            _isLoading.value
                                ? null
                                : AlertDialogWidget.twoButtons(
                                    content: "프로필 사진을 선택해주세요!",
                                    button: ["앨범에서 선택", "카메라로 촬영"],
                                    color: [dmBlue, dmBlue],
                                    action: [
                                      () {
                                        Navigator.pop(context);
                                        try {
                                          ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery)
                                              .then((xfile) async {
                                            if (xfile == null) {
                                              return;
                                            }

                                            Uint8List sizeOfXFile =
                                                await xfile.readAsBytes();
                                            if (sizeOfXFile.length >
                                                maxFileSizeInBytes) {
                                              WarningSnackBar.show(
                                                text: '5MB 미만 크기의 사진을 올려주세요!',
                                                paddingBottom: 0,
                                              );
                                            } else {
                                              _filePath.value = xfile.path;
                                            }
                                          });
                                        } catch (e) {
                                          WarningSnackBar.show(
                                            text: '사진을 불러오는 중 실패했어요.',
                                            paddingBottom: 0,
                                          );
                                        }
                                      },
                                      () {
                                        Navigator.pop(context);
                                        try {
                                          ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera)
                                              .then((xfile) async {
                                            if (xfile == null) {
                                              return;
                                            }

                                            Uint8List sizeOfXFile =
                                                await xfile.readAsBytes();
                                            if (sizeOfXFile.length >
                                                maxFileSizeInBytes) {
                                              WarningSnackBar.show(
                                                text: '5MB 미만 크기의 사진을 올려주세요!',
                                                paddingBottom: 0,
                                              );
                                            } else {
                                              _filePath.value = xfile.path;
                                            }
                                          });
                                        } catch (e) {
                                          WarningSnackBar.show(
                                            text: '사진을 불러오는 중 실패했어요.',
                                            paddingBottom: 0,
                                          );
                                        }
                                      },
                                    ],
                                  );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Obx(
                                () => _controller.myProfileImage.value == '' &&
                                        _filePath.value != ''
                                    ? Container(
                                        width: 105.w,
                                        height: 105.h,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: dmLightGrey,
                                        ),
                                      )
                                    : _filePath.value != ''
                                        ? Container(
                                            width: 105.w,
                                            height: 105.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: dmLightGrey,
                                              image: DecorationImage(
                                                image: Image.file(
                                                  File(_filePath.value),
                                                ).image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : CachedNetworkImage(
                                            fadeInDuration: Duration.zero,
                                            fadeOutDuration: Duration.zero,
                                            imageUrl: _controller
                                                .myProfileImage.value,
                                            fit: BoxFit.cover,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: 105.w,
                                              height: 105.h,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                                shape: BoxShape.circle,
                                                color: dmLightGrey,
                                                border: Border.all(
                                                  color: dmDarkGrey,
                                                  width: 1.w,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Container(
                                              width: 105.w,
                                              height: 105.h,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: dmLightGrey,
                                              ),
                                              child: const Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              ),
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
                        "닉네임(8자 이내)",
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
                          enabled: _isLoading.value ? false : true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣0-9]')),
                            LengthLimitingTextInputFormatter(8),
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          style: mainInputTextDeco,
                          decoration:
                              mainInputDeco(_controller.myNickName.value),
                          cursorColor: dmBlack,
                          onChanged: (value) {
                            _nickName.value = value;
                          },
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
                            vertical: 8.h,
                            horizontal: 10.w,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              _controller.myEmail.value,
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
                          Get.offAllNamed('/');
                        },
                        child: GestureDetector(
                          onTap: () {
                            _isLoading.value
                                ? null
                                : AlertDialogWidget.twoButtons(
                                    content: '계정을 삭제하시겠습니까?',
                                    button: [
                                        '취소',
                                        '삭제'
                                      ],
                                    color: [
                                        dmLightGrey,
                                        dmRed
                                      ],
                                    action: [
                                        () {
                                          Navigator.pop(context);
                                        },
                                        () async {
                                          Navigator.pop(context);
                                          deleteAccount();
                                        },
                                      ]);
                          },
                          child: const Text(
                            "계정삭제",
                            style: TextStyle(
                              color: dmLightGrey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          _isLoading.value
                              ? null
                              : AlertDialogWidget.twoButtons(
                                  content: '로그아웃을 하시겠습니까?',
                                  button: [
                                      '아니오',
                                      '예'
                                    ],
                                  color: [
                                      dmLightGrey,
                                      dmBlue
                                    ],
                                  action: [
                                      () {
                                        Navigator.pop(context);
                                      },
                                      () async {
                                        Navigator.pop(context);
                                        const FlutterSecureStorage()
                                            .deleteAll();
                                        await FirebaseAuth.instance.signOut();
                                        Get.offAllNamed('/welcome');
                                      }
                                    ]);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 계정 삭제 메소드
  deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      await FirebaseFirestore.instance.collection('user').doc('$uid').update({
        'deleted': true,
        'nickName': 'del_${_controller.myNickName.value}',
      });
      const FlutterSecureStorage().deleteAll();

      Get.offAllNamed('/welcome');
      DoneSnackBar.show(
        text: '계정을 삭제했어요.',
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "requires-recent-login":
          WarningSnackBar.show(
            text: '계정 삭제하기엔 너무 이릅니다.',
            paddingBottom: 0,
          );
          debugPrint(e.toString());
          _isLoading.value = false;
          break;
        default:
          WarningSnackBar.show(
            text: '계정 삭제 중 문제가 발생했어요.',
            paddingBottom: 0,
          );
          debugPrint(e.toString());
          _isLoading.value = false;
          break;
      }
    }
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
        await const FlutterSecureStorage()
            .write(key: 'nickname', value: nickName);
      } else {
        WarningSnackBar.show(
          text: '중복된 닉네임입니다.',
          paddingBottom: 0,
        );
        _isLoading.value = false;
      }
    } catch (e) {
      WarningSnackBar.show(
        text: '닉네임 변경 중 오류가 발생했어요.',
        paddingBottom: 0,
      );
      return;
    }
  }

  // Firebase Firestore에 user 컬렉션에서 프로필 이미지 업데이트
  updateProfileImage(String imagePath) async {
    try {
      // 기존 이미지 삭제
      Future.wait([
        FirebaseStorage.instance
            .ref('profile/$uid')
            .listAll()
            .then((value) => Future.wait(value.items.map((e) => e.delete())))
      ]);

      // 기존 이미지 업로드
      final userRef = FirebaseStorage.instance
          .ref()
          .child('profile/$uid/$uid.${imagePath.split('.').last}');
      UploadTask uploadTask =
          userRef.putData(File(imagePath).readAsBytesSync());
      // 만약 사진 업로드 성공 시
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      // 사진의 다운로드 가능한 url을 불러온 후
      final url = await taskSnapshot.ref.getDownloadURL();

      debugPrint(url);

      await FirebaseFirestore.instance
          .collection('user')
          .doc('$uid')
          .update({'profile_image': url});
    } catch (e) {
      WarningSnackBar.show(
        text: '프로필 사진 업로드 중 오류가 발생했어요.',
        paddingBottom: 0,
      );
      return;
    }
  }
}
