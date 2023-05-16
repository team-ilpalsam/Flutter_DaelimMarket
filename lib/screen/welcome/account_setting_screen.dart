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
import 'package:firebase_auth/firebase_auth.dart';
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
  late TextEditingController nickNameController = TextEditingController();
  XFile? _pickedImage;

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
                                  content: "testtest",
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
                        '닉네임(12자 이내)',
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
                        controller: nickNameController,
                        cursorHeight: 24.h,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(12),
                        ],
                        style: welcomeInputTextDeco,
                        decoration: welcomeInputDeco(),
                        cursorColor: dmBlack,
                      ),

                      // Bottom
                      const Expanded(child: SizedBox()),
                      nickNameController.text.length <= 12
                          ? GestureDetector(
                              onTap: () async {
                                String nickName = nickNameController.text;
                                await FirebaseUtils.updateUserData(nickName);
                                deleteProfileImage();
                                updateProfileImage(_pickedImage!);
                                context.pop();
                              },
                              child: const BlueButton(text: '입력 완료'))
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

  void deleteProfileImage() async {
    FirebaseStorage.instance
        .ref('profile/$uid')
        .listAll()
        .then((value) => Future.wait(value.items.map((e) => e.delete())));
  }

  // Storage에 이미지 올리기
  void updateProfileImage(XFile imageUrl) async {
    User? user = FirebaseAuth.instance.currentUser;

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profile/$uid/$uid.${imageUrl.path.split('.').last}');

    final UploadTask uploadTask =
        ref.putData(File(imageUrl.path).readAsBytesSync());

    // 만약 사진 업로드 성공 시
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    // 사진의 다운로드 가능한 url을 불러온 후
    final url = await taskSnapshot.ref.getDownloadURL();

    if (user != null) {
      String userId = user.uid;
      CollectionReference users = FirebaseFirestore.instance.collection('user');
      users.doc(userId).update({'profile_image': url});
    }
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
