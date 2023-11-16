import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';

import '../../blocs/admins/admins_cubit.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/hide_and_seek/hide_and_seek_cubit.dart';
import '../../blocs/index/index_cubit.dart';
import '../../blocs/login/login_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/users/users_cubit.dart';

final locator = GetIt.I;

void init() {
  apiConfig(locator);
  blocConfig(locator);
}

void apiConfig(GetIt locator) {
  locator.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  locator.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
}

void blocConfig(GetIt locator) {
  locator.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(),
  );
  locator.registerLazySingleton<AuthCubit>(
    () => AuthCubit(locator(), locator()),
  );
  locator.registerLazySingleton<LoginCubit>(
    () => LoginCubit(locator(), locator()),
  );
  locator.registerFactory<HideAndSeekCubit>(
    () => HideAndSeekCubit(),
  );
  locator.registerFactory<IndexCubit>(
    () => IndexCubit(),
  );
  locator.registerFactory<ExportImportCubit>(
    () => ExportImportCubit(),
  );
  locator.registerLazySingleton<CategoriesCubit>(
    () => CategoriesCubit(locator()),
  );
  locator.registerLazySingleton<AdminCubit>(
    () => AdminCubit(locator()),
  );
  locator.registerLazySingleton<UserCubit>(
    () => UserCubit(locator()),
  );
  locator.registerLazySingleton<ProductsCubit>(
    () => ProductsCubit(locator()),
  );
}
