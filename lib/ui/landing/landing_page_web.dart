import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/blocs/index/index_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/ui/landing/model/landing_item_model.dart';

class LandingPageWeb extends StatelessWidget {
  final indexCubit = locator.get<IndexCubit>();

  LandingPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<CategoriesCubit>()..fetchCategories(clear: true),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: ListView(
                padding: EdgeInsets.zero,
                children: items.map(
                  (e) {
                    final index = items.indexOf(e);
                    return BlocBuilder<IndexCubit, int>(
                      bloc: indexCubit,
                      builder: (_, state) {
                        return ListTile(
                          selected: (state == index),
                          title: Text(
                            e.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: (state == index)
                                      ? Colors.amber
                                      : Colors.white,
                                ),
                          ),
                          onTap: () => indexCubit.onIndexChange(index),
                        );
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<IndexCubit, int>(
              bloc: indexCubit,
              builder: (_, state) {
                return items[state].child;
              },
            ),
          ),
        ],
      ),
    );
  }
}
