import 'package:flutter/material.dart';
import 'package:conjugo/drawer_menu.dart';

//Page des services, à implémenter
class ListActivities extends StatelessWidget {
  const ListActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: const Text("Liste des services"),
        centerTitle: true,
      ),
      body: const Center(),
    );
  }
}
