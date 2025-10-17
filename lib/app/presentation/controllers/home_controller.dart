

import 'package:blockchain/app/domain/entities/coin.dart';
import 'package:blockchain/app/domain/usecase/get_market_coins_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blockchain/app/injection.dart';

class HomeController extends GetxController {
  GetMarketCoinsUsecase homeUse = sl<GetMarketCoinsUsecase>();

  RxList<Coin> koin = <Coin>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getKoin();
    });
  }

  void getKoin() async {
    koin.value = await homeUse.call();
  }
}
