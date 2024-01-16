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
            "Application réalisée par : \n\n\n Jean-Guy Wintrebert \n Clément D'Elbreil \n Tristan Chauveau \n Matthias Ellero \n Etienne Dam Hieu \n Guillaume Foissy \n Baptiste Fournier \n Léo Chouippe \n Théo Tarrou \n Amélie Shan \n\n FISE 2025 et 2026 \n\n\n sous le tutorat de \n Mr Anthony Fleury, IMT Nord Europe \n Mme Anne Gogulski, CCAS Douai",
            textAlign: TextAlign.center),
      ),
    );
  }
}
