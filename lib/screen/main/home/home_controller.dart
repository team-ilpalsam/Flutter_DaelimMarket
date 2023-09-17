import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/const/common.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  BuildContext context;
  HomeController(this.context);

  @override
  void onInit() {
    getData();

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
          scrollController.value.position.maxScrollExtent) {
        getNextData();
      }
    });

    super.onInit();
  }

  final RxString selectedLocation = '전체'.obs;
  final RxList list = [].obs;
  final Rx<ScrollController> scrollController = ScrollController().obs;
  Rx<DocumentSnapshot<Object?>?> last = null.obs;

  Future onRefresh() async {
    list.clear();
    getData();
  }

  getData() async {
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
      last = data.docs.last.obs;
    } else {
      last = null.obs;
    }
  }

  getNextData() async {
    if (last.value != null) {
      var data = await FirebaseFirestore.instance
          .collection('product') // product 컬렉션으로부터
          .where('location', // Dropdown의 장소 값의 조건으로
              isEqualTo: selectedLocation.value == '전체'
                  ? null
                  : selectedLocation.value)
          .where('status', isLessThan: 2)
          .orderBy('status')
          .orderBy('uploadTime', descending: true) // uploadTime 정렬은 내림차순으로
          .startAfterDocument(last.value!)
          .limit(limit)
          .get(); // 데이터를 불러온다

      if (data.docs.isNotEmpty) {
        for (var document in data.docs) {
          list.add(document.data());
        }
        last = data.docs.last.obs;
      } else {
        last = null.obs;
      }
    } else {
      debugPrint("없음");
      InfoSnackBar.show(
        context: context,
        text: "마지막 항목입니다.",
        paddingBottom: 0,
      );
    }
  }
}
