import 'package:intl/intl.dart';

const int limit = 6;
const String textLessLogo = 'assets/images/logo/daelimmarket_textless.png';
const int maxFileSizeInBytes = 5 * 1024 * 1024;
const List<String> locationList = [
  '전체',
  '다산관',
  '생활관',
  '수암관',
  '율곡관',
  '임곡관',
  '자동차관',
  '전산관',
  '정보통신관',
  '퇴계관',
  '한림관',
  '홍지관',
];
const List<String> weekdayList = ['월요일', '화요일', '수요일', '목요일', '금요일'];

formatPrice(String price) {
  // 가격 포맷
  if (int.parse(price) >= 10000) {
    if (int.parse(price) % 10000 == 0) {
      return '${NumberFormat('#,###').format(int.parse(price) ~/ 10000)}만원';
    } else {
      return '${NumberFormat('#,###').format(int.parse(price) ~/ 10000)}만 ${NumberFormat('#,###').format(int.parse(price) % 10000)}원';
    }
  } else {
    return '${NumberFormat('#,###').format(int.parse(price))}원';
  }
}
