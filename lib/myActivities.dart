import 'package:flutter/material.dart';
import 'package:conjugo/DrawerMenu.dart';

//Page mes activités, à implémenter
class MyActivities extends StatelessWidget {
  const MyActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: const Text("Mes activités"),
        centerTitle: true,
      ),
      body: Center(),
    );
  }
}
