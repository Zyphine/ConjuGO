import 'package:flutter/material.dart';

//Page description des activités
class DescriptionPage extends StatelessWidget {
  String name;
  String description;
  // String genre = ""; // Pas implémenté, à rajouter
  String date;
  String place;
  String numberOfRemainingEntries;
  DescriptionPage(
      {super.key,
      //Définitions des éléments requis
      required this.name,
      required this.description,
      required this.date,
      required this.place,
      required this.numberOfRemainingEntries});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Le titre de la page est le nom de l'activité sur laquelle nous avons appuyée
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Column(
          appBar: AppBar(
            //Le titre de la page est le name de l'activité sur laquelle nous avons appuyée
            title: Text(name),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  //Image
                  Container(
                    margin: const EdgeInsets.all(50),
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
                      margin: EdgeInsets.only(bottom: 0),
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
                            numberOfRemainingEntries,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 20),
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
                //place
                width: 300,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Où :',
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                        textAlign: TextAlign.left),
                    Text(place,
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
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 222, 205, 51)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Colors.black)))),
                        onPressed: () => null,
                        //Pour l'instant ne fait rien, à implémenter. Soit avec systèmes favoris, soit inscription avec décompte des places
                        child: Text("Je m'inscris".toUpperCase(),
                            style: const TextStyle(fontSize: 14))),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
