// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/category_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/initializer/app_di_registration.dart';

enum ExportImportState {
  initial,
  loading,
  completed,
}

class ExportImportCubit extends Cubit<ExportImportState> {
  ExportImportCubit() : super(ExportImportState.initial);

  Future<void> exportExcel<T>({
    required List<T> data,
    required String sheetName,
    required List<String> title,
  }) async {
    emit(ExportImportState.loading);
    var excel = Excel.createExcel();
    var sheet = excel[sheetName];

    sheet.appendRow(title);

    for (T val in data) {
      if (T == CategoryModel) {
        var category = val as CategoryModel;
        sheet.appendRow([
          category.id,
          category.name,
        ]);
      }
    }

    var excelData = excel.encode();

    if (kIsWeb) {
      final blob = html.Blob([excelData],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', '${AppStrings.appName}.xlsx')
        ..click();

      html.Url.revokeObjectUrl(url);
    } else {
      final directory = (await getApplicationDocumentsDirectory()).path;
      final excelPath = '$directory/${AppStrings.appName}.xlsx';

      final file = File(excelPath);
      await file.writeAsBytes(excelData!);
    }
    emit(ExportImportState.completed);
  }

  Future<void> importExcel<T>() async {
    emit(ExportImportState.loading);

    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final html.File file = uploadInput.files!.first;

      final html.FileReader reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((html.ProgressEvent event) async {
        if (reader.readyState == html.FileReader.DONE) {
          var bytes = reader.result as List<int>;
          var excel = Excel.decodeBytes(bytes);

          final data = <T>[];

          if (T == CategoryModel) {
            for (var table in excel.tables.keys) {
              var firstRowSkipped = false;
              for (var row in excel.tables[table]!.rows) {
                if (!firstRowSkipped) {
                  firstRowSkipped = true;
                  continue; // Skip the first row (header row)
                }

                var id = row[0]?.value.toString();
                var name = row[1]?.value.toString();
                var active = row[2]?.value;

                if (id != null && name != null && active != null) {
                  data.add(CategoryModel(
                      id: id, name: name, active: active, image: '') as T);
                }
              }
            }
            locator
                .get<CategoriesCubit>()
                .addCategories(data as List<CategoryModel>);
          }
        }
      });
    });
    emit(ExportImportState.completed);
  }
}
