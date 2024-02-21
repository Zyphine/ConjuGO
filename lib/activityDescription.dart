import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conjugo/listActivity.dart';
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description :',
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
                      icon: const Icon(Icons.favorite),
                      color: Colors.red,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Date :',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Places restantes :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(numberOfRemainingEntries.toString()),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () => registerParticipant(context),
              child: const Text('Pré-inscription'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerParticipant(BuildContext context) async {
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
