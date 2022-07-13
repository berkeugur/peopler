import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/data/in_app_purchases.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class PurchaseGetOfferBloc extends Bloc<PurchaseGetOfferEvent, PurchaseGetOfferState> {
  final PurchaseApi _purchaseApi = locator<PurchaseApi>();

  PurchaseGetOfferBloc() : super(InitialPurchaseGetOfferState()) {
    on<GetInitialOfferEvent>((event, emit) async {
      try {
        Offering? currentOffering = await _purchaseApi.fetchCurrentOffer();
        debugPrint(currentOffering?.toJson().toString());
        emit(PurchaseGetOfferLoadedState(currentOffering));
      } catch (e) {
        emit(PurchaseGetOfferNotFoundState());
        debugPrint("purchase get offer not found" + e.toString());
      }
    });
  }
}
