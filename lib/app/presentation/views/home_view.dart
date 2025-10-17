import 'package:blockchain/app/domain/entities/coin.dart';
import 'package:blockchain/app/presentation/controllers/home_controller.dart';
import 'package:blockchain/app/presentation/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blockchain/app/main_widget.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController kontroller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 82, 107),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(SearchView());
            },
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 30, 82, 107),
      body: Obx(() {
        return ListView.builder(
          itemCount: kontroller.koin.length,
          itemBuilder: (context, index) {
            final Coin koinData = kontroller.koin[index];
            return Card(
              color: Colors.white12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListTile(
                leading: Image.network(koinData.image),
                title: W.text(
                  data: koinData.symbol,
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: W.text(
                  data: koinData.name,
                  fontSize: 16,
                  color: Colors.white,
                ),
                trailing: W.text(
                  data: koinData.currentPrice,
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
