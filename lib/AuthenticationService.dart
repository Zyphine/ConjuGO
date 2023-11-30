import 'package:firebase_auth/firebase_auth.dart';

//Définition de la classe Authentification
class AuthenticationService {
  //Création d'une instance de la classe Auth de Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Fonction permettant de se connecter avec un mail et un mdp
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  //Fonction permettant de s'inscrire (créer un user) avec un mail et un mdp
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print(user.toString());
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  //Fonction permettant de se déconnecter
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  //Fonction permettant de récupérer l'uid d'un user
  String getUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (uid == null) {
      return "Null";
    } else {
      return uid;
    }
  }
}
