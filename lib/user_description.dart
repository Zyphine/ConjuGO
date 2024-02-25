import 'package:flutter/material.dart';

//Page description des activités
class UserDescriptionPage extends StatelessWidget {
  String nom;
  String prenom;
  String dateDeNaissance;
  String mail;
  bool admin;
  bool superAdmin;

  UserDescriptionPage(
      {super.key,
      //Définitions des éléments requis
      required this.nom,
      required this.prenom,
      required this.dateDeNaissance,
      required this.mail,
      required this.admin,
      required this.superAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nom + " " + prenom),
      ),
      body: Center(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Adresse mail : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(mail),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Date de naissance : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(dateDeNaissance),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Statut : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(admin.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
