import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ThemeEvent { light, dark }

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  void changeTheme(ThemeEvent event) {
    switch (event) {
      case ThemeEvent.light:
        emit(lightTheme);
        break;
      case ThemeEvent.dark:
        emit(darkTheme);
        break;
    }
  }
}

final lightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  colorScheme: const ColorScheme.light(primary: Colors.pink),
  drawerTheme: const DrawerThemeData(backgroundColor: Colors.white24),
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 72.sp),
    headlineLarge: TextStyle(fontSize: 36.sp, fontStyle: FontStyle.italic),
    titleLarge: TextStyle(fontSize: 16.sp, fontFamily: 'Hind'),
    bodyLarge: TextStyle(fontSize: 14.sp, fontFamily: 'Hind'),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.pink,
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
  ),
  navigationDrawerTheme: NavigationDrawerThemeData(
    backgroundColor: 
  )
);

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  colorScheme: const ColorScheme.dark(primary: Colors.blueGrey),
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 72.sp),
    headlineLarge: TextStyle(fontSize: 36.sp, fontStyle: FontStyle.italic),
    titleLarge: TextStyle(fontSize: 16.sp, fontFamily: 'Hind'),
    bodyLarge: TextStyle(fontSize: 14.sp, fontFamily: 'Hind'),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blueGrey,
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
  ),
);
