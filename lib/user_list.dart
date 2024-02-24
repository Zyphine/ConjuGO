import 'package:flutter/material.dart';
import 'package:conjugo/drawer_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:conjugo/search_widget.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class UserListPage extends StatefulWidget {
  @override
  const UserListPage({super.key});

  
  @override
  UserListHome createState() => UserListHome();
}

class Personne{
  String? nom = "";
  String? prenom = "";
  bool? admin = false;
  String? dateDeNaissance = "";
  bool? superAdmin = false;
  String? mail = "";

  Personne({
    this.nom,
    this.prenom,
    this.admin,
    this.dateDeNaissance,
    this.superAdmin,
    this.mail
  });

  factory Personne.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
      final data = snapshot.data();

      return Personne(
          //les str entre crochets sont les noms des attributs que l'on souhaite sélectionner
          nom: data?['nom'],
          prenom: data?['prenom'],
          admin: data?['admin'],
          dateDeNaissance: data?['dateDeNaissance'],
          superAdmin: data?['superAdmin'],
          mail: data?['mail']
          );
        
    }

    //Fonction qui vérifie que les éléments ne soient pas null
  Map<String, dynamic> toFirestore() {
    return {
      if (nom != null) 'nom': nom,
      if (prenom != null) 'prenom': prenom,
      if (admin != null) 'admin' : admin,
      if (dateDeNaissance != null) 'dateDeNaissance' : dateDeNaissance,
      if (superAdmin != null) 'superAdmin' : superAdmin,
      if (mail != null) 'mail' : mail
    };
  }

  //Getters
  String getNom() {
    return nom.toString();
  }

  String getPrenom() {
    return prenom.toString();
  }

  String getAdmin(){
    return admin.toString();
  }

  String getDateDeNaissance(){
    return dateDeNaissance.toString();
  }

  String getSuperAdmin(){
    return superAdmin.toString();
  }

  String getMail(){
    return mail.toString();
  }
}

class UserListHome extends State<UserListPage>{

  Future<void> dataFinder(List<Personne> personneList) async {
    await db.collection("USERDATA").get().then((querySnapshot) async {
      //Pour chaque éléments de la base, on récupére les attributs
      for (var docSnapshot in querySnapshot.docs) {
        final ref =
            db.collection("USERDATA").doc(docSnapshot.id).withConverter(
                  fromFirestore: Personne.fromFirestore,
                  toFirestore: (Personne personne, _) => personne.toFirestore(),
                );
        final docSnap = await ref.get();
        final personne = docSnap.data();

        if (personne != null) {
          //On met de cotés les éléments de la base (des objets Activity) dans une liste
          personneList.add(personne);
        } else {
          print("Base vide");
        }
      }
    });
  }

  //Initialisation de la liste des personnes
  List<Personne> personneList = List.empty(growable: true);
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: const Text("Liste des Utilisateurs"),
        centerTitle: true,
      ),

      body: Center(
        child: Column(children: <Widget>[

         /* Card(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Rechercher un utilisateur'
              ),
            onChanged: (val){
              setState(() {
                query = val;
              });
            },
            ),
          ),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('USERDATA').snapshots(),
            builder: (context, snapshots ){
              return (snapshots.connectionState == ConnectionState.waiting)
              ? Center(
                child: CircularProgressIndicator(),
              )
              :ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index){
                  var data = snapshots.data!.docs[index].data() as Map<String, dynamic>;

                  if (query.isEmpty){
                    return ListTile(
                      title: Text(
                        data['nom'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    );
                  }
                  if (data['nom'].toString().toLowerCase().contains(query.toLowerCase())){
                    return ListTile(
                      title: Text(
                        data['nom'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    );
                  }
                  return Container();
                }
              );
            },
            )*/
              
          buildSearch(),

              //Le future builder permet de réaliser l'action en 'future' avant de build la page
          FutureBuilder(
              future: dataFinder(personneList),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //Initialisation des listes pour chaque attributs
                List<String> nom = List.empty(growable: true);
                List<String> prenom = List.empty(growable: true);
                List<String> admin = List.empty(growable: true);
                List<String> dateDeNaissance = List.empty(growable: true);
                List<String> superAdmin = List.empty(growable: true);
                List<String> mail = List.empty(growable: true);
              

                //Pour chaque éléments, on vient séparer les attributs et les ranger dans des listes
                for (int i = 0; i < personneList.length; i++) {
                  nom.add(personneList[i].getNom());
                  prenom.add(personneList[i].getPrenom());
                  admin.add(personneList[i].getAdmin());
                  dateDeNaissance.add(personneList[i].getDateDeNaissance());
                  superAdmin.add(personneList[i].getSuperAdmin());
                  mail.add(personneList[i].getMail());
                  
                }
                //On vide la liste des personnes
                if (personneList.isNotEmpty) {
                  personneList = List.empty(growable: true);
                }

                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: nom.length,
                    itemBuilder: (context, index) {
                      //Les activités sont en format carte
                      return Card(
                          child: ListTile(
                              onTap: () {
                                setState(() {
                                  nom.add('Nom' + (nom.length + 1).toString());
                                  prenom.add('Prenom' + (nom.length + 1).toString());
                                });

                                //Renvoie vers la page descrition de l'activité cliquée, avec en paramètres les attributs de cette dernière
                                
                                /*Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            DescriptionPage(
                                                name: titles[index],
                                                description: subtitles[index],
                                                date: date[index],
                                                place: place[index],
                                                numberOfRemainingEntries: slot[index],
                                                documentId : docIds[index],
                                                maxNumber : maxSlots[index])));*/
                              },

                              //Dans les cartes on affiche le nom de la personne en titre
                              title: Text(nom[index] + " " + prenom[index]),
                              subtitle: Text(mail[index]),
                             /*leading: const CircleAvatar(
                                  //IMAGE DE L'ASSOCIATION (propre à chacune, enregistrée dans une base association)
                                  backgroundImage: NetworkImage(
                                      "https://www.eseg-douai.fr/mub-225-170-f3f3f3/15171/partenaire/5cf93cdcc9d5c_LOGOVILLEVERTICAL.png"
                                    )
                              ),*/
                              // "https://play-lh.googleusercontent.com/YxX2N976KtZhh16FR7dhQ_ItAcmZnpDxLvhddhuv8Q9M7jiKpf8YKDgwaLWF3XBA2f8=w240-h480-rw"
                            )
                        );
                    });
              })

        ]
      ),
      )
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Rechercher un utilisateur',
    onChanged: searchActivity,
  );

  void searchActivity(String query){
    final personne = personneList.where((personne){
      final nomLower = personne.nom!.toLowerCase();
      final searchLower = query.toLowerCase();

      return nomLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      personneList = personne;
    });
  }
}

