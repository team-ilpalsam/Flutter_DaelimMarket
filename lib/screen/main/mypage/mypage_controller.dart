import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/main.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MypageController extends GetxController {
  @override
  void onInit() {
    getMyData();
    super.onInit();
  }

  final RxString myEmail = ''.obs;
  final RxString myNickName = ''.obs;
  final RxString myProfileImage = ''.obs;

  final RxList myPostsKeys = [].obs;
  final RxList myWatchlistKeys = [].obs;

  final RxList myPostsLimitValue = [].obs;
  final RxList myWatchlistLimitValue = [].obs;

  void getMyData() async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc('$uid')
          .get()
          .then((value) {
        myEmail.value = value.data()!['email'];
        myNickName.value = value.data()!['nickName'];
        myProfileImage.value = value.data()!['profile_image'];

        myPostsKeys.value = List.from(value.data()!['posts']).reversed.toList();
        myWatchlistKeys.value =
            List.from(value.data()!['watchlist']).reversed.toList();

        getPostsData();
        getWatchlistData();
      });
    } catch (e) {
      WarningSnackBar.show(
        text: "내 정보를 불러오는 중 오류가 발생했어요.",
        paddingBottom: 0,
      );
      debugPrint('마이페이지 컨트롤러 오류: ${e.toString()}');
    }
  }

  // 마이페이지 판매내역, 관심목록 블록 파트

  int limit = 6;

  void getPostsData() async {
    if (myPostsKeys.isNotEmpty) {
      List tempList = [];
      try {
        for (var i = 0;
            i < (myPostsKeys.length >= limit ? limit : myPostsKeys.length);
            i++) {
          await FirebaseFirestore.instance
              .collection('product')
              .doc(myPostsKeys[i])
              .get()
              .then((value) {
            tempList.add(value);
          });
        }
        myPostsLimitValue.value = tempList;
      } catch (e) {
        WarningSnackBar.show(
            text: '데이터를 불러오는 중 오류가 발생하였습니다.', paddingBottom: 0);
        debugPrint(e.toString());
      }
    }
  }

  void getWatchlistData() async {
    if (myWatchlistKeys.isNotEmpty) {
      List tempList = [];
      try {
        for (var i = 0;
            i <
                (myWatchlistKeys.length >= limit
                    ? limit
                    : myWatchlistKeys.length);
            i++) {
          await FirebaseFirestore.instance
              .collection('product')
              .doc(myWatchlistKeys[i])
              .get()
              .then((value) {
            tempList.add(value);
          });
        }
        myWatchlistLimitValue.value = tempList;
      } catch (e) {
        WarningSnackBar.show(
            text: '데이터를 불러오는 중 오류가 발생하였습니다.', paddingBottom: 0);
        debugPrint(e.toString());
      }
    }
  }
}