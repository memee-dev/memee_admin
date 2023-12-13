import 'package:algolia/algolia.dart';

class ProductAlgolia extends Algolia {
  ProductAlgolia.init({
    required super.applicationId,
    required super.apiKey,
  }) : super.init();
}

class OrderAlgolia extends Algolia {
  OrderAlgolia.init({
    required super.applicationId,
    required super.apiKey,
  }) : super.init();
}
