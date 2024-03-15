import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conjugo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:conjugo/drawer_menu.dart';

FirebaseFirestore db = FirebaseFirestore.instance;


class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  TextEditingController _urlController = TextEditingController();
  String? userPicture = "https://upload.wikimedia.org/wikipedia/commons/a/af/Image_non_disponible.png";

  @override void initState() {
    initializeVariables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: const Text("Paramètres"),
      ),
      body : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Image de profil :\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Image.network(userPicture!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: "Entrez un URL",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setPictureURL(context, _urlController.text);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                  minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Mettre à jour les paramètres '),
                    Icon(Icons.settings),
                  ],
                )
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {deleteUser(context);},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                  minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Supprimer le compte '),
                    Icon(Icons.delete),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> initializeVariables() async {
    String? defaultValue = await getPictureURL();
    _urlController = TextEditingController(text : defaultValue);
    if (defaultValue=="") {
      userPicture = "https://upload.wikimedia.org/wikipedia/commons/a/af/Image_non_disponible.png";
    } else {
      userPicture = defaultValue;
    }
    setState(() {});
  }

  Future<String> getPictureURL() async {
    DocumentSnapshot<Object?> userSnapshot = await db.collection('USERDATA').doc(FirebaseAuth.instance.currentUser?.uid).get();
    final data = userSnapshot.data() as Map<String, dynamic>;
    return data["picture"];
  }

  Future<void> setPictureURL(BuildContext context, String newURL) async {
    DocumentReference<Map<String, dynamic>> userSnapshot = db.collection('USERDATA').doc(FirebaseAuth.instance.currentUser?.uid);
    await userSnapshot.update({"picture" : newURL});
    userPicture = newURL;
    setState(() {});
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Image de profil modifiée avec succès'),
        duration: Duration(seconds: 5),
    ));
    }
  }

  Future<void> deleteUser(BuildContext context) async {

    final user = FirebaseFirestore.instance.collection("USERDATA").doc(FirebaseAuth.instance.currentUser?.uid);

    try {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Attention"),
          content: const Text("Vous êtes sur le point de supprimer votre compte"),
          actions: <Widget>[
            TextButton(
              onPressed: () => {
                FirebaseAuth.instance.currentUser?.delete(),
                user.delete().then((value) => {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Confirmation de suppression"),
                      content: const Text("Le compte a été supprimé avec succès"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => {Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
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
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Reconnectez vous avant de supprimer votre compte'),
        duration: Duration(seconds: 5),
    ));
    }
  }
  }
}