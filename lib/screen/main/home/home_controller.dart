import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/const/common.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    getData();

    super.onInit();
  }

  final RxString selectedLocation = '전체'.obs;
  final RxList list = [].obs;
  Rx<DocumentSnapshot<Object?>?> lastDocument = null.obs;
  final RxBool isMore = true.obs;

  Future onRefresh() async {
    list.clear();
    getData();
    isMore.value = true;
  }

  void getData() async {
    var data = await FirebaseFirestore.instance
        .collection('product') // product 컬렉션으로부터
        .where('location', // Dropdown의 장소 값의 조건으로
            isEqualTo:
                selectedLocation.value == '전체' ? null : selectedLocation.value)
        .where('status', isLessThan: 2)
        .orderBy('status')
        .orderBy('uploadTime', descending: true) // uploadTime 정렬은 내림차순으로
        .limit(limit)
        .get(); // 데이터를 불러온다

    if (data.docs.isNotEmpty) {
      for (var document in data.docs) {
        list.add(document.data());
      }
      lastDocument = data.docs.last.obs;
    } else {
      lastDocument = null.obs;
    }
  }

  void getNextData() async {
    if (lastDocument.value != null) {
      var data = await FirebaseFirestore.instance
          .collection('product') // product 컬렉션으로부터
          .where('location', // Dropdown의 장소 값의 조건으로
              isEqualTo: selectedLocation.value == '전체'
                  ? null
                  : selectedLocation.value)
          .where('status', isLessThan: 2)
          .orderBy('status')
          .orderBy('uploadTime', descending: true) // uploadTime 정렬은 내림차순으로
          .startAfterDocument(lastDocument.value!)
          .limit(limit)
          .get(); // 데이터를 불러온다

      if (data.docs.isNotEmpty) {
        for (var document in data.docs) {
          list.add(document.data());
        }
        lastDocument = data.docs.last.obs;
      } else {
        lastDocument = null.obs;
      }
    } else {
      debugPrint("없음");
      InfoSnackBar.show(
        text: "마지막 항목입니다.",
        paddingBottom: 0,
      );
      isMore.value = false;
    }
  }
}
