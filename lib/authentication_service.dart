import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Définition de la classe Authentification
class AuthenticationService {
  //Création d'une instance de la classe Auth de Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  //Création d'une instance de la classe firestore de Firebase
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //Fonction permettant de se connecter avec un mail et un mdp
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  } catch (exception) {
    rethrow; 
  }
}

  //Fonction permettant de s'inscrire (créer un user) avec un mail et un mdp
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (exception) {
      rethrow; 
    }
  }

  //Fonction permettant de se déconnecter
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
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

  Future<bool> isUserAdmin() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
        //Récupère le champ booléen admin depuis firebase
        DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection('USERDATA').doc(user.uid).get();
        dynamic isAdmin = snapshot.data()?['admin'];
        return isAdmin;
    } else {
      return false;
    }
  }

  Future<bool> isUserSuperAdmin() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
        //Récupère le champ booléen admin depuis firebase
        DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection('USERDATA').doc(user.uid).get();
        dynamic isAdmin = snapshot.data()?['superAdmin'];
        return isAdmin;
    } else {
      return false;
    }
  }
}