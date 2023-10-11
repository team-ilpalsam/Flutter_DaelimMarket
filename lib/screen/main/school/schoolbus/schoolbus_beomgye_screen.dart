import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart';

class SchoolbusBeomgyeScreen extends StatelessWidget {
  SchoolbusBeomgyeScreen({super.key});

  final dio = Dio();

  Future<String?> getHtmlData() async {
    try {
      final htmlData = await dio
          .get('https://www.daelim.ac.kr/cms/FrCon/index.do?MENU_ID=460');

      if (htmlData.data != null) {
        return htmlData.data;
      }
    } catch (e) {
      debugPrint(e.toString());
      WarningSnackBar.show(
        text: '셔틀버스 정보를 불러오는 중 실패했습니다.',
        paddingBottom: 0,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return FutureBuilder(
          future: getHtmlData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Document htmlData = parse(snapshot.data);

              return Column(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: size.width * 0.07463,
                              top: size.height * 0.03129,
                            ),
                            child: Text(
                              '범계역',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 28.sp,
                                fontWeight: bold,
                                color: dmBlack,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03129,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.07463,
                            ),
                            child: Text(
                              '※ 운행시간이 변동될 수 있습니다.',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 11.sp,
                                fontWeight: bold,
                                color: dmBlack,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03129,
                          ),
                          Expanded(
                            child: InteractiveViewer(
                              constrained: false,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.07463),
                                child: HtmlWidget(
                                  htmlData.querySelector(".mT30")!.innerHtml,
                                  textStyle: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16.sp,
                                    fontWeight: medium,
                                    color: dmBlack,
                                  ),
                                  customStylesBuilder: (element) {
                                    if (element.localName == 'caption') {
                                      return {'display': 'none'};
                                    }
                                    if (element.localName == 'th' ||
                                        element.localName == 'td') {
                                      return {
                                        'border-collapse': 'collapse',
                                        'border': '1px solid #1c1c1c',
                                        'text-align': 'center',
                                        'padding': '5px 10px',
                                      };
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        );
      }),
    );
  }
}
