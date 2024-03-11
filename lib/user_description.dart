import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conjugo/user_list.dart';
import 'package:conjugo/authentication_service.dart';

class UserDescriptionPage extends StatelessWidget {

  final AuthenticationService auth = AuthenticationService();
  final String nom;
  final String prenom;
  final String dateDeNaissance;
  final String mail;
  final bool admin;
  final bool superAdmin;
  final String userId;
  final String phone;

  UserDescriptionPage(
      {super.key,
      required this.nom,
      required this.prenom,
      required this.dateDeNaissance,
      required this.mail,
      required this.admin,
      required this.superAdmin, 
      required this.userId,
      required this.phone
      });

  bool isAdmin() {
    return admin;
  }

  bool isNormalUser() {
    return !admin;
  }

  Widget renderAdminButton(BuildContext context) {
    if (isNormalUser()) {
      return ElevatedButton(
        onPressed: () => putAdmin(context),
        style: ButtonStyle(
          maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
          minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Rendre Administrateur '),
            Icon(Icons.add_moderator),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget renderRemoveAdminButton(BuildContext context) {
    if (isAdmin()) {
      return ElevatedButton(
        onPressed: () => removeAdmin(context),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
           maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
           minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enlever Administrateur '),
            Icon(Icons.remove_moderator),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$nom $prenom"),
      ),
      body: Center(
        child: Column(
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
                    'Numéro de téléphone : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(phone),
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
                  Text(
                    admin ? 'Utilisateur Administrateur' : 'Utilisateur Normal',
                    style: TextStyle(
                      color: admin ? Colors.blue : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            FutureBuilder<bool>(
            future: auth.isUserSuperAdmin(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // renvoi un container vide pendant l'attente
              } else if (snapshot.hasError) {
                return Container(); // renvoi un container vide en cas d'erreur
              } else {
                bool isSuperAdmin = snapshot.data ?? false;

                // N'afficher les bouttons que si l'utilisateur est super admin
                return isSuperAdmin? Column(
                  children: [
                    const SizedBox(height: 32.0),
                    renderAdminButton(context),
                    const SizedBox(height: 32.0),
                    renderRemoveAdminButton(context),
                  ],
                ): Container(); //renvoi un container vide si l'utilisateur n'est pas super administrateur
              }
            },
          ),
          ],
        ),
      ),
    );
  }

  Future<void> putAdmin(BuildContext context) async {
    final personne = FirebaseFirestore.instance.collection("USERDATA").doc(userId);
    personne.get().then(
      (DocumentSnapshot doc) {
        personne.update({"admin": true}).then(
          (value) => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Effectué"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserListPage()),
                  )},
                  child: const Text('OK'),
                ),
              ],
            ),
          )
        );
      }
    );
  }

  Future<void> removeAdmin(BuildContext context) async {
    final personne = FirebaseFirestore.instance.collection("USERDATA").doc(userId);
    personne.get().then(
      (DocumentSnapshot doc) {
        personne.update({"admin": false}).then(
          (value) => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Effectué"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserListPage()),
                  )},
                  child: const Text('OK'),
                ),
              ],
            ),
          )
        );
      }
    );
  }
}
