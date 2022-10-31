import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/in_app_purchases.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class PurchaseMakePurchaseBloc extends Bloc<PurchaseMakePurchaseEvent, PurchaseMakePurchaseState> {
  final PurchaseApi _purchaseApi = locator<PurchaseApi>();
  
  PurchaseMakePurchaseBloc() : super(InitialPurchaseMakePurchaseState()) {
    on<MakePurchaseEvent>((event, emit) async {
      if(event.package == null) {
        emit(PurchaseMakePurchaseNotFoundState());
        return;
      }
      
      try {
        await _purchaseApi.makePurchases(event.package!);
        emit(PurchaseMakePurchaseLoadedState());
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
          debugPrint("Purchase was cancelled.");
        } else if(errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
          debugPrint("This product is already active for the user.");
        } else {
          debugPrint(e.message);
        }

        emit(PurchaseMakePurchaseNotFoundState());
      } 
    });
  }
}
