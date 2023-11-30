import 'package:flutter/material.dart';
import 'package:conjugo/DrawerMenu.dart';

//Page Carte, à implémenter
class ActivityMap extends StatelessWidget {
  const ActivityMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: const Text("Carte"),
        centerTitle: true,
      ),
      body: Center(),
    );
  }
}
