import 'package:flutter/material.dart';
import 'package:memee_admin/core/shared/app_strings.dart';

import '../components/admins/admins_widget.dart';
import '../components/categories/categories_widget.dart';
import '../components/dl/dl_widget.dart';
import '../components/home/home_widget.dart';
import '../components/orders/orders_widget.dart';
import '../components/products2/products_widget.dart';
import '../components/users/users_widget.dart';

class LandingItemModel {
  final String name;
  final Widget child;

  const LandingItemModel(this.name, this.child);
}

final List<LandingItemModel> items = [
  const LandingItemModel(AppStrings.home, HomeWidget()),
  const LandingItemModel(AppStrings.orders, OrdersWidget()),
  const LandingItemModel(AppStrings.categories, CategoriesWidget()),
  const LandingItemModel(AppStrings.products, ProductsWidget()),
  const LandingItemModel(AppStrings.users, UserWidget()),
  const LandingItemModel(AppStrings.admins, AdminWidget()),
  const LandingItemModel(AppStrings.dlExecutive, DLExecutiveWidget()),
];
