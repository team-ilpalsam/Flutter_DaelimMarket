import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/alert_dialog.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../const/common.dart';
import '../../../main.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descController;

  bool _isLoading = false;

  DateTime now = DateTime.now();

  String _selectedLocation = '장소 선택';

  @override
  void initState() {
    titleController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    priceController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    descController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descController.dispose();

    super.dispose();
  }

  @override
  void deactive() {
    super.deactivate();
  }

  List<XFile>? _pickedImages = [];
  List<String> downloadUrls = [];

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        // 키보드 위에 입력 창 띄우기 여부
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                MainAppbar.show(
                  title: '물건 등록',
                  leading: GestureDetector(
                    onTap: () {
                      _isLoading
                          ? null
                          : AlertDialogWidget.twoButtons(
                              context: context,
                              content: '등록을 취소하시겠습니까?\n작성한 내용은 저장되지 않습니다.',
                              button: ['아직이요', '나갈래요'],
                              color: [dmGrey, dmBlue],
                              action: [
                                () {
                                  Navigator.pop(context);
                                },
                                () {
                                  Navigator.pop(context);
                                  context.go('/main');
                                }
                              ],
                            );
                    },
                    child: Image.asset(
                      'assets/images/icons/icon_back.png',
                      alignment: Alignment.topLeft,
                      height: 18.h,
                    ),
                  ),
                  action: titleController.text.length >= 3 && // 제목이 3글자 이상이거나
                          priceController.text.isNotEmpty && // 가격을 작성하였거나
                          _selectedLocation != '장소 선택' && // 장소가 '장소 선택'이 아니거나
                          _pickedImages != null &&
                          _pickedImages!.isNotEmpty // 이미지를 선택하였거나
                      ? GestureDetector(
                          onTap: () {
                            _isLoading
                                ? null
                                : AlertDialogWidget.twoButtons(
                                    context: context,
                                    content: '판매 글을 등록하시겠습니까?',
                                    button: ['아직이요', '등록할래요!'],
                                    color: [dmGrey, dmBlue],
                                    action: [
                                      () {
                                        Navigator.pop(context);
                                      },
                                      onTapUpload
                                    ],
                                  );
                          },
                          child: _isLoading == true // Loading 상태일 경우
                              ? const CupertinoActivityIndicator()
                              : Text(
                                  "완료",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18.sp,
                                    fontWeight: medium,
                                    color: dmBlue,
                                  ),
                                ),
                        )
                      :
                      // 조건에 충족하지 못 하였을 경우 회색 글씨
                      Text(
                          "완료",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18.sp,
                            fontWeight: medium,
                            color: dmLightGrey,
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32.5.h),
                      Text(
                        '사진 (${_pickedImages?.length ?? '0'}/5)',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18.sp,
                          fontWeight: medium,
                          color: dmBlack,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _pickedImages!.map(
                                (value) {
                                  return Padding(
                                    // 사진마다의 오른쪽 padding 부여
                                    padding: EdgeInsets.only(
                                        // 마지막 요소를 제외하고 오른쪽 padding 부여
                                        right: value == _pickedImages!.last &&
                                                _pickedImages!.length >= 5
                                            ? 0
                                            : 10.w),
                                    child: Stack(
                                      clipBehavior:
                                          Clip.none, // 부모 위젯을 벗어나도 잘리지 않게
                                      children: [
                                        Container(
                                          width: 96.w,
                                          height: 96.w,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  Image.file(File(value.path))
                                                      .image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // Loading 상태일 경우
                                        _isLoading
                                            ? Container()
                                            // 이미지 리스트 제거
                                            : Positioned(
                                                top: 5.h,
                                                right: 5.w,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _pickedImages!
                                                          .remove(value);
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 20.w,
                                                    height: 20.h,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: dmWhite,
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 15.w,
                                                        color: dmBlack,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  );
                                },
                              ).toList() +
                              [
                                // 이미지 추가
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 0,
                                  ),
                                  child: _pickedImages!.length < 5
                                      ?
                                      // 5장 미만일 경우
                                      GestureDetector(
                                          onTap: () {
                                            AlertDialogWidget.twoButtons(
                                              context: context,
                                              content: "사진을 선택해주세요!",
                                              button: ["앨범에서 선택", "카메라로 촬영"],
                                              color: [dmBlue, dmBlue],
                                              action: [
                                                onTapAddPhotoFromAlbum,
                                                onTapAddPhotoFromCamera,
                                              ],
                                            );
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 96.w,
                                                height: 96.w,
                                                color: dmGrey,
                                              ),
                                              Image.asset(
                                                'assets/images/icons/icon_add.png',
                                                height: 43.85.h,
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                )
                              ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Divider(
                        thickness: 1.w,
                        color: dmGrey,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 40.h,
                        child: TextField(
                          enabled: _isLoading ? false : true,
                          controller: titleController,
                          style: mainInputTextDeco,
                          decoration: mainInputDeco('글 제목'),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(25),
                          ],
                          cursorColor: dmBlack,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 40.h,
                        child: TextField(
                          enabled: _isLoading ? false : true,
                          controller: priceController,
                          style: mainInputTextDeco,
                          decoration: mainInputDeco('가격 (1억 미만)'),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(8),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorColor: dmBlack,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      GestureDetector(
                        onTap:
                            // Loading 상태일 경우
                            _isLoading
                                ? () {}
                                : () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (_) {
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 250.h,
                                            child: CupertinoPicker(
                                              backgroundColor: Colors.white,
                                              onSelectedItemChanged:
                                                  // item이 변경될 때마다 setState 설정
                                                  (index) {
                                                setState(() {
                                                  _selectedLocation =
                                                      locationList[index];
                                                });
                                              },
                                              itemExtent: 40.h,
                                              children:
                                                  // _locationList 리스트를 picker의 item으로 변환
                                                  locationList.map((value) {
                                                return Center(
                                                    child: Text(value));
                                              }).toList(),
                                            ),
                                          );
                                        });
                                  },
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.w,
                              color: _isLoading ? dmDarkGrey : dmLightGrey,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 8.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedLocation,
                                  style: mainInputTextDeco,
                                ),
                                Image.asset(
                                  'assets/images/icons/icon_arrow_down.png',
                                  height: 11.5.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 200.h,
                        child: TextField(
                          enabled: _isLoading ? false : true,
                          controller: descController,
                          keyboardType: TextInputType.multiline,
                          expands: true,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          style: mainInputTextDeco,
                          decoration: mainInputDeco('설명글'),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(128),
                          ],
                          cursorColor: dmBlack,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 업로드 처리 메소드
  onTapUpload() async {
    // 확인창 닫기
    Navigator.pop(context);
    // Loading 상태를 true로 변경
    setState(() {
      _isLoading = true;
    });
    try {
      // productId 변수에 'yyyyMMddHHmmss_id' 형식으로 대입
      String productId = '${DateFormat('yyyyMMddHHmmss').format(now)}_$id';

      // Future.wait 내 코드가 다 수행될 때까지 대기
      await Future.wait(_pickedImages!.asMap().entries.map((entry) async {
        final index = entry.key;
        final value = entry.value;

        // Firebase Storage에 product 디렉터리 내 productId 디렉터리를 생성한 후 'productId_index.파일확장자' 형식으로 저장
        Reference ref = FirebaseStorage.instance.ref().child(
            'product/$productId/${productId}_$index.${value.path.split('.').last}');
        final UploadTask uploadTask =
            ref.putData(File(value.path).readAsBytesSync());
        // 만약 사진 업로드 성공 시
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

        // 사진의 다운로드 가능한 url을 불러온 후
        final url = await taskSnapshot.ref.getDownloadURL();

        // downloadUrls 리스트에 추가
        downloadUrls.add(url.toString());

        debugPrint(uploadTask.toString());
        debugPrint(taskSnapshot.toString());

        // user 컬렉션 내 사용자의 uid 문서의 posts 리스트에 productId 값 추가
        await FirebaseFirestore.instance.collection('user').doc(uid).update({
          'posts': FieldValue.arrayUnion([productId])
        });

        // product 컬렉션 내 productId 문서에 데이터 저장
        await FirebaseFirestore.instance
            .collection('product')
            .doc(productId)
            .set({
          'id': id,
          'uid': uid,
          'product_id': productId,
          'nickName': nickName,
          'price': priceController.text,
          'title': titleController.text,
          'location': _selectedLocation == '장소 선택'
              ? locationList[0]
              : _selectedLocation,
          'desc': descController.text,
          'images': downloadUrls,
          'likes': [],
          'uploadTime': now,
          'status': 0,
        });
      }));

      context.go('/main');
      DoneSnackBar.show(
        context: context,
        text: '성공적으로 등록했어요!',
        paddingBottom: 0,
      );
    } catch (e) {
      context.go('/main');
      WarningSnackBar.show(
        context: context,
        text: '판매글 등록 중 문제가 생겼어요.',
        paddingBottom: 0,
      );
      debugPrint(e.toString());
    }
  }

  onTapAddPhotoFromAlbum() async {
    Navigator.pop(context);
    try {
      // 앨범에 여러 장 선택할 수 있는 ImagePicker 불러옴
      await ImagePicker().pickMultiImage().then(
        (xfile) {
          // 아무것도 고르지 않았다면
          if (xfile == null) {
            return;
          }
          // 기존 이미지 개수와 선택한 이미지 개수를 합쳤을 때 5장을 넘겼을 시
          if (_pickedImages!.length + xfile.length > 5) {
            WarningSnackBar.show(
              context: context,
              text: '사진은 5장까지만 올릴 수 있어요!',
              paddingBottom: 0,
            );
            return;
          }
          // 선택한 이미지와 리스트 병합
          setState(
            () {
              _pickedImages = _pickedImages! + (xfile);
            },
          );
        },
      );
    } catch (e) {
      WarningSnackBar.show(
        context: context,
        text: '사진을 불러오는 중 실패했어요.',
        paddingBottom: 0,
      );
      debugPrint(e.toString());
    }
  }

  onTapAddPhotoFromCamera() async {
    Navigator.pop(context);
    try {
      // 카메라를 불러옴
      await ImagePicker().pickImage(source: ImageSource.camera).then(
        (xfile) {
          // 아무것도 고르지 않았다면
          if (xfile == null) {
            return;
          }
          // 기존 이미지 개수와 카메라로 촬영한 이미지 한 장을 합쳤을 때 5장을 넘겼을 시
          if (_pickedImages!.length + 1 > 5) {
            WarningSnackBar.show(
              context: context,
              text: '사진은 5장까지만 올릴 수 있어요!',
              paddingBottom: 0,
            );
            return;
          }
          setState(
            () {
              _pickedImages = _pickedImages! + ([xfile]); // 한 장이므로 대괄호에 감싸서 계산
            },
          );
        },
      );
    } catch (e) {
      WarningSnackBar.show(
        context: context,
        text: '사진을 불러오는 중 실패했어요.',
        paddingBottom: 0,
      );
      debugPrint(e.toString());
    }
  }
}
