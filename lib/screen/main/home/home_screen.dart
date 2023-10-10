import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:daelim_market/const/common.dart';
import 'package:daelim_market/screen/main/home/home_controller.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Title
            topPadding,
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 거래 장소 선택
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      menuItemStyleData: MenuItemStyleData(
                        padding: EdgeInsets.zero,
                        height: 33.h,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        elevation: 0,
                        width: 101.w,
                        decoration: BoxDecoration(
                          color: dmWhite,
                          border: Border.all(color: dmBlack),
                        ),
                        offset: Offset(0, -10.h),
                      ),
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.zero,
                      ),
                      iconStyleData: IconStyleData(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 14.37.w),
                          child: Image.asset(
                            'assets/images/icons/icon_arrow_down.png',
                            height: 11.5.h,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        // Dropdown의 값을 _selectedLocation에 대입
                        _controller.selectedLocation.value = value!;
                        _controller.onRefresh();
                      },
                      value: _controller.selectedLocation.value,
                      selectedItemBuilder: (BuildContext context) {
                        return locationList.map((value) {
                          return Text(
                            _controller.selectedLocation.value,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 28.sp,
                              fontWeight: bold,
                              color: dmBlack,
                            ),
                          );
                        }).toList();
                      },
                      items: locationList.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 16.sp,
                                  fontWeight: medium,
                                  color: dmBlack,
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/search');
                    },
                    child: Image.asset(
                      'assets/images/icons/icon_search_black.png',
                      width: 26.5.w,
                      height: 26.5.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 17.5.h),
            divider,

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                // ListView를 아래로 스와이프할 경우 Refresh
                child: CustomRefreshIndicator(
                  onRefresh: _controller.onRefresh,
                  builder: (context, child, controller) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        if (!controller.isIdle)
                          Positioned(
                            top: 40.h * controller.value,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 20.h,
                              ),
                              child: CupertinoActivityIndicator(
                                animating: !controller.isDragging,
                              ),
                            ),
                          ),
                        Transform.translate(
                          offset: Offset(0, 40.h * controller.value),
                          child: child,
                        ),
                      ],
                    );
                  },
                  child: Obx(
                    () =>
                        // 안드로이드 스와이프 Glow 애니메이션 제거
                        ScrollConfiguration(
                      behavior: MyBehavior(),
                      child:
                          // 데이터가 존재한다면
                          _controller.list.isNotEmpty
                              ? NotificationListener(
                                  onNotification:
                                      (ScrollNotification notification) {
                                    if (notification is ScrollEndNotification &&
                                        notification.metrics.maxScrollExtent ==
                                            notification.metrics.pixels) {
                                      _controller.getNextData();
                                    }
                                    return false;
                                  },
                                  child: ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: _controller.list.length,
                                    separatorBuilder: (context, index) =>
                                        divider,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        // 첫번째 요소에만 윗부분 padding을 추가적으로 줌
                                        padding: index == 0
                                            ? EdgeInsets.only(
                                                top: 30.5.h, bottom: 17.5.h)
                                            : EdgeInsets.symmetric(
                                                vertical: 17.5.h),
                                        child: Obx(
                                          () => Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    '/detail',
                                                    parameters: {
                                                      'productId': _controller
                                                              .list[index]
                                                          ['product_id'],
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  color: dmWhite,
                                                  // 기존 113.w에서 디바이스의 0.312배의 너비 값으로 변경
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.312,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                            fadeInDuration:
                                                                Duration.zero,
                                                            fadeOutDuration:
                                                                Duration.zero,
                                                            imageUrl: _controller
                                                                    .list[index]
                                                                ['images'][0],
                                                            fit: BoxFit.cover,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.312,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.312,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.r),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                color: dmGrey,
                                                              ),
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CupertinoActivityIndicator(),
                                                            errorWidget:
                                                                (context, url,
                                                                    error) {
                                                              return Center(
                                                                child: Text(
                                                                  '등록된 이미지가 없어요.',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Pretendard',
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        bold,
                                                                    color:
                                                                        dmLightGrey,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          _controller.list[
                                                                          index]
                                                                      [
                                                                      'status'] >
                                                                  0
                                                              ? Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.312,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.312,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.r),
                                                                    color: dmBlack
                                                                        .withOpacity(
                                                                            0.75),
                                                                  ),
                                                                  child: Center(
                                                                    child: _controller.list[index]['status'] ==
                                                                            1
                                                                        ? Image.asset(
                                                                            'assets/images/status/status_1.png',
                                                                            width: MediaQuery.of(context).size.width *
                                                                                0.312 *
                                                                                0.9)
                                                                        : Image.asset(
                                                                            'assets/images/status/status_2.png',
                                                                            width: MediaQuery.of(context).size.width *
                                                                                0.312 *
                                                                                0.9),
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 17.w,
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                child: Text(
                                                                  _controller.list[
                                                                          index]
                                                                      ['title'],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
                                                                  maxLines: 2,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Pretendard',
                                                                    fontSize:
                                                                        17.sp,
                                                                    fontWeight:
                                                                        medium,
                                                                    color:
                                                                        dmBlack,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 11.h,
                                                              ),
                                                              Text(
                                                                '${_controller.list[index]['location']} | ${DateFormat('yy.MM.dd').format((_controller.list[index]['uploadTime'].toDate()))}',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Pretendard',
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      medium,
                                                                  color: dmGrey,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 9.h,
                                                              ),
                                                              Text(
                                                                formatPrice(_controller
                                                                            .list[
                                                                        index]
                                                                    ['price']),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Pretendard',
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      bold,
                                                                  color: dmBlue,
                                                                ),
                                                              ),
                                                              const Expanded(
                                                                  child:
                                                                      SizedBox()),
                                                              // likes가 1개 이상일 때만 표시
                                                              Visibility(
                                                                maintainSize:
                                                                    true,
                                                                maintainAnimation:
                                                                    true,
                                                                maintainState:
                                                                    true,
                                                                visible: _controller
                                                                            .list[index]['likes']
                                                                            .length >
                                                                        0
                                                                    ? true
                                                                    : false,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        'assets/images/icons/icon_heart.png',
                                                                        width:
                                                                            13.w,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5.5.w,
                                                                      ),
                                                                      Text(
                                                                        '${_controller.list[index]['likes'].length}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Pretendard',
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontWeight:
                                                                              bold,
                                                                          color:
                                                                              dmGrey,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (_controller.isMore.value &&
                                                  _controller.list.length ==
                                                      index + 1 &&
                                                  _controller.list.length >=
                                                      limit) ...[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 40.h,
                                                  ),
                                                  child:
                                                      const CupertinoActivityIndicator(),
                                                )
                                              ]
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    '등록된 게시글이 없어요.',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 14.sp,
                                      fontWeight: bold,
                                      color: dmLightGrey,
                                    ),
                                  ),
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
