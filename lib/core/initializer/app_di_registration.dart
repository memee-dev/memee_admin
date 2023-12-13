import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/blocs/dl_executives/dl_executive_cubit.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/blocs/payments/payments_cubit.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/core/initializer/app_aloglia.dart';

import '../../blocs/admins/admins_cubit.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/orders/orders_cubit.dart';
import '../../blocs/toggle/toggle_cubit.dart';
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
  locator.registerLazySingleton<FirebaseStorage>(
    () => FirebaseStorage.instance,
  );
  locator.registerLazySingleton<ProductAlgolia>(
    () => ProductAlgolia.init(
      applicationId: 'LDNGTJUKYJ',
      apiKey: 'abf28250124d323a522237e9b4988456',
    ),
  );
  locator.registerLazySingleton<OrderAlgolia>(
    () => OrderAlgolia.init(
      applicationId: 'LDNGTJUKYJ',
      apiKey: 'bf2bdd713969c387563bc023e9731a7d',
    ),
  );
  locator.registerLazySingleton<ImagePicker>(
    () => ImagePicker(),
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
  locator.registerFactory<ToggleCubit>(
    () => ToggleCubit(),
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
    () => AdminCubit(locator(), locator()),
  );
  locator.registerLazySingleton<UserCubit>(
    () => UserCubit(locator()),
  );
  locator.registerLazySingleton<PaymentsCubit>(
    () => PaymentsCubit(locator()),
  );
  locator.registerLazySingleton<OrdersCubit>(
    () => OrdersCubit(locator()),
  );
  locator.registerLazySingleton<DlExecutiveCubit>(
    () => DlExecutiveCubit(locator(), locator()),
  );
  locator.registerLazySingleton<ProductsCubit>(
    () => ProductsCubit(locator(), locator()),
  );
}
