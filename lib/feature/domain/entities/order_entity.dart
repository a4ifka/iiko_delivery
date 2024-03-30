import 'dart:ffi';

import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable{
  final int id;
  final String orderNumber;
  final String address;
  final Decimal cost;
  final bool isDelivered;
  final String clientPhone;
  final String clientName;
  final DateTime orderDate;
  
  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.address,
    required this.cost,
    required this.isDelivered,
    required this.clientPhone,
    required this.clientName,
    required this.orderDate,
  });

  @override
  get props => [id, orderNumber, address, cost, isDelivered, clientPhone, clientName, orderDate];
}
