// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'dart:convert' show utf8;

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';
import 'package:memee_admin/core/shared/app_logger.dart';
import 'package:memee_admin/models/category_model.dart';

import '../../models/product_model.dart';

enum ExportImportState {
  initial,
  loading,
  completed,
}

class ExportImportCubit extends Cubit<ExportImportState> {
  ExportImportCubit() : super(ExportImportState.initial);

  Future<void> exportCSV<T>() async {
    try {
      String? fileName;
      List<List<dynamic>>? items;
      if (T == CategoryModel) {
        fileName = AppFireStoreCollection.categories;
         items = locator.get<CategoriesCubit>().exportData();
      } else if (T == ProductModel) {
        fileName = AppFireStoreCollection.products;
        items = locator.get<ProductsCubit>().exportData();
      }

      if (fileName != null && items != null) {
        convertDataToCSV(fileName, items);
      }
    } catch (e) {
      console.e('EXPORT  ERROR!!!', error: e);
    }
  }

  Future<void> importCSV<T>() async {
    try {
      List<List<dynamic>>? csvData = await convertCSVToData();

      if (csvData != null) {
        if (T == CategoryModel) {
             await locator.get<CategoriesCubit>().importData(csvData);
        } else if (T == ProductModel) {
          await locator.get<ProductsCubit>().importData(csvData);
        }
      }
    } catch (e) {
      console.e('Error Importing data: ', error: e);
    }
  }
}

Future<List<List<dynamic>>?> convertCSVToData() async {
  FilePickerResult? file = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
    allowMultiple: false,
  );

  if (file != null) {
    final Uint8List fileBytes = file.files.first.bytes!;

    final String csvContent = utf8.decode(fileBytes);

    return const CsvToListConverter().convert(csvContent);
  }
  return null;
}

Future<void> convertDataToCSV(String title, List<List<dynamic>> data) async {
  try {
    String csv = const ListToCsvConverter().convert(data);

    Uint8List csvBytes = Uint8List.fromList(utf8.encode(csv));

    String blobUrl = html.Url.createObjectUrlFromBlob(
      html.Blob([csvBytes]),
    );

    html.AnchorElement(href: blobUrl)
      ..target = 'blank'
      ..download = '$title.csv'
      ..click();

    html.Url.revokeObjectUrl(blobUrl);
  } catch (e) {
    console.e('Error exporting data: ', error: e);
  }
}
