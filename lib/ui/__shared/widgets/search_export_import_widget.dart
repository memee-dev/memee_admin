import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

import '../../../core/shared/app_strings.dart';
import 'app_button.dart';
import 'app_textfield.dart';

class SearchExportImportWidget extends StatelessWidget {
  const SearchExportImportWidget({
    super.key,
    required this.searchController,
    required this.searchLabel,
    this.onChanged,
    required this.onExportPressed,
    required this.onImportPressed,
  });

  final TextEditingController searchController;
  final String searchLabel;
  final Function(String)? onChanged;
  final Function() onExportPressed;
  final Function() onImportPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: AppTextField(
            controller: searchController,
            label: searchLabel,
            onChanged: onChanged,
          ),
        ).gapRight(24.w),
        Flexible(
          child: AppButton(
            label: AppStrings.import,
            onTap: onImportPressed,
          ),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: AppButton(
            label: AppStrings.export,
            onTap: onExportPressed,
          ),
        ),
      ],
    );
  }
}
