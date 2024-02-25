import 'package:conjugo/connection_page.dart';
import 'package:conjugo/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:conjugo/authentication_service.dart';

//Création d'une instance de la classe Authentification
AuthenticationService auth = AuthenticationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  //Permet de déconnecter l'utilisateur lors du retour sur la page d'accueil
  auth.signOut();
  runApp(const HomePage());
}

//Page d'accueil de l'application
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conjugo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Conjugo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    auth.signOut();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page d'accueil de ConjuGo"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Image.asset('images/logo.png', width: 200),
          ),
          const Text(
            "Bienvenue sur l'application ConjuGo",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ElevatedButton(
                onPressed: () {
                  //Renvoie sur la page de connexion
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const ConnectionPage()));
                },
                child: const Text("Connectez-Vous")),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                  onPressed: () {
                    //Renvoie sur la page d'inscription
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const RegisterPage()));
                  },
                  child: const Text("Enregistrez-Vous"))),
        ]),
      ),
    );
  }
}
