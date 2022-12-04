import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@immutable
abstract class PurchaseMakePurchaseEvent extends Equatable {}

class MakePurchaseEvent extends PurchaseMakePurchaseEvent {
  final Package? package;
  MakePurchaseEvent({
    required this.package,
  });

  @override
  List<Object?> get props => [package];
}

class ResetMakePurchaseEvent extends PurchaseMakePurchaseEvent {
  @override
  List<Object> get props => [];
}
