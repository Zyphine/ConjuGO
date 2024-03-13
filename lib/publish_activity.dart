import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PublishArticlePage extends StatefulWidget {
  const PublishArticlePage({super.key});

  @override
  PublishArticlePageState createState() => PublishArticlePageState();
}

class PublishArticlePageState extends State<PublishArticlePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _limitDateController = TextEditingController();
  String? _selectedType;

  Future<List<String>> fetchDataFromFirestore() async {
    List<String> types = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('ACTIVITYGENRE').get();
      for (var doc in querySnapshot.docs) {
        types.add(doc['nom']);
      }
      types.sort();
    } catch (e) {
      //print('Error fetching data: $e');
    }
    return types;
  }

  // Méthode appelée lorsque la valeur de la DropdownButton est changée
  void onChanged(String? value) {
    setState(() {
      _selectedType = value;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _limitDateController.dispose();
    _placeController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une publication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: null, //Aucune limite de ligne dans le texte de description
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "Date"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    locale : const Locale('fr')
                  );

                  if (pickedDate != null && context.mounted) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      }
                    );

                    if (pickedTime != null) {
                      //combine l'heure et la date
                      DateTime combinedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      //change le format de date+heure
                      String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);

                      //mise a jour du champ
                      _dateController.text = formattedDateTime;
                    }
                  }
                }
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _limitDateController,
                decoration: const InputDecoration(
                      icon: Icon(Icons.event_busy),
                      labelText: "Date limite d'inscription"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedLimitDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    locale : const Locale('fr')
                  );

                  if (pickedLimitDate != null && context.mounted) {
                    TimeOfDay? pickedLimitTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      }
                    );

                    if (pickedLimitTime != null) {
                      //combine l'heure et la date
                      DateTime combinedLimitDateTime = DateTime(
                        pickedLimitDate.year,
                        pickedLimitDate.month,
                        pickedLimitDate.day,
                        pickedLimitTime.hour,
                        pickedLimitTime.minute,
                      );

                      //change le format de date+heure
                      String formattedLimitDateTime = DateFormat('yyyy-MM-dd HH:mm').format(combinedLimitDateTime);

                      //mise a jour du champ
                      _limitDateController.text = formattedLimitDateTime;
                    }
                  }
                }
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<String>>(
                future: fetchDataFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<String> items = snapshot.data ?? [];
                    return DropdownButton<String>(
                      value: _selectedType,
                      items: items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: onChanged,
                      hint: const Text("Type d'activité"),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _placeController,
                decoration: const InputDecoration(labelText: 'Lieu'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Nombre de places'),
                keyboardType: TextInputType.number, //Ouvre un clavier numérique uniquement
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], //Ne permet qu'un nombre entier
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  onSubmit(context);
                },
                child: const Text('Publier'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit(BuildContext context) async {
    //Récupère les valeurs des controlleurs du formulaire
    String title = _titleController.text;
    String description = _descriptionController.text;
    DateTime date = DateTime.parse(_dateController.text);
    DateTime limitDate = DateTime.parse(_limitDateController.text);
    String place = _placeController.text;
    int number = int.parse(_numberController.text);
    String? type = _selectedType;

    CollectionReference activities = FirebaseFirestore.instance.collection('ACTIVITYDATA');

    //Ajout d'un nouveau document dans la table des activités
    DocumentReference docRef = activities.doc();

    // On récupère l'ID du document
    String documentId = docRef.id;
    
    // On récupère l'id du propriétaire de la publication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    //on récupère l'image associée
    DocumentSnapshot<Object?> userSnapshot = await FirebaseFirestore.instance.collection('USERDATA').doc(userId).get();
    final data = userSnapshot.data() as Map<String, dynamic>;
    String pictureURL = data["picture"];

    // Ajout des données dans le document
    await docRef.set({
      "documentId": documentId, //On stock l'ID pour pouvoir retrouver la publication au moment de l'inscription d'une personne
      "name": title,
      "description": description,
      "date": date,
      "limitDate": limitDate,
      "place": place,
      "maxNumber": number,
      "numberOfRemainingEntries": number,
      "participants": [],
      "owner": userId,
      "type": type,
      "picture": pictureURL,
    });
    
    //Supprime les valeurs des controlleurs
    _titleController.clear();
    _descriptionController.clear();
    _dateController.clear();
    _placeController.clear();
    _numberController.clear();
    _limitDateController.clear();
    //Supprime la valeur dans la liste
    setState(() {
      _selectedType = null;
    });

    //affiche un message de confirmation
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Publication ajoutée avec succès'),
        duration: Duration(seconds: 5),
    ));
    }
  }
}