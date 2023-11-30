import 'package:flutter/material.dart';
import 'package:conjugo/DrawerMenu.dart';

//Page à propos
class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: const Text("A propos"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
            "Application réalisée par : \n\n\n\n\n Jean-Guy Wintrebert \n\n Clément D'Elbreil \n\n Tristan Chauveau \n\n Matthias Ellero \n\n Etienne Dam Hieu \n\n\n FISE 2025 \n\n\n\n\n sous le tutorat de \n\n Mr Anthony Fleury, IMT Nord Europe \n\n Mme Anne Gogulski, CCAS Douai",
            textAlign: TextAlign.center),
      ),
    );
  }
}
