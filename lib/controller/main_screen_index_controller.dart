import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreenIndexController extends Cubit<int> {
  MainScreenIndexController() : super(0);

  void setIndex(index) => emit(index);
}
