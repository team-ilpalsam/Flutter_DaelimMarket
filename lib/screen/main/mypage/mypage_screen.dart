import 'package:cached_network_image/cached_network_image.dart';
import 'package:daelim_market/screen/main/mypage/mypage_controller.dart';
import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/named_widget.dart';

class MypageScreen extends StatelessWidget {
  MypageScreen({super.key});

  final MypageController _controller = Get.put(MypageController());

  Future<void> onRefresh() async {
    _controller.myPostsLimitValue.clear();
    _controller.myWatchlistLimitValue.clear();

    _controller.getMyData();
  }

  Widget imageBlock(list, index, history) {
    return GestureDetector(
      onTap: () {
        if (index == 5) {
          Get.toNamed(
            '/history',
            parameters: {
              'history': history,
            },
          );
        } else {
          Get.toNamed(
            'detail',
            parameters: {
              'productId': list[index]['product_id'],
            },
          );
        }
      },
      child: CachedNetworkImage(
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        imageUrl: list[index]['images'][0],
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) => Container(
          width: 105.w,
          height: 105.w,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  color: dmGrey,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              index == 5
                  ? Container(
                      decoration: BoxDecoration(
                        color: dmBlack.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 50.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int i = 0; i < 3; i++)
                              Container(
                                width: 10.w,
                                height: 10.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dmWhite,
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : list[index]['status'] == 1 || list[index]['status'] == 2
                      ? Container(
                          width: 105.w,
                          height: 105.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: dmBlack.withOpacity(0.75),
                          ),
                          child: Center(
                            child: list[index]['status'] == 1
                                ? Image.asset(
                                    'assets/images/status/status_1.png',
                                    width: 95.h,
                                  )
                                : Image.asset(
                                    'assets/images/status/status_2.png',
                                    width: 95.h,
                                  ),
                          ),
                        )
                      : const SizedBox()
            ],
          ),
        ),
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            color: dmGrey,
            borderRadius: BorderRadius.circular(5.r),
          ),
          width: 105.w,
          height: 105.w,
          alignment: Alignment.center,
          child: index == 5
              ? SizedBox(
                  width: 50.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 3; i++)
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: dmWhite,
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  backgroundColor: dmWhite,
                  color: dmDarkGrey,
                  strokeWidth: 2.w,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 9.5.w, top: 34.5.h),
                            child: Obx(
                              () => Row(
                                children: [
                                  _controller.myProfileImage.value == ''
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14758,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14758,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: dmLightGrey,
                                          ),
                                        )
                                      : CachedNetworkImage(
                                          fadeInDuration: Duration.zero,
                                          fadeOutDuration: Duration.zero,
                                          imageUrl:
                                              _controller.myProfileImage.value,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14758,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14758,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14758,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14758,
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
                                                0.14758,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14758,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: dmLightGrey,
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 23.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _controller.myNickName.value == ''
                                              ? '불러오는 중...'
                                              : _controller.myNickName.value,
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 24.sp,
                                            fontWeight: medium,
                                            color: dmBlack,
                                          ),
                                        ),
                                        Text(
                                          _controller.myEmail.value == ''
                                              ? '불러오는 중...'
                                              : _controller.myEmail.value,
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
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/mypage_setting');
                            },
                            child: const BlueButton(
                              text: '프로필 수정',
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
                          Obx(
                            () => _controller.myWatchlistLimitValue.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1 / 1,
                                      crossAxisSpacing: 20.w,
                                      mainAxisSpacing: 20.w,
                                    ),
                                    itemCount: _controller
                                        .myWatchlistLimitValue.length,
                                    itemBuilder: (context, index) {
                                      return imageBlock(
                                          _controller.myWatchlistLimitValue,
                                          index,
                                          'watchlist');
                                    },
                                  )
                                : const SizedBox(),
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
                          Obx(
                            () => _controller.myPostsLimitValue.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1 / 1,
                                      crossAxisSpacing: 20.w,
                                      mainAxisSpacing: 20.w,
                                    ),
                                    itemCount:
                                        _controller.myPostsLimitValue.length,
                                    itemBuilder: (context, index) {
                                      return imageBlock(
                                          _controller.myPostsLimitValue,
                                          index,
                                          'posts');
                                    })
                                : const SizedBox(),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
