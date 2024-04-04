import 'package:conjugo/authentication_service.dart';
import 'package:conjugo/favorites.dart';
import 'package:conjugo/dashboard.dart';
import 'package:conjugo/my_activities.dart';
import 'package:conjugo/settings.dart';
import 'package:conjugo/about.dart';
import 'package:flutter/material.dart';
import 'package:conjugo/list_activity.dart';

//Classe définissant le menu
class DrawerMenu extends Drawer {
  
  final AuthenticationService auth = AuthenticationService();

  DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 300,
            child : DrawerHeader(
                padding: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(children: <Widget>[
                  const Expanded(flex: 2,child : Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                    ),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(flex:8, child:Image.asset('images/logo.png', height: 300)),
                ]))),
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            //Vers liste de activités
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const ListViewHomeLayout()));
                },
                child: const Card(
                    color: Colors.blue,
                    child: ListTile(
                      leading: Icon(Icons.manage_search,
                          color: Colors.white, size: 40),
                      title: Text('Rechercher des activités',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,)),
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            //Vers mes activités
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const MyActivities()));
                },
                child: const Card(
                    color: Colors.blue,
                    child: ListTile(
                      leading: Icon(Icons.event_available,
                          color: Colors.white, size: 40),
                      title: Text('Mes activités',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,)),
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            //Vers les favoris
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const Favorites()));
              },
              child: const Card(
                  color: Colors.blue,
                  child: ListTile(
                    leading: Icon(Icons.favorite, color: Colors.white, size: 40),
                    title: Text('Favoris',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,)
                    ),
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            //Vers les paramètres
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (_, __, ___) => const Settings()));
              },
              child: const Card(
                  color: Colors.blue,
                  child: ListTile(
                      leading:
                          Icon(Icons.settings, color: Colors.white, size: 40),
                      title: Text('Paramètres',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,)
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            //Vers la page d'accueil
            child: GestureDetector(
              onTap: () async {
                await auth.signOut();
                // Supprime l'historique des page après deconnexion et renvoi vers la page d'accueil
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                }
              },

              child: const Card(
                color: Colors.blue,
                child: ListTile(
                  leading: Icon(Icons.logout_outlined,
                    color: Colors.white, size: 40),
                  title: Text('Se déconnecter',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,)))),
          )),
              //Vers la dashbord

          FutureBuilder<bool>(
            future: auth.isUserAdmin(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // renvoi un container vide pendant l'attente
              } else if (snapshot.hasError) {
                return Container(); // renvoi un container vide en cas d'erreur
              } else {
                bool isAdmin = snapshot.data ?? false;

                // N'afficher le boutton vers le tableau de bord que si l'utilisateur est admin
                return isAdmin? Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const DashboardPage()
                        )
                      );
                    },
                    child: const Card(
                      color: Colors.blue,
                      child: ListTile(
                        leading: Icon(Icons.admin_panel_settings,
                            color: Colors.white, size: 40),
                        title: Text('Tableau de bord',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,)),
                      ),
                    ),
                  ),
                )
                : Container(); //renvoi un container vide si l'utilisateur n'est pas administrateur
              }
            },
          ),
          
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            //A propos
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) => const About()));
                },
                child: const Text(
                    textAlign: TextAlign.center,
                    "à propos",
                    style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline))),
          ),
          const Text("Conjugo-2023",
              style: TextStyle(color: Colors.blue), textAlign: TextAlign.center)
        ],
      ),
    );
  }
}