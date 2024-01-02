import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/orders/orders_cubit.dart';
import 'package:memee_admin/blocs/payments/payments_cubit.dart';
import 'package:memee_admin/blocs/toggle/toggle_cubit.dart';
import 'package:memee_admin/models/order_model.dart';
import 'package:memee_admin/ui/__shared/extensions/date_time_extension.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

import '../../../../../core/initializer/app_di_registration.dart';
import '../../../../../core/shared/app_strings.dart';
import '../../../../__shared/widgets/app_box.dart';

class OrdersDetailedWidget extends StatelessWidget {
  final OrderModel order;

  const OrdersDetailedWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.orders,
          style: Theme.of(context).textTheme.displaySmall,
        ).gapBottom(16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FirstColumn(
                order: order,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: SecondColumn(
                items: order.orderDetails,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SecondColumn extends StatelessWidget {
  final List<ItemModel> items;

  const SecondColumn({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final refreshCubit = locator.get<RefreshCubit>();
    int selectedIndex = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.items,
          style: Theme.of(context).textTheme.displaySmall,
        ).gapBottom(6.h),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Wrap(
            children: items.map((item) {
              final index = items.indexOf(item);
              return BlocBuilder<RefreshCubit, bool>(
                bloc: refreshCubit,
                builder: (context, state) {
                  return AppBox(
                    bgColor: selectedIndex == index
                        ? Colors.green
                        : Colors.transparent,
                    onTap: () {
                      selectedIndex = index;
                      refreshCubit.change();
                    },
                    child: Text('${item.productId} / ${item.name}'),
                  );
                },
              ).gapBottom(8.h);
            }).toList(),
          ),
        ),
        Divider(thickness: 0.1.sp),
        BlocBuilder<RefreshCubit, bool>(
          bloc: refreshCubit,
          builder: (context, state) {
            if (items.isNotEmpty) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 50.w,
                        height: 100.h,
                        child: Image.network(
                          items[selectedIndex].image,
                          scale: 1.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppBox(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.h,
                          horizontal: 4.w,
                        ),
                        text: '${AppStrings.product} ${AppStrings.id}',
                        radius: 2.r,
                        child: Text(
                          items[selectedIndex].productId,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AppBox(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.h,
                          horizontal: 4.w,
                        ),
                        text: '${AppStrings.product} ${AppStrings.name}',
                        radius: 2.r,
                        child: Text(
                          items[selectedIndex].name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: items[selectedIndex]
                        .selectedItemDelails
                        .map((selectedItem) {
                      return BlocBuilder<RefreshCubit, bool>(
                        bloc: refreshCubit,
                        builder: (_, state) {
                          return AppBox(
                            child: Text(
                                '${selectedItem.productDetails} * ${selectedItem.units}'),
                          );
                        },
                      ).gapBottom(8.h);
                    }).toList(),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }
}

class FirstColumn extends StatelessWidget {
  final OrderModel? order;
  const FirstColumn({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final _ordersCubit = locator.get<OrdersCubit>();
    final _paymentCubit = locator.get<PaymentsCubit>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBox(
                text: AppStrings.id,
                child: Text(
                  order?.id ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ).gapBottom(4.h),
              AppBox(
                text: '${AppStrings.payment} ${AppStrings.id}',
                child: Text(
                  order?.paymentId ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ).gapBottom(4.h),
              AppBox(
                text: '${AppStrings.user} ${AppStrings.id}',
                child: Text(
                  order?.userId ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ).gapBottom(4.h),
              AppBox(
                text: '${AppStrings.created} ${AppStrings.time}',
                child: Text(
                  order!.orderedTime.formatDateTime(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ).gapBottom(4.h),
              AppBox(
                text: '${AppStrings.updated} ${AppStrings.time}',
                child: Text(
                  order!.updatedTime.formatDateTime(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBox(
                text: '${AppStrings.order} ${AppStrings.status}',
                bgColor:
                    _ordersCubit.getColorForOrderStatus(order?.orderStatus),
                child: Text(
                  order?.orderStatus ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                ),
              ).gapBottom(4.h),
              AppBox(
                text: '${AppStrings.payment} ${AppStrings.status}',
                bgColor: _paymentCubit
                    .getColorForPaymentStatus(order?.paymentStatus),
                child: Text(
                  order?.paymentStatus ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                ),
              ).gapBottom(4.h),
              AppBox(
                text: AppStrings.address,
                child: Text(
                  order?.address ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ).gapBottom(4.h),
              AppBox(
                text: '${AppStrings.total} ${AppStrings.amount}',
                child: Text(
                  order?.totalAmount ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              )
            ],
          ),
        ),
      ],
    ).flexible();
  }
}
