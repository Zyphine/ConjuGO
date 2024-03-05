import 'package:conjugo/activity_description.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:conjugo/drawer_menu.dart';
import 'package:conjugo/search_widget.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class ListViewHomeLayout extends StatefulWidget {
  const ListViewHomeLayout({super.key});

  @override
  ListViewHome createState() => ListViewHome();
}

class Activity {
  String? name = "";
  String? description= "";
  Timestamp? date;
  Timestamp? limitDate;
  String? place = "";
  int? numberOfRemainingEntries = 0;
  String? documentId = "";
  int? maxNumber = 0;
  String? type="";

  Activity({
    this.name,
    this.description,
    this.date,
    this.limitDate,
    this.place,
    this.numberOfRemainingEntries,
    this.documentId,
    this.maxNumber,
    this.type,
  });

  factory Activity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Activity(
        //les str entre crochets sont les names des attributs que l'on souhaite sélectionner
        name: data?['name'],
        description: data?['description'],
        date: data?['date'],
        limitDate: data?['limitDate'],
        place: data?['place'],
        numberOfRemainingEntries: data?['numberOfRemainingEntries'],
        documentId : data?['documentId'],
        maxNumber : data?['maxNumber'],
        type : data?['type'],
      );
  }

  String getName() => name.toString();
  String getDescription() => description.toString();
  String getDate() {
    String dateStr;
    DateTime? date2 = date?.toDate();
    if (date2 != null) {
      initializeDateFormatting();

      dateStr = '${DateFormat.yMMMMEEEEd('fr').format(date2)} à ${DateFormat.Hm('fr').format(date2)}';
    } else {
      return date2.toString();
    }

    return dateStr[0].toUpperCase() + dateStr.substring(1);
  }
  Timestamp? getLimitDate() => limitDate;
  String getPlace() => place.toString();
  String getNumberOfRemainingEntries() => numberOfRemainingEntries.toString();
  String getDocumentId() => documentId.toString();
  String getMaxNumber() => maxNumber.toString();
  String getType() => type.toString();
}

class ListViewHome extends State<ListViewHomeLayout> {
  Future<List<Activity>> dataFinder() async {
    final querySnapshot = await db.collection("ACTIVITYDATA").get();
    return querySnapshot.docs.map((doc) => Activity.fromFirestore(doc, null)).toList();
  }

  List<Activity> activityList = [];
  List<Activity> filteredList = [];
  String query = '';

  @override
  Widget build(BuildContext context) {
    if (activityList.isEmpty) {
      return Scaffold(
        drawer: DrawerMenu(),
        appBar: AppBar(
          title: const Text("Liste des Activités"),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        drawer: DrawerMenu(),
        appBar: AppBar(
          title: const Text("Liste des Activités"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final activity = filteredList[index];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DescriptionPage(
                              name: activity.getName(),
                              description: activity.getDescription(),
                              date: activity.getDate(),
                              limitDate: activity.getLimitDate(),
                              place: activity.getPlace(),
                              numberOfRemainingEntries: int.parse(activity.getNumberOfRemainingEntries()),
                              documentId: activity.getDocumentId(),
                              maxNumber: int.parse(activity.getMaxNumber()),
                              type : activity.getType(),
                            ),
                          ),
                        );
                      },
                      title: Text(activity.getName()),
                      subtitle: Text(activity.getDescription()),
                      leading: const CircleAvatar(
                                  //IMAGE DE L'ASSOCIATION (propre à chacune, enregistrée dans une base association)
                                  backgroundImage: NetworkImage(
                                      "https://www.eseg-douai.fr/mub-225-170-f3f3f3/15171/partenaire/5cf93cdcc9d5c_LOGOVILLEVERTICAL.png"
                                    )
                              ),
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
        hintText: 'Rechercher une activité',
        onChanged: searchActivity,
      );

  void searchActivity(String query) {
    final searchLower = query.toLowerCase();
    setState(() {
      this.query = query;
      filteredList = activityList.where((activity) =>
          activity.name!.toLowerCase().contains(searchLower) ||
          activity.description!.toLowerCase().contains(searchLower)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    dataFinder().then((list) {
      setState(() {
        activityList = list;
        filteredList = list;
      });
    });
  }
}