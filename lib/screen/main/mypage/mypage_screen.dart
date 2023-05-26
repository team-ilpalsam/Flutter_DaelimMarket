import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:daelim_market/main.dart';
import '../../widgets/named_widget.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  String uidNickName = "";
  String imgURL = "";
  List postsIndex = [];
  String productImage = "";

  @override
  Widget build(BuildContext context) {
    getData();
    //getData2();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                '마이페이지',
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 9.5.w, top: 34.5.h),
                        child: Row(
                          children: [
                            imgURL == ''
                                ? Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.14758,
                                    height: MediaQuery.of(context).size.width *
                                        0.14758,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.14758,
                                    height: MediaQuery.of(context).size.width *
                                        0.14758,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.14758,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.14758,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider),
                                        shape: BoxShape.circle,
                                        color: dmLightGrey,
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: EdgeInsets.only(left: 23.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    uidNickName,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 24.sp,
                                      fontWeight: medium,
                                      color: dmBlack,
                                    ),
                                  ),
                                  Text(
                                    email!,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 16.sp,
                                      fontWeight: medium,
                                      color: dmDarkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed('mypagesetting');
                        },
                        child: const BlueButton(
                          text: '프로필 수정',
                          color: dmGrey,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      divider,
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/icons/icon_heart.png',
                              height: 22.h,
                              width: 24.w,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 11.w),
                            child: Text(
                              '관심목록',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 20.sp,
                                fontWeight: medium,
                                color: dmDarkGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        //관심목록 첫째줄
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: dmRed,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            width: 105.w,
                            height: 105.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: dmRed,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            width: 105.w,
                            height: 105.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: dmRed,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            width: 105.w,
                            height: 105.h,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Row(
                        //관심목록 둘째줄
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: dmRed,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            width: 105.w,
                            height: 105.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: dmRed,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            width: 105.w,
                            height: 105.h,
                          ),
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('historyscreen',
                                      queryParams: {'history': 'watchlist'});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: dmRed,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  width: 105.w,
                                  height: 105.h,
                                ),
                              ),
                              // 전체보기 점 세개
                              Positioned(
                                left: 28.w,
                                top: 48.h,
                                child: Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dmWhite,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 48.w,
                                top: 48.h,
                                child: Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dmWhite,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 68.w,
                                top: 48.h,
                                child: Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dmWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      divider,
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/icons/icon_paper.png',
                              height: 22.h,
                              width: 24.w,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 11.w),
                            child: Text(
                              '판매내역',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 20.sp,
                                fontWeight: medium,
                                color: dmDarkGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        //판매내역 첫째줄
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: dmBlue,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            width: 105.w,
                            height: 105.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: dmBlue,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            width: 105.w,
                            height: 105.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: dmBlue,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            width: 105.w,
                            height: 105.h,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Row(
                        //판매내역 둘째줄
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: dmBlue,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            width: 105.w,
                            height: 105.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: dmBlue,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            width: 105.w,
                            height: 105.h,
                          ),
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('historyscreen',
                                      queryParams: {'history': 'posts'});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: dmBlue,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  width: 105.w,
                                  height: 105.h,
                                ),
                              ),
                              // 전체보기 점 세개
                              Positioned(
                                left: 28.w,
                                top: 48.h,
                                child: Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dmWhite,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 48.w,
                                top: 48.h,
                                child: Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dmWhite,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 68.w,
                                top: 48.h,
                                child: Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dmWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 70.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  getData2() async {
    var productData =
        await FirebaseFirestore.instance.collection('product').doc().get();

    var dataMap2 = productData.data();
    postsIndex = dataMap2!['posts'][0];

    if (mounted) setState(() {});
  }

  getProductData() async {
    var productData = await FirebaseFirestore.instance
        .collection('user') // product 컬렉션으로부터
        .doc('$uid') // 넘겨받은 productid 필드의 데이터를
        .get('posts'[0] as GetOptions?);

    setState(() {
      productImage = productData.data()?['profile_image'][0];
    });
  }
}
