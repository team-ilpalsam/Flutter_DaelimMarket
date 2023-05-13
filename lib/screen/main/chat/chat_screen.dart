import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:emoji_regex/emoji_regex.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../../styles/colors.dart';
import '../../../styles/fonts.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/scroll_behavior.dart';
import '../../widgets/snackbar.dart';

class ChatScreen extends StatelessWidget {
  final String userUID;

  ChatScreen({super.key, required this.userUID});

  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    onTapAddPhotoFromAlbum() async {
      Navigator.pop(context);
      try {
        // 앨범에 여러 장 선택할 수 있는 ImagePicker 불러옴
        await ImagePicker()
            .pickImage(source: ImageSource.gallery)
            .then((xfile) async {
          // 아무것도 고르지 않았다면
          if (xfile == null) {
            return;
          }
          // chatImageId 변수에 'yyyyMMddHHmmss_id' 형식으로 대입
          String chatImageId =
              'chat_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_$id';

          // Firebase Storage에 chat 디렉터리 내 uid 디렉터리를 생성한 후 'chatImageId.파일확장자' 형식으로 저장
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('chat/$uid/$chatImageId.${xfile.path.split('.').last}');
          final UploadTask uploadTask =
              ref.putData(File(xfile.path).readAsBytesSync());
          // 만약 사진 업로드 성공 시
          final TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});

          // 사진의 다운로드 가능한 url을 불러온 후
          final url = await taskSnapshot.ref.getDownloadURL();

          // product 컬렉션 내 productId 문서에 데이터 저장
          await FirebaseFirestore.instance
              .collection('chat') // chat 컬렉션에서
              .doc(uid) // 자신의 UID 문서 내
              .update({
            userUID: FieldValue.arrayUnion([
              {
                'type': 'image',
                'send_time': DateTime.now(),
                'sender': uid,
                'image': url,
              }
            ])
          });
          await FirebaseFirestore.instance
              .collection('chat') // chat 컬렉션에서
              .doc(userUID) // 상대 UID의 문서 내
              .update({
            uid!: FieldValue.arrayUnion([
              {
                'type': 'image',
                'send_time': DateTime.now(),
                'sender': uid,
                'image': url,
              }
            ])
          });
        });
      } catch (e) {
        WarningSnackBar.show(
          context: context,
          text: '사진을 불러오는 중 실패했어요.',
          paddingBottom: 0,
        );
        debugPrint(e.toString());
      }
    }

    onTapAddPhotoFromCamera() async {
      Navigator.pop(context);
      try {
        // 카메라를 불러옴
        await ImagePicker()
            .pickImage(source: ImageSource.camera)
            .then((xfile) async {
          // 아무것도 고르지 않았다면
          if (xfile == null) {
            return;
          }
          // chatImageId 변수에 'yyyyMMddHHmmss_id' 형식으로 대입
          String chatImageId =
              'chat_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_$id';

          // Firebase Storage에 chat 디렉터리 내 uid 디렉터리를 생성한 후 'chatImageId.파일확장자' 형식으로 저장
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('chat/$uid/$chatImageId.${xfile.path.split('.').last}');
          final UploadTask uploadTask =
              ref.putData(File(xfile.path).readAsBytesSync());
          // 만약 사진 업로드 성공 시
          final TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});

          // 사진의 다운로드 가능한 url을 불러온 후
          final url = await taskSnapshot.ref.getDownloadURL();

          // product 컬렉션 내 productId 문서에 데이터 저장
          await FirebaseFirestore.instance
              .collection('chat') // chat 컬렉션에서
              .doc(uid) // 자신의 UID 문서 내
              .update({
            userUID: FieldValue.arrayUnion([
              {
                'type': 'image',
                'send_time': DateTime.now(),
                'sender': uid,
                'image': url,
              }
            ])
          });
          await FirebaseFirestore.instance
              .collection('chat') // chat 컬렉션에서
              .doc(userUID) // 상대 UID의 문서 내
              .update({
            uid!: FieldValue.arrayUnion([
              {
                'type': 'image',
                'send_time': DateTime.now(),
                'sender': uid,
                'image': url,
              }
            ])
          });
        });
      } catch (e) {
        WarningSnackBar.show(
          context: context,
          text: '사진을 불러오는 중 실패했어요.',
          paddingBottom: 0,
        );
        debugPrint(e.toString());
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // 키보드 위에 입력 창 띄우기 여부
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('user')
                .doc(userUID)
                .get(),
            builder: (context, userData) {
              String userNickname;

              if (userData.data?.exists == false) {
                userNickname = '알 수 없음';
              } else {
                userNickname = userData.data?['id'] ?? '';
              }

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat') // product 컬렉션으로부터
                    .doc(uid) // uid 문서의
                    .snapshots(), // 데이터
                builder: ((context, snapshot) {
                  return Column(
                    children: [
                      // Title
                      MainAppbar.show(
                        title: userNickname,
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
                          onTap: () {
                            AlertDialogWidget.twoButtons(
                              context: context,
                              content: "정말로 나가시겠습니까?",
                              button: ["취소", "나갈래요."],
                              color: [dmGrey, dmRed],
                              action: [
                                () {
                                  Navigator.pop(context);
                                },
                                () {
                                  FirebaseFirestore.instance
                                      .collection('chat') // chat 컬렉션에서
                                      .doc(uid) // 자신의 UID 문서 내
                                      .update({userUID: FieldValue.delete()});
                                  Navigator.pop(context);
                                  context.pop();
                                }
                              ],
                            );
                          },
                          child: Text(
                            "나가기",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 18.sp,
                              fontWeight: medium,
                              color: dmRed,
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('chat')
                                .doc(uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              final originData = snapshot.data?.data()?[userUID]
                                  as List<dynamic>?;
                              final data = originData?.reversed.toList();
                              if (snapshot.hasData && data != null) {
                                return ScrollConfiguration(
                                  behavior: MyBehavior(),
                                  child: ListView.builder(
                                    reverse: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: data.length,
                                    itemBuilder: ((context, index) {
                                      // Text Type
                                      if (data[index]['type'] == 'text') {
                                        // 자신이 보냈을 경우
                                        if (data[index]['sender'] == uid) {
                                          return Column(
                                            children: [
                                              index == data.length - 1 ||
                                                      data[index + 1]
                                                                  ['send_time']
                                                              .toDate()
                                                              .day !=
                                                          data[index]
                                                                  ['send_time']
                                                              .toDate()
                                                              .day
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          top: index ==
                                                                  data.length -
                                                                      1
                                                              ? 27.5.h
                                                              : 22.5.h,
                                                          bottom: 22.5.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.52162,
                                                            height: 30.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: dmGrey,
                                                              borderRadius:
                                                                  // 타원형
                                                                  BorderRadius
                                                                      .circular(
                                                                          3.40e+38),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              DateFormat(
                                                                      'yyyy년 M월 d일 EEEE',
                                                                      'ko_KR')
                                                                  .format(
                                                                data[index][
                                                                        'send_time']
                                                                    .toDate(),
                                                              ),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Pretendard',
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    medium,
                                                                color: dmWhite,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5.h),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          index == 0 ||
                                                                  data[index][
                                                                          'sender'] !=
                                                                      data[index -
                                                                              1]
                                                                          [
                                                                          'sender'] ||
                                                                  data[index]['send_time']
                                                                          .toDate()
                                                                          .minute !=
                                                                      data[index - 1]
                                                                              [
                                                                              'send_time']
                                                                          .toDate()
                                                                          .minute
                                                              ? Text(
                                                                  DateFormat(
                                                                          'a h:mm',
                                                                          'ko_KR')
                                                                      .format(
                                                                    data[index][
                                                                            'send_time']
                                                                        .toDate(),
                                                                  ),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Pretendard',
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        medium,
                                                                    color:
                                                                        dmDarkGrey,
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      data[index]['text']
                                                                      .length >=
                                                                  2 &&
                                                              data[index]['text']
                                                                      .length <=
                                                                  6 &&
                                                              data[index]
                                                                      ['text']
                                                                  .contains(
                                                                      emojiRegex())
                                                          ? Text(
                                                              data[index]
                                                                  ['text'],
                                                              style: TextStyle(
                                                                fontSize: 60.sp,
                                                              ),
                                                            )
                                                          : Container(
                                                              constraints: BoxConstraints(
                                                                  maxWidth: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.6234),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: dmBlue,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.r),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal: 10
                                                                            .w,
                                                                        vertical:
                                                                            10.h),
                                                                child: Text(
                                                                  data[index]
                                                                      ['text'],
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Pretendard',
                                                                    fontSize:
                                                                        18.sp,
                                                                    fontWeight:
                                                                        medium,
                                                                    color:
                                                                        dmWhite,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                    ]),
                                              )
                                            ],
                                          );
                                        }
                                        // 타인이 보냈을 경우
                                        else {
                                          return Column(
                                            children: [
                                              index == data.length - 1 ||
                                                      data[index + 1]
                                                                  ['send_time']
                                                              .toDate()
                                                              .day !=
                                                          data[index]
                                                                  ['send_time']
                                                              .toDate()
                                                              .day
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          top: index ==
                                                                  data.length -
                                                                      1
                                                              ? 27.5.h
                                                              : 22.5.h,
                                                          bottom: 22.5.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.52162,
                                                            height: 30.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: dmGrey,
                                                              borderRadius:
                                                                  // 타원형
                                                                  BorderRadius
                                                                      .circular(
                                                                          3.40e+38),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              DateFormat(
                                                                      'yyyy년 M월 d일 EEEE',
                                                                      'ko_KR')
                                                                  .format(data[
                                                                              index]
                                                                          [
                                                                          'send_time']
                                                                      .toDate()),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Pretendard',
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    medium,
                                                                color: dmWhite,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    data[index]['text']
                                                                    .length >=
                                                                2 &&
                                                            data[index]['text']
                                                                    .length <=
                                                                6 &&
                                                            data[index]['text']
                                                                .contains(
                                                                    emojiRegex())
                                                        ? Text(
                                                            data[index]['text'],
                                                            style: TextStyle(
                                                              fontSize: 60.sp,
                                                            ),
                                                          )
                                                        : Container(
                                                            constraints: BoxConstraints(
                                                                maxWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.6234),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  dmLightGrey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10.w,
                                                                      vertical:
                                                                          10.h),
                                                              child: Text(
                                                                data[index]
                                                                    ['text'],
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Pretendard',
                                                                  fontSize:
                                                                      18.sp,
                                                                  fontWeight:
                                                                      medium,
                                                                  color:
                                                                      dmBlack,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    index == 0 ||
                                                            data[index][
                                                                    'sender'] !=
                                                                data[index - 1][
                                                                    'sender'] ||
                                                            data[index]['send_time']
                                                                    .toDate()
                                                                    .minute !=
                                                                data[index - 1][
                                                                        'send_time']
                                                                    .toDate()
                                                                    .minute
                                                        ? Text(
                                                            DateFormat('a h:mm',
                                                                    'ko_KR')
                                                                .format(
                                                              data[index][
                                                                      'send_time']
                                                                  .toDate(),
                                                            ),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  medium,
                                                              color: dmDarkGrey,
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                      }
                                      // Image Type
                                      else if (data[index]['type'] == 'image') {
                                        // 자신이 보냈을 경우
                                        if (data[index]['sender'] == uid) {
                                          return Column(
                                            children: [
                                              index == data.length - 1 ||
                                                      data[index + 1]
                                                                  ['send_time']
                                                              .toDate()
                                                              .day !=
                                                          data[index]
                                                                  ['send_time']
                                                              .toDate()
                                                              .day
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          top: index ==
                                                                  data.length -
                                                                      1
                                                              ? 27.5.h
                                                              : 22.5.h,
                                                          bottom: 22.5.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.52162,
                                                            height: 30.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: dmGrey,
                                                              borderRadius:
                                                                  // 타원형
                                                                  BorderRadius
                                                                      .circular(
                                                                          3.40e+38),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              DateFormat(
                                                                      'yyyy년 M월 d일 EEEE',
                                                                      'ko_KR')
                                                                  .format(
                                                                data[index][
                                                                        'send_time']
                                                                    .toDate(),
                                                              ),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Pretendard',
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    medium,
                                                                color: dmWhite,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5.h),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          index == 0 ||
                                                                  data[index][
                                                                          'sender'] !=
                                                                      data[index -
                                                                              1]
                                                                          [
                                                                          'sender'] ||
                                                                  data[index]['send_time']
                                                                          .toDate()
                                                                          .minute !=
                                                                      data[index - 1]
                                                                              [
                                                                              'send_time']
                                                                          .toDate()
                                                                          .minute
                                                              ? Text(
                                                                  DateFormat(
                                                                          'a h:mm',
                                                                          'ko_KR')
                                                                      .format(
                                                                    data[index][
                                                                            'send_time']
                                                                        .toDate(),
                                                                  ),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Pretendard',
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        medium,
                                                                    color:
                                                                        dmDarkGrey,
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          context.pushNamed(
                                                            'imageviewer',
                                                            queryParams: {
                                                              'src': data[index]
                                                                  ['image']
                                                            },
                                                          );
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          child: Container(
                                                            constraints: BoxConstraints(
                                                                maxWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.6234,
                                                                maxHeight: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.44601),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: dmWhite,
                                                            ),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  data[index]
                                                                      ['image'],
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CupertinoActivityIndicator(),
                                                              fadeInDuration:
                                                                  Duration.zero,
                                                              fadeOutDuration:
                                                                  Duration.zero,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              )
                                            ],
                                          );
                                        }
                                        // 타인이 보냈을 경우
                                        else {
                                          return Column(
                                            children: [
                                              index == data.length - 1 ||
                                                      data[index + 1]
                                                                  ['send_time']
                                                              .toDate()
                                                              .day !=
                                                          data[index]
                                                                  ['send_time']
                                                              .toDate()
                                                              .day
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          top: index ==
                                                                  data.length -
                                                                      1
                                                              ? 27.5.h
                                                              : 22.5.h,
                                                          bottom: 22.5.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.52162,
                                                            height: 30.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: dmGrey,
                                                              borderRadius:
                                                                  // 타원형
                                                                  BorderRadius
                                                                      .circular(
                                                                          3.40e+38),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              DateFormat(
                                                                      'yyyy년 M월 d일 EEEE',
                                                                      'ko_KR')
                                                                  .format(data[
                                                                              index]
                                                                          [
                                                                          'send_time']
                                                                      .toDate()),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Pretendard',
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    medium,
                                                                color: dmWhite,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        context.pushNamed(
                                                          'imageviewer',
                                                          queryParams: {
                                                            'src': data[index]
                                                                ['image']
                                                          },
                                                        );
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        child: Container(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.6234,
                                                              maxHeight: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.44601),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: dmWhite,
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                data[index]
                                                                    ['image'],
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CupertinoActivityIndicator(),
                                                            fadeInDuration:
                                                                Duration.zero,
                                                            fadeOutDuration:
                                                                Duration.zero,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    index == 0 ||
                                                            data[index][
                                                                    'sender'] !=
                                                                data[index - 1][
                                                                    'sender'] ||
                                                            data[index]['send_time']
                                                                    .toDate()
                                                                    .minute !=
                                                                data[index - 1][
                                                                        'send_time']
                                                                    .toDate()
                                                                    .minute
                                                        ? Text(
                                                            DateFormat('a h:mm',
                                                                    'ko_KR')
                                                                .format(
                                                              data[index][
                                                                      'send_time']
                                                                  .toDate(),
                                                            ),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  medium,
                                                              color: dmDarkGrey,
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                      }
                                      return null;
                                    }),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    '채팅이 존재하지 않아요.',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 14.sp,
                                      fontWeight: bold,
                                      color: dmLightGrey,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),

                      // Bottom
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Container(
                          width: double.infinity,
                          // Android 대응
                          height:
                              window.viewPadding.bottom > 0 ? 60.5.h : 75.5.h,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: dmGrey,
                                width: 1.w,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              // Android 대응
                              top: window.viewPadding.bottom > 0 ? 10.h : 0.h,
                              left: 20.w,
                              right: 20.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    AlertDialogWidget.twoButtons(
                                      context: context,
                                      content: "사진을 선택해주세요!",
                                      button: ["앨범에서 선택", "카메라로 촬영"],
                                      color: [dmBlue, dmBlue],
                                      action: [
                                        onTapAddPhotoFromAlbum,
                                        onTapAddPhotoFromCamera,
                                      ],
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/images/icons/icon_camera_grey.png',
                                    width: 25.w,
                                    height: 25.h,
                                  ),
                                ),
                                SizedBox(width: 18.w),
                                Container(
                                  width: 2.w,
                                  height: 29.h,
                                  color: dmDarkGrey,
                                ),
                                SizedBox(width: 18.w),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.60914,
                                  height: 33.h,
                                  child: TextField(
                                    controller: chatController,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 16.sp,
                                      fontWeight: medium,
                                      color: dmBlack,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 7.h,
                                        horizontal: 12.w,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: BorderSide(
                                          width: 1.w,
                                          color: dmDarkGrey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: BorderSide(
                                          width: 1.w,
                                          color: dmDarkGrey,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(
                                          width: 1.w,
                                          color: dmBlack,
                                        ),
                                      ),
                                    ),
                                    cursorColor: dmBlack,
                                  ),
                                ),
                                const Expanded(
                                  child: SizedBox(),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (chatController.text != '' &&
                                        !RegExp(r'^\s*$')
                                            .hasMatch(chatController.text)) {
                                      FirebaseFirestore.instance
                                          .collection('chat') // chat 컬렉션에서
                                          .doc(uid) // 자신의 UID 문서 내
                                          .update({
                                        userUID: FieldValue.arrayUnion([
                                          {
                                            'type': 'text',
                                            'send_time': DateTime.now(),
                                            'sender': uid,
                                            'text': chatController.text,
                                          }
                                        ])
                                      });
                                      FirebaseFirestore.instance
                                          .collection('chat') // chat 컬렉션에서
                                          .doc(userUID) // 상대 UID의 문서 내
                                          .update({
                                        uid!: FieldValue.arrayUnion([
                                          {
                                            'type': 'text',
                                            'send_time': DateTime.now(),
                                            'sender': uid,
                                            'text': chatController.text,
                                          }
                                        ])
                                      });
                                      chatController.text = '';
                                    }
                                  },
                                  child: Container(
                                    width: 35.w,
                                    height: 35.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      color: dmBlue,
                                    ),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/icons/icon_chat_arrow_up.png',
                                      height: 18.h,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
