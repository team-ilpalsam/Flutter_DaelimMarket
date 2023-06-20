import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/main.dart';
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
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    nickNameController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  XFile? _pickedImage;

  String userNickname = '';
  String userProfileImage = '';
  String userEmail = '';

  getUserData() async {
    var userData = await FirebaseFirestore.instance
        .collection('user') // user 컬렉션으로부터
        .doc(uid) // 넘겨받은 uid 필드의 데이터를
        .get();

    setState(() {
      userProfileImage = userData.data()?['profile_image'];
      userNickname = userData.data()?['nickName'];
      userEmail = userData.data()?['email'];
    });
  }

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
                      context.pop();
                    },
                    child: Image.asset(
                      'assets/images/icons/icon_back.png',
                      alignment: Alignment.topLeft,
                      height: 18.h,
                    ),
                  ),
                  action: nickNameController.text.length >= 2 ||
                          _pickedImage != null
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
                                        if (nickNameController.text.length >=
                                            2) {
                                          // 닉네임에 공백 혹은 특수문자가 포함될 경우
                                          if (!RegExp(r'^[a-zA-Z가-힣0-9]+$')
                                              .hasMatch(
                                                  nickNameController.text)) {
                                            WarningSnackBar.show(
                                                context: context,
                                                text: '닉네임에 사용할 수 없는 문자가 있어요.');
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
                                        context.go('/main');
                                        nickNameController.clear();
                                      }
                                    ],
                                  );
                          },
                          child: _isLoading == true // Loading 상태일 경우
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
                            _isLoading
                                ? null
                                : AlertDialogWidget.twoButtons(
                                    context: context,
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
                                        Navigator.pop(context);
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
                                    ],
                                  );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              userProfileImage == '' && _pickedImage == null
                                  ? Container(
                                      width: 105.w,
                                      height: 105.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: dmLightGrey,
                                      ),
                                    )
                                  : _pickedImage != null
                                      ? Container(
                                          width: 105.w,
                                          height: 105.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: dmLightGrey,
                                            image: DecorationImage(
                                              image: Image.file(
                                                File(_pickedImage!.path),
                                              ).image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : CachedNetworkImage(
                                          fadeInDuration: Duration.zero,
                                          fadeOutDuration: Duration.zero,
                                          imageUrl: userProfileImage,
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
                          enabled: _isLoading ? false : true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣0-9]')),
                            LengthLimitingTextInputFormatter(8),
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          controller: nickNameController,
                          style: mainInputTextDeco,
                          decoration: mainInputDeco(userNickname),
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
                            vertical: 8.h,
                            horizontal: 10.w,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              userEmail,
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
                        child: GestureDetector(
                          onTap: () {
                            _isLoading
                                ? null
                                : AlertDialogWidget.twoButtons(
                                    context: context,
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
                          _isLoading
                              ? null
                              : AlertDialogWidget.twoButtons(
                                  context: context,
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
                                        context.go('/welcome');
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
                )
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
      await FirebaseFirestore.instance.collection('user').doc('$uid').update({
        'deleted': true,
        'nickName': 'del_$userNickname',
      });
      await FirebaseAuth.instance.currentUser?.delete();
      await FirebaseAuth.instance.signOut();

      context.go('/welcome');
      DoneSnackBar.show(
        context: context,
        text: '계정을 삭제했어요.',
      );
    } catch (e) {
      WarningSnackBar.show(
        context: context,
        text: '계정 삭제 중 문제가 발생했어요.',
        paddingBottom: 0,
      );
      debugPrint(e.toString());
      setState(() {
        _isLoading = false;
      });
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
        DoneSnackBar.show(
          context: context,
          text: '성공적으로 등록했어요!',
          paddingBottom: 0,
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        WarningSnackBar.show(
          context: context,
          text: '중복된 닉네임입니다.',
          paddingBottom: 0,
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      WarningSnackBar.show(context: context, text: '닉네임 변경 중 오류가 발생했어요.');
      return;
    }
  }

  // Firebase Firestore에 user 컬렉션에서 프로필 이미지 업데이트
  updateProfileImage(XFile imagePath) async {
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
      WarningSnackBar.show(context: context, text: '프로필 사진 업로드 중 오류가 발생했어요.');
      return;
    }
  }
}
