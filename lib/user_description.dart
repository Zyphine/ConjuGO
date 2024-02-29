import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conjugo/user_list.dart';



//Page description des activités
class UserDescriptionPage extends StatelessWidget {
  String nom;
  String prenom;
  String dateDeNaissance;
  String mail;
  bool admin;
  bool superAdmin;
  String userId;

  UserDescriptionPage(
      {super.key,
      //Définitions des éléments requis
      required this.nom,
      required this.prenom,
      required this.dateDeNaissance,
      required this.mail,
      required this.admin,
      required this.superAdmin, 
      required this.userId
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$nom $prenom"),
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
                  Text(
                    admin ? 'Utilisateur Administrateur' : 'Utilisateur Normal',
                    style: TextStyle(
                      color: admin ? Colors.blue : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
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
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
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
        //final data = doc.data() as Map<String, dynamic>;
        personne.update({"admin": true}).then( //on met à jour le document
        //publication.update({"numberOfRemainingEntries": numberOfRemainingEntries-1}).then( //on enlève une place
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
        //final data = doc.data() as Map<String, dynamic>;
        personne.update({"admin": false}).then( //on met à jour le document
        //publication.update({"numberOfRemainingEntries": numberOfRemainingEntries-1}).then( //on enlève une place
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
