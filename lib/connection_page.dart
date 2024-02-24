import 'package:conjugo/list_activity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conjugo/authentication_service.dart';

//Création des instances de dialogue avec la bdd (firestore) et d'authentification (auth)
FirebaseFirestore firestore = FirebaseFirestore.instance;
AuthenticationService auth = AuthenticationService();

//Page de connexion
class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});
  @override
  State<ConnectionPage> createState() => ConnectionPageState();
}

class ConnectionPageState extends State<ConnectionPage> {
  //Définition des champs textuels
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connectez-vous"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(children: [
          Container(
            child: Form(
                child: Column(children: <Widget>[
              //Mail
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: " Veuillez rentrer votre mail"),
              ),
              //MDP
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText:
                        " Veuillez rentrer votre mot de passe au format JJMMAAAA"),
              ),
            ])),
          ),
          Container(
              child: ElevatedButton(
                  //Bouton qui lance la fonction de connexion de Auth
                  child: const Text("Se connecter"),
                  onPressed: () {
                    auth.signInWithEmailAndPassword(
                        emailController.text, passwordController.text);
                    //On utilise un bool pour qu'on ne se connecte qu'une seule fois
                    //bool isConnected = false;
                    //if (!isConnected) {
                      //On vérifie si un utilisateur est connecté (se lance en future)
                      FirebaseAuth.instance
                          .authStateChanges()
                          .listen((User? user) {
                        if (user == null) {
                          showAlertDialogError(context);
                          emailController.clear();
                          passwordController.clear();
                          
                          //isConnected = true;
                        }

                        else{
                         showAlertDialog(context);
                          
                        }
                        
                      });
                      
                      //La pop up erreur est mise à l'extérieur de la fonction listen car sinon on a une erreur 'The showDialog function context parameter is a BuildContext that is no longer valid'
                      // showAlertDialogError(context);
                      //On nettoie les champs lorsque ce ne sont pas les bon id
                      //emailController.clear();
                      //passwordController.clear();
                      // La pop up erreur s'affiche avant la pop up 'ok' car le test signin se fait en future, donc quand il teste le user il est pas encore connecté

                    //}
                    
                    
                
                  }
                  //},
                  ))
        ]),
      ),
    );
  }

  //Pop up 'ok'
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        if (mounted) {
          //Le if(mounted) permet de résoudre une erreur qui arrivait quand on voulait réafficher les pop up alors qu'elles ont déjà été fermé, enfin j'ai pas tout compris le pb mais mounted est la solution
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ListViewHomeLayout(),
              ),
              (Route<dynamic> route) => false);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Connexion effectuée"),
      content: const Text(
          "Vous êtes connecté, appuyez sur ok pour accéder à la liste des activités."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    if (mounted) {
      //Même explication qu'au dessus pour le mounted
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  //Pop up d'erreur
  showAlertDialogError(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Erreur"),
      content: const Text("Mail ou mot de passe invalide. Veuillez réessayer."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }
}
