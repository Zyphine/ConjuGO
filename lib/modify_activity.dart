import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ModifyArticlePage extends StatefulWidget {
  final String documentId;
  const ModifyArticlePage({super.key, required this.documentId});

  @override
  ModifyArticlePageState createState() => ModifyArticlePageState();
}

class ModifyArticlePageState extends State<ModifyArticlePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _limitDateController = TextEditingController();

  String title = "";
  String description = "";
  String place = "";
  int number = 0;
  Timestamp date = Timestamp.now();
  Timestamp limitDate = Timestamp.now();

  Future<void> updateArticleFields() async {
    final publication = FirebaseFirestore.instance.collection("ACTIVITYDATA").doc(widget.documentId);
    final DocumentSnapshot doc = await publication.get();
    final data = doc.data() as Map<String, dynamic>;
    _titleController = TextEditingController(text: data["name"]);
    _descriptionController = TextEditingController(text: data["description"]);
    _dateController = TextEditingController(text: formatTimestamp(data["date"]));
    _limitDateController = TextEditingController(text: formatTimestamp(data["limitDate"]));
    _placeController = TextEditingController(text: data["place"]);
    _numberController = TextEditingController(text: data["maxNumber"].toString());
    setState(() {});
  }

  @override
  void initState() {
    updateArticleFields();
    super.initState();
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
        title: const Text('modifier la publication'),
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
                child: const Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    String formattedDateTime = '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';

    return formattedDateTime;
  }

  Future<void> onSubmit(BuildContext context) async {
    //Récupère les valeurs des controlleurs du formulaire
    String title = _titleController.text;
    String description = _descriptionController.text;
    DateTime date = DateTime.parse(_dateController.text);
    DateTime limitDate = DateTime.parse(_limitDateController.text);
    String place = _placeController.text;
    int number = int.parse(_numberController.text);

    CollectionReference activities = FirebaseFirestore.instance.collection('ACTIVITYDATA');

    //On accède au document
    DocumentReference docRef = activities.doc(widget.documentId);

    final DocumentSnapshot docSnapshot = await docRef.get();
    final Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    int newNumberOfEntries = number - data["maxNumber"] + data["numberOfRemainingEntries"] as int;

    // Ajout des données dans le document
    await docRef.update({
      "name": title,
      "description": description,
      "date": date,
      "limitDate": limitDate,
      "place": place,
      "maxNumber": number,
      "numberOfRemainingEntries": newNumberOfEntries,
    });
    
    //Supprime les valeurs des controlleurs
    _titleController.clear();
    _descriptionController.clear();
    _dateController.clear();
    _placeController.clear();
    _numberController.clear();
    _limitDateController.clear();

    //affiche un message de confirmation
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Publication modifiée avec succès'),
        duration: Duration(seconds: 5),
    ));
    }
  }
}