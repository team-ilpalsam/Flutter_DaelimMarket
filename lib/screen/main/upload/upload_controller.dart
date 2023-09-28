import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadController extends GetxController {
  @override
  void onClose() {
    clearState();
    super.onClose();
  }

  RxBool isLoading = false.obs;
  RxString selectedLocation = '장소 선택'.obs;
  RxList pickedImages = [].obs;
  RxList downloadUrls = [].obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  void clearState() {
    isLoading.value = false;
    selectedLocation.value = '장소 선택';
    pickedImages.value = [];
    downloadUrls.value = [];
  }
}
