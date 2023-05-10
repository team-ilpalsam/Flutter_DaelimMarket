import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';
import '../../../styles/colors.dart';
import '../../../styles/fonts.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/scroll_behavior.dart';

class ChatScreen extends StatefulWidget {
  final String userUID;

  const ChatScreen({super.key, required this.userUID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController chatController;

  @override
  void initState() {
    chatController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    chatController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                .doc(widget.userUID)
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
                                  Navigator.pop(context);
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
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('chat')
                                .doc(uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }

                              if (snapshot.hasData &&
                                  snapshot.data!.data()![widget.userUID] !=
                                      null) {
                                return ScrollConfiguration(
                                  behavior: MyBehavior(),
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data!
                                        .data()![widget.userUID]
                                        .length,
                                    itemBuilder: ((context, index) {
                                      if (snapshot.data!.data()![widget.userUID]
                                              [index]['sender'] ==
                                          uid) {
                                        return Padding(
                                          padding: index == 0
                                              ? EdgeInsets.only(
                                                  top: 27.5.h, bottom: 10.h)
                                              : EdgeInsets.symmetric(
                                                  vertical: 10.h),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: dmBlue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 10.h),
                                                    child: Text(
                                                      snapshot.data!.data()![
                                                              widget.userUID]
                                                          [index]['text'],
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontSize: 18.sp,
                                                        fontWeight: medium,
                                                        color: dmWhite,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        );
                                      } else {
                                        return Padding(
                                          padding: index == 0
                                              ? EdgeInsets.only(
                                                  top: 27.5.h, bottom: 10.h)
                                              : EdgeInsets.symmetric(
                                                  vertical: 10.h),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: dmLightGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 10.h),
                                                    child: Text(
                                                      snapshot.data!.data()![
                                                              widget.userUID]
                                                          [index]['text'],
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontSize: 18.sp,
                                                        fontWeight: medium,
                                                        color: dmBlack,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        );
                                      }
                                      return null;

                                      // Text(snapshot.data!.data()![widget.userUID]
                                      //     [index]['sender']);
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
                      Container(
                        width: double.infinity,
                        // Android 대응
                        height: window.viewPadding.bottom > 0 ? 60.5.h : 75.5.h,
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
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/icons/icon_chat_plus.png',
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
                                width:
                                    MediaQuery.of(context).size.width * 0.60914,
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
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide(
                                        width: 1.w,
                                        color: dmDarkGrey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
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
                                  FirebaseFirestore.instance
                                      .collection('chat') // product 컬렉션에서
                                      .doc(uid) // product_id의 문서 내
                                      .update({
                                    widget.userUID: FieldValue.arrayUnion([
                                      {
                                        'type': 'text',
                                        'send_time': DateTime.now(),
                                        'sender': uid,
                                        'text': chatController.text
                                      }
                                    ])
                                  });
                                  FirebaseFirestore.instance
                                      .collection('chat') // product 컬렉션에서
                                      .doc(widget.userUID) // product_id의 문서 내
                                      .update({
                                    uid!: FieldValue.arrayUnion([
                                      {
                                        'type': 'text',
                                        'send_time': DateTime.now(),
                                        'sender': uid,
                                        'text': chatController.text
                                      }
                                    ])
                                  });
                                  chatController.text = '';
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