import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conjugo/activity_description.dart';
import 'package:conjugo/authentication_service.dart';
import 'package:conjugo/list_activity.dart';
import 'package:flutter/material.dart';
import 'package:conjugo/drawer_menu.dart';

AuthenticationService auth = AuthenticationService();

class MyActivities extends StatefulWidget {
  const MyActivities({super.key});

  @override
  State<StatefulWidget> createState() => MyActivitiesState();
}

class MyActivitiesState extends State<MyActivities> {

  Future<List<Activity>> dataFinder() async {
    List<Activity> activityListResult = [];
    List<String> arrayActivitiesId = await searchActivityForUser();
    final querySnapshot = await db.collection("ACTIVITYDATA").get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (doc.data() != null) {
        String docId = data["documentId"];
        if (arrayActivitiesId.contains(docId)) {
          activityListResult.add(Activity.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>, null));
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
          title: const Text("Mes Activités"),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        drawer: DrawerMenu(),
        appBar: AppBar(
          title: const Text("Mes Activités"),
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

  Future<List<String>> searchActivityForUser() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("ACTIVITYDATA").get();

    List<String> foundActivities = [];
    String userUid = auth.getUser();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (doc.data() != null) {
        List<dynamic> arrayField = data["participants"];
        String activityId = data["documentId"];
        if (arrayField.contains(userUid)) {
          foundActivities.add(activityId);
        }
      }
    }


    return foundActivities;
  }
}
