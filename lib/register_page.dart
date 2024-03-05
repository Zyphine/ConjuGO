import 'dart:async';
import 'package:conjugo/list_activity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:conjugo/authentication_service.dart';

// Création instance pour communiquer avec la base + partie authentification
FirebaseFirestore db = FirebaseFirestore.instance;
AuthenticationService auth = AuthenticationService();

//Page inscription
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  //Initialisation des champs textuels
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool obscureText1 = true;
  bool obscureText2 = true;

  // Création fonction qui vérifie si le mot de passe contient au moins 1 lettre et 1 chiffre
  bool passwordContainLetterAndNumber(String password) {
    // Vérifier la présence d'au moins une lettre
    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    // Vérifier la présence d'au moins un chiffre
    bool hasNumber = password.contains(RegExp(r'[1234567890]'));
    // Retourner true si le mot de passe respecte les critères, sinon false
    return hasLetter && hasNumber;
  }

  StreamSubscription<User?>? authListener;

  @override
  void initState() {
    super.initState();
    authListener = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      //On regarde si un user est donc connecté, si oui, on prend son id
        if (user != null) {
          String userUid = auth.getUser();
          //Insertion des infos user dans la base firestore
          db.collection("USERDATA").doc(userUid).set({
            "userId" : userUid,
            "nom": nameController.text,
            "prenom": surnameController.text,
            "dateDeNaissance": dateController.text,
            "admin": false,
            "superAdmin": false,
            "mail": emailController.text,
            "phone" : phoneController.text,
          });
          //Redirection vers page accueil activités
          showConfirmDialog(context);
        }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordController2.dispose();
    nameController.dispose();
    surnameController.dispose();
    dateController.dispose();
    phoneController.dispose();
    authListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscrivez-vous"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Scrollbar(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Form(
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
              TextFormField(
                  controller: dateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner une date';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "Date de Naissance"),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1920),
                        lastDate: DateTime(2025),
                        locale : const Locale('fr'));
                    //On transforme la date au format souhaité
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);

                      dateController.text = formattedDate;
                    }
                  }),
              const SizedBox(height: 20),
              TextFormField(
                  //Téléphone
                  controller: phoneController,
                  contextMenuBuilder: (context, editableTextState) {
                    final List<ContextMenuButtonItem> buttonItems = editableTextState.contextMenuButtonItems;
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                  decoration: const InputDecoration(labelText: "Numéro de téléphone"),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 20),
              TextFormField(
                  //Mail
                  controller: emailController,
                  contextMenuBuilder: (context, editableTextState) {
                    final List<ContextMenuButtonItem> buttonItems = editableTextState.contextMenuButtonItems;
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                  decoration: const InputDecoration(labelText: " Mail")),
             
              const SizedBox(height: 20),
              TextFormField(
                  // MDP
                  obscureText: obscureText1,
                  controller: passwordController,
                  contextMenuBuilder: null,
                  decoration: InputDecoration(
                    labelText: " Mot de Passe (minimum 8 caractères, au moins 1 lettre et 1 chiffre)",
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
              const SizedBox(height: 20),
              TextFormField(
                //MDP 2
                obscureText: obscureText2,
                controller: passwordController2,
                contextMenuBuilder: null,
                decoration: InputDecoration(
                  labelText: " Rentrez votre mot de passe une seconde fois",
                  suffixIcon: IconButton(
                    icon: Icon(obscureText2 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscureText2 = !obscureText2;
                      });
                    },
                  ),
                )
              ),
            ])),
            ElevatedButton(
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
                      try {
                        await auth.registerWithEmailAndPassword(emailController.text, passwordController.text);
                        // Connecte l'utilisateur après l'inscription
                        await auth.signInWithEmailAndPassword(emailController.text, passwordController.text);
                      } catch (exception) {
                        if (context.mounted) {
                          if (exception.toString()=="[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
                            showErrorDialog(context, "Un compte avec la même adresse email existe déjà");
                            emailController.clear();
                          } else if (exception.toString()=="[firebase_auth/invalid-email] The email address is badly formatted.") {
                            showErrorDialog(context, "format d'email invalide");
                            emailController.clear();
                          }
                        }
                        passwordController.clear();
                        passwordController2.clear();
                      }
                  } else {
                    showErrorDialog(context, "Mot de passe trop faible");
                    passwordController.clear();
                    passwordController2.clear();
                  }
                })
          ]),
        )),
      ),
    );
  }

//ALERTES
  showConfirmDialog(BuildContext context) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Incription effectuée"),
            content: const Text("Vous êtes inscrit, retour à la page d'accueil."),
            actions: [
              TextButton(
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
              ),
            ],
          );
        },
      );
    }
  }

  showErrorDialog(BuildContext context, String errorText) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Erreur"),
            content: Text(errorText),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }
}
