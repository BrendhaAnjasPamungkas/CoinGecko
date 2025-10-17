import 'package:blockchain/app/domain/entities/search.dart';
import 'package:blockchain/app/domain/usecase/get_market_coins_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:blockchain/app/injection.dart';

class Searchkontrol extends GetxController {
  GetMarketCoinsUsecase searchUse = sl<GetMarketCoinsUsecase>();

  TextEditingController textEditing = TextEditingController();

  RxList<Search> search = <Search>[].obs;
  void getSer() async {
    search.value = await searchUse.getSearch(textEditing.text);
  }
}
