import 'package:flutter/material.dart';

//Page description des activités
class DescriptionPage extends StatelessWidget {
  String nom;
  String description;
  // String genre = ""; // Pas implémenté, à rajouter
  String date;
  String lieu;
  String nbPlace;
  DescriptionPage(
      {super.key,
      //Définitions des éléments requis
      required this.nom,
      required this.description,
      required this.date,
      required this.lieu,
      required this.nbPlace});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //Le titre de la page est le nom de l'activité sur laquelle nous avons appuyée
          title: Text(nom),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                //Image
                Container(
                  margin: EdgeInsets.all(50),
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      //Image générique à remplacer : soit le logo de l'association, soit une photo de l'activité
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://assistance-sociale.fr/wp-content/uploads/2021/12/ccas-douai"),
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                    //Places restantes
                    padding: const EdgeInsets.all(16.0),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2)),
                    child: Column(
                      children: [
                        const Text(
                          'Places\nrestantes',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              decoration: TextDecoration.underline),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          nbPlace,
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ))
              ],
            ),
            Container(
              //Date
              margin: EdgeInsets.only(left: 25.0),
              width: 300,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quand :',
                      style: TextStyle(color: Colors.blue, fontSize: 30),
                      textAlign: TextAlign.left),
                  Text(date,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      textAlign: TextAlign.left),
                ],
              ),
            ),
            Container(
              //Lieu
              margin: EdgeInsets.only(left: 25.0),
              width: 300,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Où :',
                      style: TextStyle(color: Colors.blue, fontSize: 30),
                      textAlign: TextAlign.left),
                  Text(lieu,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      textAlign: TextAlign.left),
                ],
              ),
            ),
            Container(
              //Description
              margin: EdgeInsets.only(left: 25.0),
              width: 300,
              height: 101,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Description :',
                      style: TextStyle(color: Colors.blue, fontSize: 30),
                      textAlign: TextAlign.left),
                  Text(
                    description,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Container(
                //Bouton inscription
                margin: EdgeInsets.only(left: 100.0, top: 50.0),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: TextButton(
                      child: Text("Je m'inscris".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 222, 205, 51)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.black)))),
                      onPressed: () => null
                      //Pour l'instant ne fait rien, à implémenter. Soit avec systèmes favoris, soit inscription avec décompte des places
                      ),
                ))
          ],
        ));
  }
}
