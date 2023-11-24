import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleCubit extends Cubit<bool> {
  ToggleCubit() : super(true);

  void initialValue(bool val) => emit(val);
  void change() => emit(!state);
}
