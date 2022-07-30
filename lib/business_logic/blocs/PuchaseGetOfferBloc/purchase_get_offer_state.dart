import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';


abstract class PurchaseGetOfferState extends Equatable {
  const PurchaseGetOfferState();
}

class InitialPurchaseGetOfferState extends PurchaseGetOfferState {
  @override
  List<Object> get props => [];
}

class PurchaseGetOfferNotFoundState extends PurchaseGetOfferState {
  @override
  List<Object> get props => [];
}

class PurchaseGetOfferLoadedState extends PurchaseGetOfferState {
  @override
  List<Object> get props => [];
}

