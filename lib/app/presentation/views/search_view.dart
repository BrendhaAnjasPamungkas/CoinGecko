import 'package:blockchain/app/domain/entities/search.dart';
import 'package:blockchain/app/main_widget.dart';
import 'package:blockchain/app/presentation/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});
  final kontrl = Get.put(Searchkontrol());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: TextField(controller: kontrl.textEditing),
        actions: [
          IconButton(
            onPressed: kontrl.getSer,
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: kontrl.search.length,
          itemBuilder: (context, index) {
            final Search serc = kontrl.search[index];
            return Card(
              color: const Color.fromARGB(255, 4, 76, 121),
              child: ListTile(
                leading: Image.network(serc.thumb, scale: 0.7),
                title: W.text(
                  data: serc.symbol,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 17,
                ),
                subtitle: W.text(data: serc.name, color: Colors.white),
                trailing: W.text(data: serc.apiSymbol, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
