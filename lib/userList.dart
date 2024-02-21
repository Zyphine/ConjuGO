import 'package:flutter/material.dart';
import 'package:conjugo/DrawerMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

FirebaseFirestore db = FirebaseFirestore.instance;

class UserListPage extends StatefulWidget {
  @override
  const UserListPage({super.key});

  UserListHome createState() => UserListHome();
}

class Personne{
  String? nom = "";
  String? prenom = "";
  bool? admin = false;

  Personne({
    this.nom,
    this.prenom,
    this.admin,
  });

  factory Personne.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
      final data = snapshot.data();

      return Personne(
          //les str entre crochets sont les noms des attributs que l'on souhaite sélectionner
          nom: data?['nom'],
          prenom: data?['prenom'],
          admin: data?['admin']);
        
    }
}

class UserListHome extends State<UserListPage>{
  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 10,);
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: const Text("Liste des Utilisateurs"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(children: <Widget>[
              spacer,
              SearchBar(
                leading: const Icon(Icons.search),
                hintText: 'Rechercher un utilisateur',
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
        ]
      ),
      )
    );
  }
}
