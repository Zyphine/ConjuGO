import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conjugo/search_widget.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class UserParticipantsPage extends StatefulWidget {
  final String documentId;
  const UserParticipantsPage({super.key, required this.documentId});

  @override
  UserParticipantsHome createState() => UserParticipantsHome();
}

class Personne {
  String? nom = "";
  String? prenom = "";
  bool? admin = false;
  String? dateDeNaissance = "";
  bool? superAdmin = false;
  String? mail = "";
  String? userId = "";
  String? phone = "";

  Personne({
    this.nom,
    this.prenom,
    this.admin,
    this.dateDeNaissance,
    this.superAdmin,
    this.mail,
    this.userId,
    this.phone,
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
      userId: data?['userId'],
      phone: data?['phone'],
    );
  }

  String getNom() => nom.toString();
  String getPrenom() => prenom.toString();
  String getAdmin() => admin.toString();
  String getDateDeNaissance() => dateDeNaissance.toString();
  String getSuperAdmin() => superAdmin.toString();
  String getMail() => mail.toString();
  String getUserId() => userId.toString();
  String getPhone() => phone.toString();
}

class UserParticipantsHome extends State<UserParticipantsPage> {
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
          title: const Text("Ajouter des Utilisateurs"),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter des Utilisateurs"),
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
                  //isParticipating(personne.getUserId(), widget.documentId, userParticipationStatus);
                  return GestureDetector(
                    onTap: () {
                      addParticipant(context, personne.getUserId());
                    },
                    child: Card(
                      child: ListTile(
                        title: Text("${personne.getNom()} ${personne.getPrenom()}"),
                        subtitle: Text("${personne.getMail()} \n ${personne.getPhone()}"),
                        leading: const Icon(Icons.account_circle),
                      ),
                    )
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

  void addParticipant(BuildContext context, String participantId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection("ACTIVITYDATA").doc(widget.documentId).get();
    List listParticipants = snapshot.data()?['participants'];
    if (listParticipants.contains(participantId)) {
      if (context.mounted) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Erreur"),
            content: const Text("L'utilisateur est déjà inscrit pour cette activité"),
            actions: <Widget>[
              TextButton(
                onPressed: () => {Navigator.pop(context)},
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      int nb = snapshot.data()?['numberOfRemainingEntries'];
      if (context.mounted) {
        if (nb > 0) {
          listParticipants.add(participantId);
          db.collection("ACTIVITYDATA").doc(widget.documentId).update({'participants': listParticipants});
          db.collection("ACTIVITYDATA").doc(widget.documentId).update({'numberOfRemainingEntries': FieldValue.increment(-1)});
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Confirmation d'inscription"),
              content: const Text("L'utilisateur à été incrit à cette activité"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: const Text('OK'),
                ),
              ],
            ),
          ).then((value) => Navigator.pop(context));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Il ne reste plus de place disponible pour cette activité'),
          duration: Duration(seconds: 5),
          ));
        }
      }
    }
  }
}