import 'package:conjugo/list_activity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  bool obscureText1 = true;

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
          Form(
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
              obscureText: obscureText1,
              controller: passwordController,
              decoration: InputDecoration(
                  labelText:
                      " Veuillez rentrer votre mot de passe",
                  suffixIcon: IconButton(
                    icon: Icon(obscureText1 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscureText1 = !obscureText1;
                      });
                    },
                  ),
                )
            ),
          ])),
          ElevatedButton(
              //Bouton qui lance la fonction de connexion de Auth
              child: const Text("Se connecter"),
              onPressed: () async {
                try {
                  await auth.signInWithEmailAndPassword(emailController.text, passwordController.text);
                  if (context.mounted) {
                    showConfirmDialog(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    if (e.toString().contains("wrong-password")) {
                      showErrorDialog(context, "Mot de passe incorrect.");
                      passwordController.clear();
                    }
                    else if (e.toString().contains("too-many-requests")) {
                      showErrorDialog(context, "Votre compte est temporairement blocké \n suite à plusieurs tentative de connexion échoué");
                      passwordController.clear();
                    }
                    else{
                      showErrorDialog(context, "Vérifez votre connexion internet ou votre adresse mail");
                      passwordController.clear();                      
                    }
                  }
                }        
              }
            )
        ]),
      ),
    );
  }

  //Pop up 'ok'
  showConfirmDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        if (mounted) {
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  showErrorDialog(BuildContext context, String errorText) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Erreur"),
      content: Text(errorText),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }
}
