// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:csv/csv.dart';
import 'dart:convert' show utf8;

import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/core/shared/app_logger.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/category_model.dart';


import '../../core/initializer/app_di_registration.dart';
import '../../models/product_model.dart';

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
    // var excel = Excel.createExcel();
    // var sheet = excel[sheetName];

    // sheet.appendRow(title);

    try {
      for (T val in data) {
        if (T == CategoryModel) {
          var category = val as CategoryModel;
          // sheet.appendRow([
          //   category.id,
          //   category.name,
          // ]);
        } else if (T == ProductModel) {
          var product = val as ProductModel;
          List<List<dynamic>> csvData = flattenJson(product.toJson());
          String csvString = const ListToCsvConverter().convert(csvData);
          console.i('EXPORT  Success: $csvString');
           File('output.csv').writeAsStringSync(csvString);
          final file = File('memee.csv');
       file.writeAsStringSync(csvString);
        }
      }
    } catch (e) {
      console.e('EXPORT  Error:', error: e);
    }

    //var excelData = excel.encode();

    // if (kIsWeb) {
    //   final blob = html.Blob([excelData],
    //       'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

    //   final url = html.Url.createObjectUrlFromBlob(blob);
    //   html.AnchorElement(href: url)
    //     ..setAttribute('download', '${AppStrings.appName}.xlsx')
    //     ..click();

    //   html.Url.revokeObjectUrl(url);
    // } else {
    //   final directory = (await getApplicationDocumentsDirectory()).path;
    //   final excelPath = '$directory/${AppStrings.appName}.xlsx';

    //   final file = File(excelPath);
    //   await file.writeAsBytes(excelData!);
    // }
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

List<List<dynamic>> flattenJson(Map<String, dynamic> json) {
  List<List<dynamic>> result = [];

  void process(Map<String, dynamic> json, [String parentKey = '']) {
    json.forEach((key, value) {
      final currentKey = parentKey.isEmpty ? key : '$parentKey.$key';

      if (value is Map<String, dynamic>) {
        process(value, currentKey);
      } else if (value is List) {
        for (var i = 0; i < value.length; i++) {
          if (value[i] is Map || value[i] is List) {
            process(value[i], '$currentKey[$i]');
          } else {
            result.add([currentKey, value[i]]);
          }
        }
      } else {
        result.add([currentKey, value]);
      }
    });
  }

  process(json);

  return result;
}


Future<void> exportDataToCSV(List<List<dynamic>> data) async {
  try {
    String csv = const ListToCsvConverter().convert(data);

    // Convert CSV string to Uint8List
    Uint8List csvBytes = Uint8List.fromList(utf8.encode(csv));

    // Create a blob URL for the CSV data
    String blobUrl = html.Url.createObjectUrlFromBlob(
      html.Blob([csvBytes]),
    );

    // Create an anchor element with the blob URL
    html.AnchorElement(href: blobUrl)
      ..target = 'blank'
      ..download = 'exported_data.csv'
      ..click();

    // Revoke the blob URL to free up resources
    html.Url.revokeObjectUrl(blobUrl);
  } catch (e) {
    print("Error exporting data: $e");
  }
}
