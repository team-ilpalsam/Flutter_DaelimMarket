import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';
import '../../../styles/colors.dart';
import '../../../styles/fonts.dart';
import '../../widgets/alert_dialog.dart';

class ChatScreen extends StatelessWidget {
  final String userUID;

  const ChatScreen({super.key, required this.userUID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('user').doc(userUID).get(),
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
                    ],
                  );
                }));
          },
        ),
      ),
    );
  }
}
