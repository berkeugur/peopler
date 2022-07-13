import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PurchaseMakePurchaseEvent extends Equatable {}

class MakePurchaseEvent extends PurchaseMakePurchaseEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}