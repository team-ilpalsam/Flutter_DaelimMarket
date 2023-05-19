import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/alert_dialog.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../../styles/fonts.dart';
import '../../widgets/snackbar.dart';

class DetailScreen extends StatefulWidget {
  final String productId;

  const DetailScreen({super.key, required this.productId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            // Firebase의 Firestore 데이터 불러오기
            FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('product') // product 컬렉션으로부터
              .doc(widget.productId) // 넘겨받은 productID 문서의 데이터를
              .get(), // 불러온다
          builder: (context, snapshot) {
            // 만약 불러오는 상태라면 로딩 인디케이터를 중앙에 배치
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            // 만약 판매글의 데이터가 없거나 삭제된 경우
            if (snapshot.data?.exists == false) {
              return Column(
                children: [
                  MainAppbar.show(
                    title: '알 수 없음',
                    leading: GestureDetector(
                      onTap: () {
                        context.go('/main');
                      },
                      child: Image.asset(
                        'assets/images/icons/icon_back.png',
                        alignment: Alignment.topLeft,
                        height: 18.h,
                      ),
                    ),
                    action: const SizedBox(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '존재하지 않는 게시글이에요.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14.sp,
                          fontWeight: bold,
                          color: dmLightGrey,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            // 판매글의 데이터가 존재하는 경우
            else if (snapshot.hasData && snapshot.data!.data()!.isNotEmpty) {
              return Column(
                children: [
                  // Title
                  MainAppbar.show(
                    // 제목
                    title: snapshot.data!['title'],

                    // 왼쪽 아이콘
                    leading: GestureDetector(
                      onTap: () {
                        context.go('/main');
                      },
                      child: Image.asset(
                        'assets/images/icons/icon_back.png',
                        alignment: Alignment.topLeft,
                        height: 18.h,
                      ),
                    ),

                    // 오른쪽 아이콘
                    // 만약 FlutterSecureStorage의 UID와 게시글의 UID가 일치한다면 삭제 버튼 표시
                    action: uid == snapshot.data!['uid']
                        ? GestureDetector(
                            onTap: () {
                              AlertDialogWidget.twoButtons(
                                context: context,
                                content: "정말로 삭제하시겠습니까?",
                                button: ["취소", "삭제할래요."],
                                color: [dmGrey, dmRed],
                                action: [
                                  () {
                                    Navigator.pop(context);
                                  },
                                  () {
                                    onTapDelete(snapshot);
                                  }
                                ],
                              );
                            },
                            child: Text(
                              "삭제",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 18.sp,
                                fontWeight: medium,
                                color: dmRed,
                              ),
                            ),
                          )
                        :
                        // 일치하지 않는다면 미표시
                        const SizedBox(),
                  ),

                  // Content
                  Expanded(
                    child:
                        // 안드로이드 스와이프 Glow 애니메이션 제거
                        ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 18.5.h,
                            ),
                            // 캐로셀 이미지
                            Center(
                              child: Column(
                                children: [
                                  CarouselSlider(
                                    items: List<Widget>.from(
                                      snapshot.data!['images']
                                          .asMap()
                                          .entries // value와 index를 가져오기 위함
                                          .map((entry) {
                                        String value = entry.value;
                                        int index = entry.key;
                                        return GestureDetector(
                                          onTap: () {
                                            // 이미지를 누를 시 src 데이터와 함께 ImageViewerScreen으로 이동
                                            context.pushNamed(
                                              'imageviewer',
                                              queryParams: {'src': value},
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              // 이미지의 크기는 디바이스 너비의 0.881배
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.881,
                                                child: CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  fadeOutDuration:
                                                      Duration.zero,
                                                  imageUrl: value,
                                                  placeholder: (context, url) =>
                                                      const CupertinoActivityIndicator(),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.881,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              // index 표시
                                              Positioned(
                                                left: 10.w,
                                                bottom: 10.h,
                                                child: Container(
                                                  width: 75.w,
                                                  height: 35.h,
                                                  decoration: BoxDecoration(
                                                    color: dmBlack
                                                        .withOpacity(0.7),
                                                    borderRadius:
                                                        // 타원형
                                                        BorderRadius.circular(
                                                            3.40e+38),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${index + 1} / ${snapshot.data!['images'].length}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Pretendard',
                                                          fontSize: 16.sp,
                                                          fontWeight: bold,
                                                          color: dmLightGrey),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                    options: CarouselOptions(
                                      viewportFraction: 1,
                                      autoPlay: false,
                                      enableInfiniteScroll: false, // 무한스크롤
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.881,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 19.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    // 판매글 제목
                                    child: Text(
                                      snapshot.data!['title'],
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        color: dmBlack,
                                        fontSize: 21.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  SizedBox(
                                    // 닉네임과 거래 희망 장소
                                    child: Text(
                                      '${snapshot.data!['id'].toUpperCase()} · ${snapshot.data!['location']}',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        color: dmDarkGrey,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 22.h,
                                  ),
                                  // 설명글의 데이터가 존재할 경우
                                  snapshot.data!['desc'] != ''
                                      ? SizedBox(
                                          child: Text(
                                            snapshot.data!['desc'],
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              color: dmBlack,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  snapshot.data!['desc'] != ''
                                      ? SizedBox(
                                          height: 22.h,
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                    // 업로드 시간
                                    child: Text(
                                      DateFormat('y년 MMM d일 a h시 mm분', 'ko_KR')
                                          .format(snapshot.data!['uploadTime']
                                              .toDate()),
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        color: dmDarkGrey,
                                        fontSize: 13.sp,
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
                        left: 32.w,
                        right: 20.w,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          snapshot.data!['likes'].contains(uid)
                              ? GestureDetector(
                                  onTap: () {
                                    onTapCancelLike(snapshot);
                                  },
                                  child: Image.asset(
                                    'assets/images/icons/icon_heart_fill.png',
                                    height: 27.h,
                                  ),
                                )
                              :
                              // 판매글의 likes 리스트에 사용자의 UID가 포함되어있지 않다면
                              GestureDetector(
                                  onTap: () {
                                    onTapLike(snapshot);
                                  },
                                  child: Image.asset(
                                    'assets/images/icons/icon_heart.png',
                                    height: 27.h,
                                  ),
                                ),
                          SizedBox(
                            width: 21.83.w,
                          ),
                          Container(
                            width: 1.w,
                            height: 36.h,
                            color: dmDarkGrey,
                          ),
                          SizedBox(
                            width: 20.5.w,
                          ),
                          Text(
                            // #,###원 형식으로 price 데이터를 표시
                            '${NumberFormat('#,###').format(int.parse(snapshot.data!['price']))}원',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 21.sp,
                              fontWeight: bold,
                              color: dmBlue,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: () {
                              snapshot.data!['uid'] == uid
                                  ? null
                                  : context.pushNamed('chat', queryParams: {
                                      'userUID': snapshot.data!['uid']
                                    });
                            },
                            child: Container(
                              width: 115.w,
                              height: 34.h,
                              decoration: BoxDecoration(
                                color: snapshot.data!['uid'] == uid
                                    ? dmLightGrey
                                    : dmBlue,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Center(
                                child: Text(
                                  '채팅하기',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16.sp,
                                    fontWeight: bold,
                                    color: dmWhite,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
            // 그 외 오류 발생 시
            else {
              return Column(
                children: [
                  MainAppbar.show(
                    title: '',
                    leading: GestureDetector(
                      onTap: () {
                        context.go('/main');
                      },
                      child: Image.asset(
                        'assets/images/icons/icon_back.png',
                        alignment: Alignment.topLeft,
                        height: 18.h,
                      ),
                    ),
                    action: const SizedBox(),
                  ),
                  const Expanded(
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // 삭제 처리 메소드
  onTapDelete(snapshot) async {
    // 확인 창 닫기
    Navigator.pop(context);
    try {
      // Future.wait 내 코드가 다 수행될 때까지 대기
      await Future.wait([
        // product 컬렉션 내 product_id 문서 삭제
        FirebaseFirestore.instance
            .collection('product')
            .doc(snapshot.data!['product_id'])
            .delete(),
        // user 컬렉션 내 업로드 한 user 문서의 posts 리스트 중 product_id를 가진 값을 삭제 후 업데이트
        FirebaseFirestore.instance
            .collection('user')
            .doc(snapshot.data!['uid'])
            .update({
          'posts': FieldValue.arrayRemove([snapshot.data!['product_id']]),
        }),
        // FirebaseStorage에서 product 디렉토리 내 product_id를 가진 디렉토리의 파일을 모두 삭제
        FirebaseStorage.instance
            .ref('product/${snapshot.data!['product_id']}')
            .listAll()
            .then((value) => Future.wait(value.items.map((e) => e.delete()))),
      ]);

      // user 컬렉션 내 likes 배열에 있는 UID의 문서 내 watch_list 배열에 해당 product_id 요소를 제거 후 업데이트한다.
      if (snapshot.data!['likes'] != null) {
        snapshot.data!['likes'].forEach((element) async {
          await Future.wait([
            FirebaseFirestore.instance.collection('user').doc(element).update({
              'watchlist':
                  FieldValue.arrayRemove([snapshot.data!['product_id']])
            })
          ]);
        });
      }

      context.go('/main');
      DoneSnackBar.show(
        context: context,
        text: '판매글을 삭제했어요.',
        paddingHorizontal: 0,
        paddingBottom: 0,
      );
    } catch (e) {
      context.go('/main');
      WarningSnackBar.show(
        context: context,
        text: '판매글 삭제 중 문제가 생겼어요.',
        paddingHorizontal: 0,
        paddingBottom: 0,
      );
      debugPrint(e.toString());
    }
  }

  // 좋아요 취소 메소드
  Future<void> onTapCancelLike(snapshot) async {
    try {
      // Future.wait 내 코드가 다 수행될 때까지 대기
      await Future.wait(
        [
          FirebaseFirestore.instance
              .collection('product') // product 컬렉션에서
              .doc(snapshot.data!['product_id']) // product_id의 문서 내
              .update({
            'likes': FieldValue.arrayRemove([uid!]) // likes 리스트에 사용자 UID 값을 제거
          }),
          // user 컬렉션에서 사용자의 UID의 watchlist 리스트에 product_id 값 제거
          FirebaseFirestore.instance.collection('user').doc(uid).update(
            {
              'watchlist':
                  FieldValue.arrayRemove([snapshot.data!['product_id']])
            },
          ),
        ],
      );
      // 새로고침
      setState(() {});
    } catch (e) {
      WarningSnackBar.show(
        context: context,
        text: '관심을 누르던 중 문제가 생겼어요.',
        paddingHorizontal: 0,
      );
      debugPrint(e.toString());
    }
  }

  // 좋아요 메소드
  Future<void> onTapLike(snapshot) async {
    try {
      // Future.wait 내 코드가 다 수행될 때까지 대기
      await Future.wait(
        [
          FirebaseFirestore.instance
              .collection('product') // product 컬렉션에서
              .doc(snapshot.data!['product_id']) // product_id의 문서 내
              .update({
            'likes': FieldValue.arrayUnion([uid!]) // likes 리스트에 사용자 UID 값을 추가
          }),
          // user 컬렉션에서 사용자의 UID의 watchlist 리스트에 product_id 값 추가
          FirebaseFirestore.instance.collection('user').doc(uid).update(
            {
              'watchlist': FieldValue.arrayUnion([snapshot.data!['product_id']])
            },
          ),
        ],
      );
      // 새로고침
      setState(() {});
    } catch (e) {
      WarningSnackBar.show(
        context: context,
        text: '관심을 누르던 중 문제가 생겼어요.',
        paddingHorizontal: 0,
      );
      debugPrint(e.toString());
    }
  }
}
