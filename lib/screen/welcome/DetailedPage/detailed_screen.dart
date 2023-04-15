import 'package:carousel_images/carousel_images.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DetailedScreen extends StatefulWidget {
  final VoidCallback? onTap;

  const DetailedScreen({
    this.onTap,
    super.key,
  });

  @override
  State<DetailedScreen> createState() => _DetailedScreen();
}

class _DetailedScreen extends State<DetailedScreen> {
  final List<String> listImages = [
    //이미지 데이터
    'https://media.bunjang.co.kr/product/218586823_4_1679311213_w856.jpg',
    'https://media.bunjang.co.kr/product/212044447_4_1674753064_w856.jpg',
    'https://media.bunjang.co.kr/product/214789051_7_1676480918_w856.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dmWhite,
      body: SafeArea(
        top: false,
        // child: Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: 33.w,
        //   ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 88.h,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 26.5.w), //왼쪽에서 53 이동하면 없어짐 그래서 절반만 움직음
                            child: Image.asset(
                              'assets/images/icons/icon_back.png',
                              alignment: Alignment.topLeft,
                              height: 16.h,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 370,
                        height: 29.h,
                        child: Text(
                          "맥북 에어 16gb 512gb 애플팔아요 애플이 왓어요",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 22.sp,
                            fontWeight: medium,
                            color: dmBlack,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  SizedBox(
                    height: 27.5.h,
                  ),
                  Container(
                    //상단 가로 선
                    height: 1.h,
                    width: 393.w,
                    color: dmGrey,
                  ),

                  //SizedBox(
                  // height: 23.5.h,
                  //), 사이즈 박스 없는게 더 비슷한디? 아닌가...
                  // child: Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 33.w,
                  //   ),

                  // 이미지가 있으면 이거, 없으면 준비한 없다고 표시하는 이미지? 아니면 내가 만들어?
                  Center(
                    // child: Container(
                    //   width: 351.w,
                    //   height: 351.h,
                    //   color: dmBlue,
                    //   child: Center(
                    //       child: Text(
                    //     '게시된 이미지가 없습니다.',
                    //     style: TextStyle(
                    //       fontFamily: 'Pretendard',
                    //       color: dmWhite,
                    //       fontSize: 16.sp,
                    //     ),
                    //   )),

                    child: Column(
                      children: [
                        SizedBox(
                          height: 23.5.h,
                        ),
                        CarouselImages(
                          listImages: listImages,
                          height: 351.h,
                          borderRadius: 0,
                          cachedNetworkImage: true,
                          verticalAlignment: Alignment.center,
                          onTap: (index) {
                            print('Tapped on page $index');
                          },
                        )
                      ],
                    ),
                    // ),이미지 없으면 주석 풀어
                  ),
                  SizedBox(
                    height: 19.h,
                  ),
                  Container(
                    //상세페이지 제목
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21.w),
                      child: Text(
                        '맥북 에어 16gb 512gb 애플케어X S급 중고 직거래만 가능합니다.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: dmBlack,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    //닉네임 + 건물
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21.w),
                      child: Text(
                        'HUGESILVER · 전산관', //전산관이랑 따로 해야하겠지? 잠시 보류
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: dmDarkGrey,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 22.h,
                  ),
                  Container(
                    //상세페이지 내용
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21.w),
                      child: Text(
                        '맥북 에어m1 메모리 16에 용량 512 제품입니다. 애플케어플러스 2025년 3월 5일 만료이고 양도 가능합니다. 배터리 정보는 사진으로 확인해주세욥! 연락주세용',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: dmBlack,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 22.h,
                  ),
                  Container(
                    //하단 날짜
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21.w),
                      child: Text(
                        '2023년 04월 15일 오전 2시 17분',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: dmDarkGrey,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18.5.h,
                  ),
                  Container(
                    height: 1.h,
                    width: 393.w,
                    color: dmGrey,
                  ),
                  SizedBox(
                    height: 16.5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        //하트 아이콘 부분
                        color: Colors.amber,
                        //width: 26.w,
                        //height: 26.h,
                        padding: EdgeInsets.only(left: 25.w),
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            size: 45,
                            color: dmGrey,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: 21.83.w,
                      ),
                      Container(
                        //하단 세로 막대
                        height: 40.h,
                        width: 2.w,
                        color: dmDarkGrey,
                      ),
                      SizedBox(
                        width: 20.5.w,
                      ),
                      Container(
                        //금액
                        child: Text(
                          '1,209,999원',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            color: dmBlue,
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 33.w,
                      ),
                      Container(
                        //채팅하기 버튼
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: dmBlue),
                        width: 115.w,
                        height: 34.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('채팅하기',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  color: dmWhite,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
