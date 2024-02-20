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
  DescriptionPage(
      {super.key,
      //Définitions des éléments requis
      required this.name,
      required this.description,
      required this.date,
      required this.place,
      required this.numberOfRemainingEntries,
      required this.documentId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //Le titre de la page est le name de l'activité sur laquelle nous avons appuyée
          title: Text(name),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                //Image
                Container(
                  margin: const EdgeInsets.all(50),
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      //Image générique à remplacer : soit le logo de l'association, soit une photo de l'activité
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://assistance-sociale.fr/wp-content/uploads/2021/12/ccas-douai"),
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                    //Places restantes
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2)),
                    child: Column(
                      children: [
                        const Text(
                          'Places\nrestantes',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              decoration: TextDecoration.underline),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          numberOfRemainingEntries.toString(),
                          style: const TextStyle(color: Colors.blue, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ))
              ],
            ),
            Container(
              //Date
              width: 300,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quand :',
                      style: TextStyle(color: Colors.blue, fontSize: 30),
                      textAlign: TextAlign.left),
                  Text(date,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      textAlign: TextAlign.left),
                ],
              ),
            ),
            Container(
              //place
              width: 300,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Où :',
                      style: TextStyle(color: Colors.blue, fontSize: 30),
                      textAlign: TextAlign.left),
                  Text(place,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      textAlign: TextAlign.left),
                ],
              ),
            ),
            Container(
              //Description
              width: 300,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Description :',
                      style: TextStyle(color: Colors.blue, fontSize: 30),
                      textAlign: TextAlign.left),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Container(
                //Bouton inscription
                margin: const EdgeInsets.only(left: 100.0, top: 20.0),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 222, 205, 51)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: Colors.black)))),
                    onPressed: () => registerParticipant(context),
                    //Pour l'instant ne fait rien, à implémenter. Soit avec systèmes favoris, soit inscription avec décompte des places
                    child: Text("Je m'inscris".toUpperCase(),
                        style: const TextStyle(fontSize: 14))
                    ),
                ))
          ],
        ));
  }

  Future<void> registerParticipant(BuildContext context) async {
    print("inscription en cours");
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
