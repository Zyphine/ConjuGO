import 'package:conjugo/AuthenticationService.dart';
import 'package:conjugo/activityMap.dart';
import 'package:conjugo/dashboard.dart';
import 'package:conjugo/myActivities.dart';
import 'package:conjugo/settings.dart';
import 'package:conjugo/about.dart';
import 'package:flutter/material.dart';
import 'package:conjugo/listActivity.dart';

//Classe définissant le menu
class DrawerMenu extends Drawer {
  
  AuthenticationService auth = AuthenticationService();

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              padding: EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 122, 190, 246),
              ),
              child: Column(children: <Widget>[
                const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                  textAlign: TextAlign.center,
                ),
                Image.asset('images/logo.png', height: 100),
              ])),
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            //Vers liste de activités
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => ListViewHomeLayout()));
                },
                child: const Card(
                    color: Color.fromARGB(255, 88, 180, 255),
                    child: ListTile(
                      leading: Icon(Icons.manage_search,
                          color: Colors.blue, size: 40),
                      title: Text('Liste activités',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.blue,
                              decoration: TextDecoration.underline)),
                    ))),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            //Vers mes activités
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => MyActivities()));
                },
                child: const Card(
                    color: Color.fromARGB(255, 88, 180, 255),
                    child: ListTile(
                      leading: Icon(Icons.account_circle,
                          color: Colors.blue, size: 40),
                      title: Text('Mes activités',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.blue,
                              decoration: TextDecoration.underline)),
                    ))),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            //Vers la carte
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => ActivityMap()));
              },
              child: const Card(
                  color: Color.fromARGB(255, 88, 180, 255),
                  child: ListTile(
                    leading: Icon(Icons.map, color: Colors.blue, size: 40),
                    title: Text('Carte',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                            decoration: TextDecoration.underline)),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            //Vers les paramètres
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (_, __, ___) => Settings()));
              },
              child: const Card(
                  color: Color.fromARGB(255, 88, 180, 255),
                  child: ListTile(
                      leading:
                          Icon(Icons.settings, color: Colors.blue, size: 40),
                      title: Text('Paramètres',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.blue,
                              decoration: TextDecoration.underline)))),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 20),
              //Vers la page d'accueil
              child: GestureDetector(
                onTap: () {
                  //Suppresion de l'historique et renvoie sur le chemin '/', la page d'accueil
                  //Cela permet d'éviter des erreurs où on rouvre une page encore ouverte en arrière plan
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                },
                child: const Card(
                    color: Color.fromARGB(255, 88, 180, 255),
                    child: ListTile(
                        leading: Icon(Icons.logout_outlined,
                            color: Colors.blue, size: 40),
                        title: Text('Se déconnecter',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.blue,
                                decoration: TextDecoration.underline)))),
              )),
              Padding(
              padding: EdgeInsets.only(bottom: 20),
              //Vers la dashbord
              child: GestureDetector(
                onTap: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (_, __, ___) => DashboardPage()));
              },
                child: const Card(
                    color: Color.fromARGB(255, 88, 180, 255),
                    child: ListTile(
                        leading: Icon(Icons.admin_panel_settings,
                            color: Colors.white, size: 40),
                        title: Text('Tableau de bord',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                decoration: TextDecoration.underline)))),
              )),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            //A propos
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) => About()));
                },
                child: const Text(
                    textAlign: TextAlign.center,
                    "à propos",
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline))),
          ),
          const Text("Conjugo-2023",
              style: TextStyle(color: Colors.blue), textAlign: TextAlign.center)
        ],
      ),
    );
  }
}