import 'dart:convert';

import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementScholarshipScreen extends StatelessWidget {
  AnnouncementScholarshipScreen({super.key});

  final dio = Dio();

  Future<Map?> getData() async {
    try {
      final data = await dio.get(
        'https://www.daelim.ac.kr/ajaxf/FrBoardSvc/BBSViewList.do?pageNo=1&MENU_ID=990&SITE_NO=2&BOARD_SEQ=9',
      );

      if (data.data != null) {
        return jsonDecode(data.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      WarningSnackBar.show(
        text: '학사공지 정보를 불러오는 중 실패했습니다.',
        paddingBottom: 0,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          return FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: snapshot.data!['data']['list'].isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.07463),
                                child: ListView.separated(
                                  separatorBuilder: (context, index) => divider,
                                  itemCount:
                                      snapshot.data!['data']['list'].length,
                                  itemBuilder: (context, index) {
                                    List data = snapshot.data!['data']['list'];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: index == 0
                                            ? size.height * 0.03129
                                            : size.height * 0.02347,
                                        bottom: index ==
                                                snapshot.data!['data']['list']
                                                        .length -
                                                    1
                                            ? size.height * 0.07824
                                            : size.height * 0.02347,
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          Uri url = Uri.parse(
                                              'https://www.daelim.ac.kr/cms/FrBoardCon/BoardView.do?MENU_ID=900&SITE_NO=2&BOARD_SEQ=8&BBS_SEQ=${data[index]['BBS_SEQ']}');
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${data[index]['TOP_YN'] == 'Y' ? '[공지] ' : ''}${data[index]['SUBJECT']}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 18.sp,
                                                fontWeight: medium,
                                                color: dmBlack,
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.height * 0.01564,
                                            ),
                                            Text(
                                              '${data[index]['WRITE_DATE']} | 조회수 ${data[index]['HITS']}',
                                              overflow: TextOverflow.ellipsis,
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
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  '공지사항이 없어요.',
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
                  ],
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
