import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/main.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            topPadding,
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                '채팅',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 28.sp,
                  fontWeight: bold,
                  color: dmBlack,
                ),
              ),
            ),
            SizedBox(height: 17.5.h),
            divider,

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chat') // product 컬렉션으로부터
                      .doc(uid) // uid 문서의
                      .snapshots(), // 데이터를 불러온다,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final data = snapshot.data!.data()!;
                      final chatList = data.entries
                          .toList(); // Map<String, dynamic>을 List<MapEntry<String, dynamic>> 형태로 변환
                      chatList.removeWhere((entry) => entry.key == "read_time");
                      chatList.sort((a, b) => (b.value.last['send_time']
                              as Timestamp)
                          .compareTo(a.value.last['send_time'] as Timestamp));

                      return ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: chatList.length, // chatList의 길이로 수정
                          separatorBuilder: (context, index) => divider,
                          itemBuilder: (context, index) {
                            String chatUID =
                                chatList[index].key; // chatList에서 chatUID를 가져옴
                            return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(chatUID)
                                  .get(),
                              builder: (context, userData) {
                                String userNickname; // 추후에 nickName으로
                                String userProfile;

                                if (userData.data?.exists == false) {
                                  userNickname = '알 수 없음';
                                  userProfile = '';
                                } else {
                                  if (userData.data?.exists == true &&
                                      userData.data!
                                          .data()!
                                          .containsKey('deleted')) {
                                    userNickname = '탈퇴한 사용자';
                                    userProfile = '';
                                  } else {
                                    userNickname =
                                        userData.data?['nickName'] ?? '';
                                    userProfile =
                                        userData.data?['profile_image'] ?? '';
                                  }
                                }

                                if (chatUID == 'read_time') {
                                  return const SizedBox();
                                } else {
                                  return Padding(
                                    padding: index == 0
                                        ? EdgeInsets.only(
                                            top: 34.5.h, bottom: 30.h)
                                        : EdgeInsets.symmetric(vertical: 30.h),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          '/chat',
                                          parameters: {
                                            'userUID': chatUID,
                                          },
                                        );
                                      },
                                      child: Container(
                                        color: dmWhite,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.21119,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            userProfile != ''
                                                ? CachedNetworkImage(
                                                    fadeInDuration:
                                                        Duration.zero,
                                                    fadeOutDuration:
                                                        Duration.zero,
                                                    imageUrl: userProfile,
                                                    fit: BoxFit.cover,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.17557,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.17557,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.17557,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.17557,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: dmGrey,
                                                      ),
                                                    ),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.17557,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.17557,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: dmGrey,
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.17557,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.17557,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: dmGrey,
                                                    )),
                                            SizedBox(
                                              width: 22.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    userNickname,
                                                    overflow: TextOverflow
                                                        .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 21.sp,
                                                      fontWeight: medium,
                                                      color: dmBlack,
                                                    ),
                                                  ),
                                                  SizedBox(height: 3.h),
                                                  Text(
                                                    chatList[index]
                                                                .value
                                                                .last['type'] ==
                                                            'text'
                                                        ? chatList[index]
                                                            .value
                                                            .last['text']
                                                        : '이미지를 보냈습니다.',
                                                    overflow: TextOverflow
                                                        .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 18.sp,
                                                      fontWeight: medium,
                                                      color: dmDarkGrey,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    DateFormat(
                                                            'MMM d일 a h시 mm분',
                                                            'ko_KR')
                                                        .format(chatList[index]
                                                            .value
                                                            .last['send_time']
                                                            .toDate()),
                                                    overflow: TextOverflow
                                                        .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 14.sp,
                                                      fontWeight: medium,
                                                      color: dmGrey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            chatList[index]
                                                            .value
                                                            .last['sender'] !=
                                                        uid &&
                                                    (data['read_time'][
                                                                '$uid-${chatList[index].key}'] ==
                                                            null ||
                                                        chatList[index]
                                                            .value
                                                            .last['send_time']
                                                            .toDate()
                                                            .isAfter(data[
                                                                        'read_time']
                                                                    [
                                                                    '$uid-${chatList[index].key}']
                                                                .toDate()))
                                                ? Container(
                                                    width: 17.w,
                                                    height: 17.h,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: dmRed,
                                                            shape: BoxShape
                                                                .circle),
                                                  )
                                                : const SizedBox()
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          '아직 채팅이 없어요.',
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
          ],
        ),
      ),
    );
  }
}
