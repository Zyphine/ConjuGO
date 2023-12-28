import 'package:conjugo/homePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:conjugo/AuthenticationService.dart';

// Création instance pour communiquer avec la base + partie authentification
FirebaseFirestore db = FirebaseFirestore.instance;
AuthenticationService auth = AuthenticationService();

//Page inscription
class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  //Initialisation des champs textuels
  TextEditingController emailController = TextEditingController();
  TextEditingController emailController2 = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

// Création fonction qui vérifie si le mot de passe contient au moins 1 lettre et 1 chiffre
bool passwordContainLetterAndNumber(String password) {
  // Vérifier la présence d'au moins une lettre
  bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
  // Vérifier la présence d'au moins un chiffre
  bool hasNumber = password.contains(RegExp(r'[1234567890]'));
  // Retourner true si le mot de passe respecte les critères, sinon false
  return hasLetter && hasNumber;
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscrivez-vous"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 232, 40, 152),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Scrollbar(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Container(
              child: Form(
                  //Formulaire contenant infos inscriptions seniors
                  child: Column(children: <Widget>[
                const SizedBox(height: 20),
                TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: " Nom")),
                const SizedBox(height: 20),
                TextFormField(
                    controller: surnameController,
                    decoration: const InputDecoration(labelText: " Prénom")),
                TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Date de Naissance"),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1920),
                          lastDate: DateTime(2025));
                      //On transforme la date au format souhaité
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);

                        dateController.text = formattedDate;
                      } else {
                        print("Vous n'avez pas sélectionné de date");
                      }
                    }),
                const SizedBox(height: 20),
                TextFormField(
                    //Mail
                    controller: emailController,
                    toolbarOptions: const ToolbarOptions(
                      //Rendre impossible les copier-coller
                      copy: true,
                      cut: true,
                      paste: true, //Peut-être pas besoin car déjà "true" de base
                      selectAll: true,
                    ),
                    decoration: const InputDecoration(labelText: " Mail")),
               /*TextFormField(
                    //Mail 2
                    controller: emailController2,
                    toolbarOptions: const ToolbarOptions(
                      copy: false,
                      cut: false,
                      paste: false,
                      selectAll: false,
                    ),
                    decoration: const InputDecoration(
                        labelText: " Rentrez votre mail une seconde fois")),*/
                const SizedBox(height: 20),
                TextFormField(
                    // MDP
                    obscureText: true,
                    controller: passwordController,
                    toolbarOptions: const ToolbarOptions(
                      copy: false,
                      cut: false,
                      paste: false,
                      selectAll: false,
                    ),
                    decoration: const InputDecoration(
                        labelText: " Mot de Passe (minimum 8 caractères, au moins 1 lettre et 1 chiffre)")),
                const SizedBox(height: 20),
                TextFormField(
                    //MDP 2
                    obscureText: true,
                    controller: passwordController2,
                    toolbarOptions: const ToolbarOptions(
                      copy: false,
                      cut: false,
                      paste: false,
                      selectAll: false,
                    ),
                    decoration: const InputDecoration(
                        labelText:
                            " Rentrez votre mot de passe une seconde fois")),
              ])),
            ),
            Container(
                child: ElevatedButton(
                    //Bouton inscription
                    child: const Text("S'inscrire"),
                    onPressed: () //=> print(emailControler.text),
                        async {
                      //Vérifications que le mdp est dans le bon format et qu'il a bien été rédigé 2 fois
                      if (passwordController.text.length >= 8 &&
                          passwordController.text == passwordController2.text &&
                          passwordContainLetterAndNumber(passwordController.text) == true) {
                        //Vérifications que le mail a bien été rentré correctement 2 fois
                          //Inscription
                          auth.registerWithEmailAndPassword(
                              emailController.text, passwordController.text);
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) {
                            //On regarde si un user est donc connecté, si oui, on prend son id
                            if (user != null) {
                              String userUid = auth.getUser();
                              //Insertion des infos user dans la base firestore
                              db.collection("USERDATA").doc(userUid).set({
                                "nom": nameController.text,
                                "prénom": surnameController.text,
                                "date_naissance": dateController.text,
                                "admin": false,
                                "super_admin": false
                              });
                              //Redirection vers page accueil activités
                              showAlertDialog(context);
                            }
                          });

                      } else {
                        //Pop up erreur mdp et on nettoie les 2 mdp
                        showAlertDialogMdp(context);
                        passwordController.clear();
                        passwordController2.clear();
                      }
                    }))
          ]),
        )),
      ),
    );
  }

//ALERTES
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        if (mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Incriptions effectuée"),
      content: Text("Vous êtes inscrit, retour à la page d'accueil."),
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

  showAlertDialogMail(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.of(context).pop(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Erreur"),
      content: Text("Mails non identiques"),
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
//Pas implémenté + Faire aussi si le mail est pas dans le format : il se passe rien pour l'instant car erreur firebase mais y a pas de pop
  // showAlertDialogMailAlrdy(BuildContext context) {
  //   // set up the button
  //   Widget okButton = TextButton(
  //     child: Text("OK"),
  //     onPressed: () => Navigator.of(context).pop(),
  //   );

  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Erreur"),
  //     content: Text("Mail déjà existant"),
  //     actions: [
  //       okButton,
  //     ],
  //   );

  //   // show the dialog
  //   if (mounted) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return alert;
  //       },
  //     );
  //   }
  // }

  showAlertDialogMdp(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Erreur"),
      content: Text(
          "Mots de passes différents ou au mauvais format \n Vérfiez qu'ils soient sous la forme JOUR MOIS ANNEE-> JJMMAAAA"),
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
