import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityParticipantsPage extends StatefulWidget {
  List<dynamic> participants;
  ActivityParticipantsPage({super.key, required this.participants});

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
    print(widget.participants);
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
            title: Text((userCredentials[index]['prenom'] ?? '') + ' ' + (userCredentials[index]['nom'])),
            subtitle: Text(userCredentials[index]['mail'] ?? ''),
          );
        },
      ),
    );
  }
}