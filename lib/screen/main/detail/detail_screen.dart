import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/main/mypage/mypage_controller.dart';
import 'package:daelim_market/screen/widgets/alert_dialog.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../../styles/fonts.dart';
import '../../widgets/snackbar.dart';

class DetailScreen extends StatelessWidget {
  final String productId;

  DetailScreen({super.key, required this.productId});

  final _statusList = [
    '판매중',
    '예약중',
    '판매완료',
  ];

  final _statusColorList = [
    dmGreen,
    dmYellow,
    dmGrey,
  ];

  final MypageController _mypageController = Get.put(MypageController());

  final RxInt _imageIndex = 1.obs;
  final RxString _userNickName = '조회 중...'.obs;
  final RxString _userProfileImage = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            // Firebase의 Firestore 데이터 불러오기
            StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('product') // product 컬렉션으로부터
              .doc(productId) // 넘겨받은 productID 문서의 데이터를
              .snapshots(), // 불러온다
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
                        Get.back();
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
              FirebaseFirestore.instance
                  .collection('user')
                  .doc(snapshot.data!['uid'])
                  .get()
                  .then((value) {
                _userProfileImage.value = value.data()!["profile_image"];
                _userNickName.value = value.data()!["nickName"];
              });
              return Column(
                children: [
                  // Title
                  MainAppbar.show(
                    // 제목
                    title: snapshot.data!['title'],

                    // 왼쪽 아이콘
                    leading: GestureDetector(
                      onTap: () {
                        Get.back();
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
                                content: "정말로 삭제하시겠습니까?",
                                button: ["취소", "삭제할래요."],
                                color: [dmGrey, dmRed],
                                action: [
                                  () {
                                    Navigator.pop(context);
                                  },
                                  () {
                                    // 확인 창 닫기
                                    Navigator.pop(context);
                                    onTapDelete(context, snapshot);
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
                            // 캐로셀 이미지
                            Center(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      CarouselSlider(
                                        items: List<Widget>.from(
                                          snapshot.data!['images'].map((value) {
                                            return GestureDetector(
                                              onTap: () {
                                                // 이미지를 누를 시 src 데이터와 함께 ImageViewerScreen으로 이동
                                                if (snapshot.data!['status'] !=
                                                    2) {
                                                  Get.toNamed(
                                                    '/detail/image',
                                                    parameters: {'src': value},
                                                  );
                                                }
                                              },
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      fadeInDuration:
                                                          Duration.zero,
                                                      fadeOutDuration:
                                                          Duration.zero,
                                                      imageUrl: value,
                                                      placeholder: (context,
                                                              url) =>
                                                          const CupertinoActivityIndicator(),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    snapshot.data!['status'] ==
                                                            2
                                                        ? Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            color: dmBlack
                                                                .withOpacity(
                                                                    0.75),
                                                            child: Center(
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/status/status_2.png',
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.9,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                        options: CarouselOptions(
                                          viewportFraction: 1,
                                          autoPlay: false,
                                          enableInfiniteScroll: false, // 무한스크롤
                                          height:
                                              MediaQuery.of(context).size.width,
                                          onPageChanged: (index, reason) {
                                            _imageIndex.value = index + 1;
                                          },
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
                                            color: dmBlack.withOpacity(0.7),
                                            borderRadius:
                                                // 타원형
                                                BorderRadius.circular(3.40e+38),
                                          ),
                                          child: Center(
                                            child: Obx(
                                              () => Text(
                                                '$_imageIndex / ${snapshot.data!['images'].length}',
                                                style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: 16.sp,
                                                    fontWeight: bold,
                                                    color: dmLightGrey),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _statusList[snapshot.data!['status']],
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      color: _statusColorList[
                                          snapshot.data!['status']],
                                      fontSize: 18.sp,
                                      fontWeight: medium,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    snapshot.data!['title'],
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      color: dmBlack,
                                      fontSize: 21.sp,
                                      fontWeight: bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Obx(
                                    () => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _userProfileImage.value == ''
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10178,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10178,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: dmLightGrey,
                                                ),
                                              )
                                            : CachedNetworkImage(
                                                fadeInDuration: Duration.zero,
                                                fadeOutDuration: Duration.zero,
                                                imageUrl:
                                                    _userProfileImage.value,
                                                fit: BoxFit.cover,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10178,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10178,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.10178,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.10178,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    shape: BoxShape.circle,
                                                    color: dmLightGrey,
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.10178,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.10178,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: dmLightGrey,
                                                  ),
                                                ),
                                              ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          '${_userNickName.value} · ${snapshot.data!['location']}',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            color: dmDarkGrey,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  // 설명글의 데이터가 존재할 경우
                                  snapshot.data!['desc'] != ''
                                      ? Text(
                                          snapshot.data!['desc'],
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            color: dmBlack,
                                            fontSize: 16.sp,
                                          ),
                                        )
                                      : const SizedBox(),
                                  snapshot.data!['desc'] != ''
                                      ? SizedBox(
                                          height: 20.h,
                                        )
                                      : const SizedBox(),
                                  Text(
                                    DateFormat('yyyy년 M월 d일 a h시 mm분', 'ko_KR')
                                        .format(snapshot.data!['uploadTime']
                                            .toDate()),
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      color: dmDarkGrey,
                                      fontSize: 13.sp,
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
                    height: View.of(context).viewPadding.bottom > 0
                        ? 60.5.h
                        : 75.5.h,
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
                        top: View.of(context).viewPadding.bottom > 0
                            ? 10.h
                            : 0.h,
                        left: 25.w,
                        right: 20.w,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 30.w,
                            height: 27.h,
                            child: snapshot.data!['likes'].contains(uid)
                                ? GestureDetector(
                                    onTap: () {
                                      onTapCancelLike(context, snapshot);
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
                                      onTapLike(context, snapshot);
                                    },
                                    child: Image.asset(
                                      'assets/images/icons/icon_heart.png',
                                      height: 27.h,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            width: 15.5.w,
                          ),
                          Container(
                            width: 1.w,
                            height: 36.h,
                            color: dmDarkGrey,
                          ),
                          SizedBox(
                            width: 15.w,
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
                          snapshot.data!['uid'] != uid
                              ? GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      'chat',
                                      parameters: {
                                        'userUID': snapshot.data!['uid'],
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 115.w,
                                    height: 34.h,
                                    decoration: BoxDecoration(
                                      color: dmBlue,
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
                              : GestureDetector(
                                  onTap: () {
                                    if (snapshot.data!['status'] != 2) {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoActionSheet(
                                            title: null,
                                            message: null,
                                            actions: <Widget>[
                                              CupertinoActionSheetAction(
                                                child: Text(_statusList[0]),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'product') // product 컬렉션에서
                                                      .doc(
                                                          productId) // product_id의 문서 내
                                                      .update({'status': 0});
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoActionSheetAction(
                                                child: Text(_statusList[1]),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'product') // product 컬렉션에서
                                                      .doc(
                                                          productId) // product_id의 문서 내
                                                      .update({'status': 1});
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoActionSheetAction(
                                                child: Text(_statusList[2]),
                                                onPressed: () {
                                                  AlertDialogWidget.twoButtons(
                                                      content:
                                                          '판매완료로 변경하면 더 이상 바꿀 수 없게 되어버려요!\n계속 진행할까요?',
                                                      button: [
                                                        '아직이요',
                                                        '바꿀게요!'
                                                      ],
                                                      color: [
                                                        dmGrey,
                                                        dmBlue
                                                      ],
                                                      action: [
                                                        () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        () {
                                                          Navigator.pop(
                                                              context);
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'product') // product 컬렉션에서
                                                              .doc(
                                                                  productId) // product_id의 문서 내
                                                              .update({
                                                            'status': 2
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      ]);
                                                },
                                              ),
                                            ],
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              isDefaultAction: true,
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // 작업 시트 닫기
                                              },
                                              child: const Text('취소'),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 115.w,
                                    height: 34.h,
                                    decoration: BoxDecoration(
                                      color: snapshot.data!['status'] != 2
                                          ? dmBlue
                                          : dmLightGrey,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _statusList[
                                                snapshot.data!['status']],
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 16.sp,
                                              fontWeight: bold,
                                              color: dmWhite,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Image.asset(
                                            'assets/images/icons/icon_arrow_up.png',
                                            height: 8.h,
                                          ),
                                        ],
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
                        Get.back();
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
  Future<void> onTapDelete(BuildContext context, snapshot) async {
    try {
      // user 컬렉션 내 likes 배열에 있는 UID의 문서 내 watch_list 배열에 해당 product_id 요소를 제거 후 업데이트한다.
      if (snapshot.data!['likes'].isNotEmpty) {
        snapshot.data!['likes'].forEach((element) async {
          await FirebaseFirestore.instance
              .collection('user')
              .doc(element)
              .update({
            'watchlist': FieldValue.arrayRemove([productId])
          });
        });
      }
      // Future.wait 내 코드가 다 수행될 때까지 대기
      await Future.wait([
        // user 컬렉션 내 업로드 한 user 문서의 posts 리스트 중 product_id를 가진 값을 삭제 후 업데이트
        FirebaseFirestore.instance
            .collection('user')
            .doc(snapshot.data!['uid'])
            .update({
          'posts': FieldValue.arrayRemove([productId]),
        }),

        // product 컬렉션 내 product_id 문서 삭제
        FirebaseFirestore.instance
            .collection('product')
            .doc(productId)
            .delete(),

        // FirebaseStorage에서 product 디렉토리 내 product_id를 가진 디렉토리의 파일을 모두 삭제
        FirebaseStorage.instance
            .ref('product/$productId')
            .listAll()
            .then((value) => Future.wait(value.items.map((e) => e.delete()))),
      ]);

      _mypageController.getMyData();
      Get.back();
      DoneSnackBar.show(
        text: '판매글을 삭제했어요.',
        paddingHorizontal: 0,
        paddingBottom: 0,
      );
    } catch (e) {
      _mypageController.getMyData();
      Get.back();
      WarningSnackBar.show(
        text: '판매글 삭제 중 문제가 생겼어요.',
        paddingHorizontal: 0,
        paddingBottom: 0,
      );
      debugPrint(e.toString());
    }
  }

  // 좋아요 취소 메소드
  Future<void> onTapCancelLike(BuildContext context, snapshot) async {
    try {
      // Future.wait 내 코드가 다 수행될 때까지 대기
      await Future.wait(
        [
          FirebaseFirestore.instance
              .collection('product') // product 컬렉션에서
              .doc(productId) // product_id의 문서 내
              .update({
            'likes': FieldValue.arrayRemove([uid!]) // likes 리스트에 사용자 UID 값을 제거
          }),
          // user 컬렉션에서 사용자의 UID의 watchlist 리스트에 product_id 값 제거
          FirebaseFirestore.instance.collection('user').doc(uid).update(
            {
              'watchlist': FieldValue.arrayRemove([productId])
            },
          ),
        ],
      );
    } catch (e) {
      WarningSnackBar.show(
        text: '관심을 누르던 중 문제가 생겼어요.',
        paddingHorizontal: 0,
      );
      debugPrint(e.toString());
    }
  }

  // 좋아요 메소드
  Future<void> onTapLike(BuildContext context, snapshot) async {
    try {
      // Future.wait 내 코드가 다 수행될 때까지 대기
      await Future.wait(
        [
          FirebaseFirestore.instance
              .collection('product') // product 컬렉션에서
              .doc(productId) // product_id의 문서 내
              .update({
            'likes': FieldValue.arrayUnion([uid!]) // likes 리스트에 사용자 UID 값을 추가
          }),
          // user 컬렉션에서 사용자의 UID의 watchlist 리스트에 product_id 값 추가
          FirebaseFirestore.instance.collection('user').doc(uid).update(
            {
              'watchlist': FieldValue.arrayUnion([productId])
            },
          ),
        ],
      );
    } catch (e) {
      WarningSnackBar.show(
        text: '관심을 누르던 중 문제가 생겼어요.',
        paddingHorizontal: 0,
      );
      debugPrint(e.toString());
    }
  }
}
