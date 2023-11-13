import 'package:flutter_bloc/flutter_bloc.dart';

class HideAndSeekCubit extends Cubit<bool> {
  HideAndSeekCubit() : super(true);

  void change() => emit(!state);
}
