import 'package:flutter/material.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/landing/components/categories/categories_widget.dart';
import 'package:memee_admin/ui/landing/components/dl-executives/dl_executive_widget.dart';
import 'package:memee_admin/ui/landing/components/home/home_widget.dart';
import 'package:memee_admin/ui/landing/components/products/products_widget.dart';
import 'package:memee_admin/ui/landing/components/users/users_widget.dart';

import '../components/admins/admins_widget.dart';
import '../components/dl2/dl_2_widget.dart';
import '../components/orders/orders_widget.dart';
import '../components/products2/products_2_widget.dart';

class LandingItemModel {
  final String name;
  final Widget child;

  const LandingItemModel(this.name, this.child);
}

final List<LandingItemModel> items = [
  const LandingItemModel(AppStrings.home, HomeWidget()),
  const LandingItemModel(AppStrings.orders, OrdersWidget()),
  const LandingItemModel(AppStrings.categories, CategoriesWidget()),
  LandingItemModel(AppStrings.products, ProductsWidget()),
  const LandingItemModel(AppStrings.users, UserWidget()),
  const LandingItemModel(AppStrings.admins, AdminWidget()),
  const LandingItemModel(AppStrings.dlExecutive, DLExecutiveWidget()),
  const LandingItemModel('dl2', DLExecutiveWidget2()),
  LandingItemModel('Products Widget2', ProductsWidget2()),
];
