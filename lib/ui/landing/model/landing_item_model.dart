import 'package:flutter/material.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/admins/admins_widget.dart';
import 'package:memee_admin/ui/categories/categories_widget.dart';
import 'package:memee_admin/ui/home/home_widget.dart';
import 'package:memee_admin/ui/products/products_widget.dart';
import 'package:memee_admin/ui/users/users_widget.dart';

import '../../orders/orders_widget.dart';

class LandingItemModel {
  final String name;
  final Widget child;

  const LandingItemModel(this.name, this.child);
}

final List<LandingItemModel> items = [
  const LandingItemModel(AppStrings.home, HomeWidget()),
  const LandingItemModel(AppStrings.orders, OrdersWidget()),
  LandingItemModel(AppStrings.categories, CategoriesWidget()),
  LandingItemModel(AppStrings.products, ProductsWidget()),
  const LandingItemModel(AppStrings.users, UsersWidget()),
  const LandingItemModel(AppStrings.admins, AdminsWidget()),
];
