import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conjugo/activity_participants.dart';
import 'package:conjugo/connection_page.dart';
import 'package:conjugo/list_activity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Page description des activités
class DescriptionPage extends StatelessWidget {
  String name;
  String description;
  String date;
  String place;
  int numberOfRemainingEntries;
  String documentId;
  int maxNumber;

  DescriptionPage(
      {super.key,
      //Définitions des éléments requis
      required this.name,
      required this.description,
      required this.date,
      required this.place,
      required this.numberOfRemainingEntries,
      required this.documentId,
      required this.maxNumber});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Description :\n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            description,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.black,
                      onPressed: () {
                        // Implement add to favorites logic here
                      },
                    ),
                  ),
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
                    'Date :\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(date),
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
                    'Lieu :\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(place.toString()),
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
                    'Places restantes :\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(numberOfRemainingEntries.toString()),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            FutureBuilder<bool>(
              future: isParticipating(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(); // renvoi un container vide pendant l'attente
                } else if (snapshot.hasError) {
                  return Container(); // renvoi un container vide en cas d'erreur
                } else {
                  bool isParticipating = snapshot.data ?? false;

                  // N'afficher le boutton s'inscrire que si l'utilisateur n'est pas inscrit
                  return isParticipating? ElevatedButton(
                      onPressed: () => unRegisterParticipant(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                        minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Désinscription '),
                          Icon(Icons.highlight_off),
                        ],
                      ),
                    )
                  : ElevatedButton(
                    onPressed: () => registerParticipant(context),
                    style: ButtonStyle(
                      maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                      minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Pré-inscription '),
                        Icon(Icons.how_to_reg),
                      ],
                    ),
                  ); //renvoi un bouton de desincrtiption si l'utilisateur est deja inscrit
                }
              },
            ),
            FutureBuilder<bool>(
              future: auth.isUserAdmin(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(); // renvoi un container vide pendant l'attente
                } else if (snapshot.hasError) {
                  return Container(); // renvoi un container vide en cas d'erreur
                } else {
                  bool isAdmin = snapshot.data ?? false;

                  // N'afficher le boutton supprimer que si l'utilisateur est admin
                  return isAdmin? ElevatedButton(
                    onPressed: () => toParticipantsList(context),
                    style: ButtonStyle(
                      maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                      minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Voir les participants '),
                        Icon(Icons.people_alt),
                      ],
                    )
                  )
                  : Container(); //renvoi un container vide si l'utilisateur n'est pas administrateur
                }
              },
            ),
            FutureBuilder<bool>(
              future: auth.isUserAdmin(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(); // renvoi un container vide pendant l'attente
                } else if (snapshot.hasError) {
                  return Container(); // renvoi un container vide en cas d'erreur
                } else {
                  bool isAdmin = snapshot.data ?? false;

                  // N'afficher le boutton supprimer que si l'utilisateur est admin
                  return isAdmin? ElevatedButton(
                    onPressed: () => deletePublication(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                      minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Supprimer la publication '),
                        Icon(Icons.delete),
                      ],
                    )
                  )
                  : Container(); //renvoi un container vide si l'utilisateur n'est pas administrateur
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> unRegisterParticipant(BuildContext context) async {
    bool result = await isParticipating();

    if(result) {
      final publication = FirebaseFirestore.instance.collection("ACTIVITYDATA").doc(documentId);
      publication.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          List tableParticipants = data["participants"]; //on récupère la liste des participants
          tableParticipants.remove(FirebaseAuth.instance.currentUser?.uid); //on supprime l'utilisateur actuellement connecté
          publication.update({"participants": tableParticipants}); //on met à jour le document
          publication.update({"numberOfRemainingEntries": numberOfRemainingEntries + 1}).then( //on enlève une place
            (value) => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Désinscription réussie"),
                content: const Text("Vous êtes désinscrit avec succès \npensez à prévenir l'organisateur si besoin"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListViewHomeLayout()),
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

  Future<void> registerParticipant(BuildContext context) async {
    bool result = await isParticipating();

    if(!result) {
      final publication = FirebaseFirestore.instance.collection("ACTIVITYDATA").doc(documentId);
      publication.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          List tableParticipants = data["participants"]; //on récupère la liste des participants
          tableParticipants.add(FirebaseAuth.instance.currentUser?.uid); //on ajoute l'utilisateur actuellement connecté
          publication.update({"participants": tableParticipants}); //on met à jour le document
          publication.update({"numberOfRemainingEntries": numberOfRemainingEntries-1}).then( //on enlève une place
            (value) => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Pré-inscription réussie"),
                content: const Text("Vous êtes pré-inscrit avec succès \npensez à vous inscrire auprès de l'organisateur"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListViewHomeLayout()),
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

  Future<void> toParticipantsList(BuildContext context) async {
    final publication = FirebaseFirestore.instance.collection("ACTIVITYDATA").doc(documentId);
    publication.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        List tableParticipants = data["participants"]; //on récupère la liste des participants
        Navigator.push(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => ActivityParticipantsPage(participants : tableParticipants, documentId : documentId)
          )
        );
      }
    );
  }

  Future<void> deletePublication(BuildContext context) async {

    final publication = FirebaseFirestore.instance.collection("ACTIVITYDATA").doc(documentId);

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Attention"),
        content: const Text("Vous êtes sur le point de supprimer cette publication"),
        actions: <Widget>[
          TextButton(
            onPressed: () => {
              publication.delete().then((value) => {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Confirmation de suppression"),
                    content: const Text("La publication a été supprimée avec succès"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => {Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ListViewHomeLayout()),
                          )},
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                )
              })
            },
            child: const Text('Confirmer'),
          ),
          TextButton(onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Annuler"))
        ],
      ),
    );
  }

  Future<bool> isParticipating() async {
    String userId;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    } else {
      return false;
    }

    final publication = FirebaseFirestore.instance.collection("ACTIVITYDATA").doc(documentId);
    final DocumentSnapshot doc = await publication.get();
    final data = doc.data() as Map<String, dynamic>;
    List<dynamic> tableParticipants = data["participants"] ?? [];

    return tableParticipants.contains(userId);
  }

}
