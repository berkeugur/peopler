import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PurchaseGetOfferEvent extends Equatable {}

class GetInitialOfferEvent extends PurchaseGetOfferEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}