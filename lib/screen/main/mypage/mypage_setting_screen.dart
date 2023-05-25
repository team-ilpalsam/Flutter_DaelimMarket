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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    nickNameController.dispose();
    super.dispose();
  }

  XFile? _pickedImage;
  String uidNickName = "";
  String imgURL = "";

  @override
  Widget build(BuildContext context) {
    getData();
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
                    AlertDialogWidget.twoButtons(
                        context: context,
                        content: '저장 하시겠습니까?',
                        button: [
                          '취소',
                          '확인'
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
                            String nickName = nickNameController.text;
                            await FirebaseUtils.updateUserData(
                                context, nickName);
                            if (_pickedImage != null) {
                              await FirebaseUtils.updateProfileImage(
                                  _pickedImage!);
                            }
                            context.go('/main');
                            nickNameController.clear();
                          }
                        ]);
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
                            imgURL == ''
                                ? Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: dmLightGrey,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    fadeInDuration: Duration.zero,
                                    fadeOutDuration: Duration.zero,
                                    imageUrl: imgURL,
                                    fit: BoxFit.cover,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 105.w,
                                      height: 105.h,
                                      decoration: BoxDecoration(
                                        image: _pickedImage != null
                                            ? DecorationImage(
                                                image: Image.file(File(
                                                        _pickedImage!.path))
                                                    .image,
                                                fit: BoxFit.cover,
                                              )
                                            : DecorationImage(
                                                image: imageProvider),
                                        shape: BoxShape.circle,
                                        color: dmLightGrey,
                                        border: Border.all(
                                          color: dmDarkGrey,
                                          width: 1.w,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣0-9]')),
                          LengthLimitingTextInputFormatter(8),
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        controller: nickNameController,
                        style: mainInputTextDeco,
                        decoration: mainInputDeco(uidNickName),
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
                      child: GestureDetector(
                        onTap: () {
                          AlertDialogWidget.oneButton(
                            context: context,
                            content: '계정을 삭제하시겠습니까?',
                            button: '확인',
                            action: () {
                              deleteAccount();
                              addDeleted();
                            },
                          );
                        },
                        child: const Text(
                          "계정 삭제",
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
                        const FlutterSecureStorage().deleteAll();
                        context.go('/welcome');
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

  Future<void> deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user!.delete();
      debugPrint('계정이 성공적으로 삭제되었습니다.');
    } catch (e) {
      debugPrint('계정 삭제 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> addDeleted() async {
    try {
      // 문서의 참조 가져오기
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('user').doc('$uid');

      // 필드 업데이트
      await docRef.update({'deleted': 'true'});
      await docRef.update({'nickName': ' '});
      debugPrint('필드가 성공적으로 추가되었습니다.');
    } catch (e) {
      debugPrint('필드 추가 중 오류가 발생했습니다: $e');
    }
  }

  getData() async {
    var uidData = await FirebaseFirestore.instance
        .collection('user') // user 컬렉션으로부터
        .doc(uid) // 넘겨받은 uid 필드의 데이터를
        .get();

    var dataMap = uidData.data();
    uidNickName = dataMap!['nickName'];
    imgURL = dataMap['profile_image'];

    if (mounted) setState(() {});
  }
}

class FirebaseUtils {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  // Firebase Firestore의 데이터 업데이트하기
  static Future<void> updateUserData(context, String nickName) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userRef = _firestore.collection('user').doc(uid);
      final isUnique = await isNickNameUnique(nickName);
      if (isUnique) {
        await userRef.update({'nickName': nickName});
        DoneSnackBar.show(
          context: context,
          text: '성공적으로 등록했어요!',
          paddingBottom: 0,
        );
      } else {
        DoneSnackBar.show(
          context: context,
          text: '중복된 닉네임입니다.',
          paddingBottom: 0,
        );
        Navigator.pop(context);
      }
    }
  }

  static Future<bool> isNickNameUnique(String nickNameText) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('user')
        .where('nickName', isEqualTo: nickNameText)
        .get();

    return snapshot.docs.isEmpty;
  }

  static Future<void> updateProfileImage(XFile ImagePath) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userRef = FirebaseStorage.instance.ref().child('profile/$uid/');
      UploadTask uploadTask =
          userRef.putData(File(ImagePath.path).readAsBytesSync());
      // 만약 사진 업로드 성공 시
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      // 사진의 다운로드 가능한 url을 불러온 후
      final url = await taskSnapshot.ref.getDownloadURL();

      debugPrint(url);

      await FirebaseFirestore.instance
          .collection('user')
          .doc('$uid')
          .update({'profile_image': url});
    }
  }
}
