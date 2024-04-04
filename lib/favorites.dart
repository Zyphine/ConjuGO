import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conjugo/activity_description.dart';
import 'package:conjugo/authentication_service.dart';
import 'package:conjugo/list_activity.dart';
import 'package:flutter/material.dart';
import 'package:conjugo/drawer_menu.dart';

AuthenticationService auth = AuthenticationService();

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<StatefulWidget> createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {

  Future<List<Activity>> dataFinder() async { //pas fini, a modifier pour les favoris, il faut delete les fav qui n'existent plus
    List<Activity> activityListResult = [];
    List<dynamic> arrayActivitiesId = await searchUserForFavorites();

    final querySnapshot = await db.collection("ACTIVITYDATA").get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (doc.data() != null) {
        String docId = data["documentId"];
        if (arrayActivitiesId.contains(docId)) {
          activityListResult.add(Activity.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>, null));
        } else {
          removeFromFavorite(docId);
        }
      }
    }

    return activityListResult;
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

  List<Activity> activityList = [];
  List<Activity> filteredList = [];
  String query = '';

  @override
  Widget build(BuildContext context) {
    if (activityList.isEmpty) {
      return Scaffold(
        drawer: DrawerMenu(),
        appBar: AppBar(
          title: const Text("Favoris"),
          centerTitle: true,
        ),
        body: Card(
          child: ListTile(
            onTap: () {},
            title: const Text("Aucun favoris"),
            subtitle: const Text("Essayer d'appuyer sur le coeur sur une page d'activité"),
            leading: const Icon(Icons.close_outlined),
          ),
        ),
      );
    } else {
      return Scaffold(
        drawer: DrawerMenu(),
        appBar: AppBar(
          title: const Text("Favoris"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
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
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(activity.getPictureURL())
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

  Future<List<dynamic>> searchUserForFavorites() async {
    
    String userUid = auth.getUser();

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("USERDATA").doc(userUid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> result = data["favorites"];
    
    return result;
  }

  Future<void> removeFromFavorite(String docId) async {
    String userUid = auth.getUser();
    final userDoc = FirebaseFirestore.instance.collection("USERDATA").doc(userUid);
      userDoc.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          List tableFavorites = data["favorites"]; 
          tableFavorites.remove(docId);
          userDoc.update({"favorites": tableFavorites});
        }
      );
  }
}
