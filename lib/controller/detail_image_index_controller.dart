import 'package:flutter_bloc/flutter_bloc.dart';

class DetailImageIndexController extends Cubit<int> {
  DetailImageIndexController(index) : super(index);

  void setIndex(imgIndex) => emit(imgIndex);
}
