import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iiko_delivery/feature/presentation/bloc/daily_salary_cubit/daily_salary_cubit.dart';
import 'package:iiko_delivery/feature/presentation/bloc/orders_cost_cubit/orders_cost_cubit.dart';
import 'package:intl/intl.dart';
import 'package:iiko_delivery/feature/presentation/bloc/order_cubit/order_cubit.dart';
import 'package:iiko_delivery/feature/presentation/bloc/order_cubit/order_state.dart';
import 'package:iiko_delivery/feature/presentation/widgets/order_list_item.dart';
import 'package:iiko_delivery/feature/presentation/widgets/segment_order.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? groupValue = 0;
  late bool isDelivered = false;
  @override
  Widget build(BuildContext context) {
    context.read<OrderCubit>().getUserOrders(isDelivered);
    context.read<DailySalaryCubit>().getDailySalary();
    context.read<OrdersCostCubit>().getOrdersCost(isDelivered);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          DateFormat.yMMMEd().format(DateTime.now()),
          style: const TextStyle(
            color: Color(0xFF191817),
            fontSize: 20,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.exit_to_app_outlined)),
        backgroundColor: const Color(0xFFFAF7F5),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        color: const Color(0xFFFAF7F5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F5),
                shape: BoxShape.rectangle,
                border: Border.all(color: const Color(0xFFC9C1B9)),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox.square(
                      dimension: 10,
                    ),
                    Image.asset('assets/Wallet.png'),
                    const SizedBox.square(
                      dimension: 10,
                    ),
                    BlocBuilder<DailySalaryCubit, DailySalaryState>(
                      builder: (context, state) {
                        if (state is DailySalarySuccess) {
                          return Text(state.salary.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ));
                        } else if (state is DailySalaryFailure) {
                          return Center(
                            child: Text(state.message),
                          );
                        } else {
                          return const Center(
                            child: Text('Loading...',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                )),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox.square(
              dimension: 30,
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CupertinoSlidingSegmentedControl<int>(
                      groupValue: groupValue,
                      thumbColor: const Color(0xFF78C4A4),
                      backgroundColor: Colors.white,
                      children: {
                        0: buildSegment('Будущие'),
                        1: buildSegment('Доставленные')
                      },
                      onValueChanged: (groupValue) {
                        setState(() => this.groupValue = groupValue);
                        isDelivered = !isDelivered;
                      })
                ],
              ),
            ),
            const SizedBox.square(
              dimension: 15,
            ),
            const Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Заказы",
                  style: TextStyle(
                    color: Color(0xFF191817),
                    fontSize: 26,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  if (state is GetUserOrdersSuccessState) {
                    return ListView.builder(
                        itemCount: state.orders.length,
                        itemBuilder: (ctx, index) =>
                            OrderListItem(orderModel: state.orders[index]));
                  } else if (state is GetUserOrdersFailState) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                },
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
