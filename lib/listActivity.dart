import 'package:conjugo/activityDescription.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:conjugo/DrawerMenu.dart';

//Création d'une instance de dialogue avec la bdd
FirebaseFirestore db = FirebaseFirestore.instance;

//Page liste des activités
class ListViewHomeLayout extends StatefulWidget {
  @override
  const ListViewHomeLayout({super.key});

  ListViewHome createState() => ListViewHome();
}

//Définition de la classe Activity -> on s'en sert pour récupérer les données, car on ne peut pas récupérer attribut par attribut, il faut tout prendre et séparer ensuite
class Activity {
  //Initialisation des vars
  String? name = "";
  String? description = "";
  Timestamp? date;
  String? place = "";
  int? numberOfRemainingEntries= 0;
  String? documentId = "";
  int? maxNumber = 0;

  //Constructeur
  Activity({
    this.name,
    this.description,
    this.date,
    this.place,
    this.numberOfRemainingEntries,
    this.documentId,
    this.maxNumber
  });

  //fonction de récupération des données
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
        place: data?['place'],
        numberOfRemainingEntries: data?['numberOfRemainingEntries'],
        documentId : data?['documentId'],
        maxNumber : data?['maxNumber']
      );
  }

  //Fonction qui vérifie que les éléments ne soient pas null
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (date != null) "date": date,
      if (place != null) "place": place,
      if (numberOfRemainingEntries!= null) "numberOfRemainingEntries": numberOfRemainingEntries,
      if (documentId!= null) "documentId": documentId,
      if (maxNumber!= null) "maxNumber": maxNumber
    };
  }

  //Getters
  String getName() {
    return name.toString();
  }

  String getDescription() {
    return description.toString();
  }

  String getDate() {
    String dateStr;
    DateTime? date2 = date?.toDate();
    if (date2 != null) {
      initializeDateFormatting();

      dateStr = DateFormat.yMMMMEEEEd('fr').format(date2) + ' à ' + DateFormat.Hm('fr').format(date2);
    } else {
      return date2.toString();
    }

    return dateStr[0].toUpperCase() + dateStr.substring(1);
  }

  String getplace() {
    return place.toString();
  }

  String getnumberOfRemainingEntries() {
    return numberOfRemainingEntries.toString();
  }

  String getDocumentId() {
    return documentId.toString();
  }

  String getMaxNumber() {
    return maxNumber.toString();
  }
}

class ListViewHome extends State<ListViewHomeLayout> {
  //Fonction démarrant la recherche des données
  Future<void> dataFinder(List<Activity> activityList) async {
    await db.collection("ACTIVITYDATA").get().then((querySnapshot) async {
      //Pour chaque éléments de la base, on récupére les attributs
      for (var docSnapshot in querySnapshot.docs) {
        final ref =
            db.collection("ACTIVITYDATA").doc(docSnapshot.id).withConverter(
                  fromFirestore: Activity.fromFirestore,
                  toFirestore: (Activity activity, _) => activity.toFirestore(),
                );
        final docSnap = await ref.get();
        final activity = docSnap.data();

        if (activity != null) {
          //On met de cotés les éléments de la base (des objets Activity) dans une liste
          activityList.add(activity);
        } else {
          print("Base vide");
        }
      }
    });
  }

  //Initialisation de la liste d'activités
  List<Activity> activityList = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    final spacer = SizedBox(height: 10);
    return Scaffold(
        drawer: DrawerMenu(),
        appBar: AppBar(
          title: const Text('Liste des Activités'),
          centerTitle: true,

          //actions: <Widget>[

            

            //IconButton(
              //icon : const Icon(Icons.search),
              //onPressed: (){},
              //)
         // ],
        ),
        
        body: Center(
            child: Column(children: <Widget>[
              spacer,
              SearchBar(
                leading: Icon(Icons.search),
                hintText: 'Rechercher une activité',
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),

          //Le future builder permet de réaliser l'action en 'future' avant de build la page
          FutureBuilder(
              future: dataFinder(activityList),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //Initialisation des listes pour chaque attributs
                List<String> titles = List.empty(growable: true);
                List<String> subtitles = List.empty(growable: true);
                List<IconData> icons = List.empty(growable: true);
                List<String> date = List.empty(growable: true);
                List<String> place = List.empty(growable: true);
                List<int> slot = List.empty(growable: true);
                List<String> docIds = List.empty(growable: true);
                List<int> maxSlots = List.empty(growable: true);

                //Pour chaque éléments, on vient séparer les attributs et les ranger dans des listes
                for (int i = 0; i < activityList.length; i++) {
                  titles.add(activityList[i].getName());
                  subtitles.add(activityList[i].getDescription());
                  date.add(activityList[i].getDate());
                  place.add(activityList[i].getplace());
                  slot.add(int.parse(activityList[i].getnumberOfRemainingEntries()));
                  docIds.add(activityList[i].getDocumentId());
                  maxSlots.add(int.parse(activityList[i].getMaxNumber()));
                }
                //On vide la liste des activités
                if (activityList.isNotEmpty) {
                  activityList = List.empty(growable: true);
                }

                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: titles.length,
                    itemBuilder: (context, index) {
                      //Les activités sont en format carte
                      return Card(
                          child: ListTile(
                              onTap: () {
                                setState(() {
                                  titles.add('Activité' +
                                      (titles.length + 1).toString());
                                  subtitles.add('Description' +
                                      (titles.length + 1).toString());
                                  icons.add(Icons.zoom_out_sharp);
                                });
                                //Renvoie vers la page descrition de l'activité cliquée, avec en paramètres les attributs de cette dernière
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            DescriptionPage(
                                                name: titles[index],
                                                description: subtitles[index],
                                                date: date[index],
                                                place: place[index],
                                                numberOfRemainingEntries: slot[index],
                                                documentId : docIds[index],
                                                maxNumber : maxSlots[index])));
                              },
                              //Dans les cartes on affiche le name de l'activité en titre, sa description en sous titre, et par défaut le logo est celui de la CCAS (à changer)
                              title: Text(titles[index]),
                              subtitle: Text(subtitles[index]),
                              leading: const CircleAvatar(
                                  //IMAGE DE L'ASSOCIATION (propre à chacune, enregistrée dans une base association)
                                  backgroundImage: NetworkImage(
                                      "https://www.eseg-douai.fr/mub-225-170-f3f3f3/15171/partenaire/5cf93cdcc9d5c_LOGOVILLEVERTICAL.png")),
                              // "https://play-lh.googleusercontent.com/YxX2N976KtZhh16FR7dhQ_ItAcmZnpDxLvhddhuv8Q9M7jiKpf8YKDgwaLWF3XBA2f8=w240-h480-rw"
                            ));
                    });
              })
        ])));
  }
}
