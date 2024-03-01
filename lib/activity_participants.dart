import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityParticipantsPage extends StatefulWidget {
  final List<dynamic> participants;
  final String documentId;
  const ActivityParticipantsPage({super.key, required this.participants, required this.documentId});

  @override
  ActivityParticipantsPageState createState() => ActivityParticipantsPageState();

  List<dynamic> getParticipants() {
    return participants;
  }
}

class ActivityParticipantsPageState extends State<ActivityParticipantsPage> {

  List<Map<String, dynamic>> userCredentials = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    fetchParticipants();
  }
  
  Future<void> fetchParticipants() async {
    if(widget.participants.isEmpty) {
      setState(() {userCredentials = [];});
      return;
    }
    List<Map<String, dynamic>> result = [];
    var database = FirebaseFirestore.instance;
    var userCollection = database.collection("USERDATA");
    for (int i = 0; i < widget.participants.length; i++) {
      DocumentSnapshot doc = await userCollection.doc(widget.participants[i]).get();
      final data = doc.data() as Map<String, dynamic>;
      result.add(data);
    }
    setState(() {userCredentials = result;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des participants : '),
      ),
      body: ListView.builder(
        itemCount: userCredentials.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text((userCredentials[index]['prenom'] ?? '') + ' ' + (userCredentials[index]['nom'] ?? '')),
            subtitle: Text(userCredentials[index]['mail'] ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteParticipants(index),
            ),
          );
        },
      ),
    );
  }

  Future<void> deleteParticipants(int index) async {
    String userId = widget.participants[index];
    var publicationCollection = FirebaseFirestore.instance.collection("ACTIVITYDATA");
    final publication = publicationCollection.doc(widget.documentId);

    publication.get().then( (DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      List tableParticipants = data["participants"]; //on récupère la liste des participants
      tableParticipants.remove(userId); // on supprime l'utilisateur selectionné
      publication.update({"participants": tableParticipants}); //on met à jour le document

      int remainingEntries = data["numberOfRemainingEntries"]; // on récupère le nombre de places restantes
      publication.update({"numberOfRemainingEntries": remainingEntries + 1}); // on rajoute la place que l'utilisateur prenait

      widget.participants.remove(userId); // on le retire également de la liste que associée à la page
      fetchParticipants(); // on actualise la page
    });
  }
}