import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conjugo/search_widget.dart';
import 'package:conjugo/user_description.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  UserListHome createState() => UserListHome();
}

class Personne {
  String? nom = "";
  String? prenom = "";
  bool? admin = false;
  String? dateDeNaissance = "";
  bool? superAdmin = false;
  String? mail = "";

  Personne({
    this.nom,
    this.prenom,
    this.admin,
    this.dateDeNaissance,
    this.superAdmin,
    this.mail,
  });

  factory Personne.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Personne(
      nom: data?['nom'],
      prenom: data?['prenom'],
      admin: data?['admin'],
      dateDeNaissance: data?['dateDeNaissance'],
      superAdmin: data?['superAdmin'],
      mail: data?['mail'],
    );
  }

  String getNom() => nom.toString();
  String getPrenom() => prenom.toString();
  String getAdmin() => admin.toString();
  String getDateDeNaissance() => dateDeNaissance.toString();
  String getSuperAdmin() => superAdmin.toString();
  String getMail() => mail.toString();
}

class UserListHome extends State<UserListPage> {
  Future<List<Personne>> dataFinder() async {
    final querySnapshot = await db.collection("USERDATA").get();
    return querySnapshot.docs.map((doc) => Personne.fromFirestore(doc, null)).toList();
  }

  List<Personne> personneList = [];
  List<Personne> filteredList = [];
  String query = '';

  @override
  Widget build(BuildContext context) {
    if (personneList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Liste des Utilisateurs"),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Liste des Utilisateurs"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final personne = filteredList[index];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserDescriptionPage(
                              nom: personne.getNom(),
                              prenom: personne.getPrenom(),
                              dateDeNaissance: personne.getDateDeNaissance(),
                              mail: personne.getMail(),
                              admin: bool.parse(personne.getAdmin()),
                              superAdmin: bool.parse(personne.getSuperAdmin()),
                            ),
                          ),
                        );
                      },
                      title: Text("${personne.getNom()} ${personne.getPrenom()}"),
                      subtitle: Text(personne.getMail()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Rechercher un utilisateur',
        onChanged: searchActivity,
      );

  void searchActivity(String query) {
    final searchLower = query.toLowerCase();
    setState(() {
      this.query = query;
      filteredList = personneList.where((personne) =>
          personne.nom!.toLowerCase().contains(searchLower) ||
          personne.prenom!.toLowerCase().contains(searchLower)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    dataFinder().then((list) {
      setState(() {
        personneList = list;
        filteredList = list;
      });
    });
  }
}