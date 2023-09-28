import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/const/common.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchGetXController extends GetxController {
  final RxList list = [].obs;
  final RxString text = ''.obs;
  Rx<DocumentSnapshot<Object?>?> lastDocument = null.obs;
  final RxBool isMore = true.obs;

  void getData() async {
    var data = text.value != ''
        ? await FirebaseFirestore.instance
            .collection('product') // product 컬렉션으로부터
            .where('title', isGreaterThanOrEqualTo: text.value)
            .where('title', isLessThanOrEqualTo: '${text.value}\uf8ff')
            .orderBy('title')
            .orderBy('uploadTime', descending: true) // uploadTime 정렬은 내림차순으로
            .limit(limit)
            .get() // 데이터를 불러온다
        : await FirebaseFirestore.instance
            .collection('product') // product 컬렉션으로부터
            .where('title', isEqualTo: text.value)
            .orderBy('uploadTime', descending: true) // uploadTime 정렬은 내림차순으로
            .get();

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
      var data = text.value != ''
          ? await FirebaseFirestore.instance
              .collection('product') // product 컬렉션으로부터
              .where('title', isGreaterThanOrEqualTo: text.value)
              .where('title', isLessThanOrEqualTo: '${text.value}\uf8ff')
              .orderBy('title')
              .orderBy('uploadTime', descending: true) // uploadTime 정렬은 내림차순으로
              .startAfterDocument(lastDocument.value!)
              .limit(limit)
              .get() // 데이터를 불러온다
          : await FirebaseFirestore.instance
              .collection('product') // product 컬렉션으로부터
              .where('title', isEqualTo: text.value)
              .orderBy('uploadTime', descending: true) // uploadTime 정렬은 내림차순으로
              .startAfterDocument(lastDocument.value!)
              .get();

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
