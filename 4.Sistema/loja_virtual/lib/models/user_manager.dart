import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/helpers/firebase_error.dart';
import 'package:loja_virtual/models/user.dart';

class UserManager extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserStore? user;

  UserManager() {
    _loadCurrentUser();
  }
  bool _loading = false;
  bool get loading => _loading;
  bool get isLoggedIn => user != null;


  Future<void> signIn({UserStore? user, Function? onFail, Function? onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(email: user!.email!, password: user.password!);

      await _loadCurrentUser(firebaseUser: result.user);
      onSuccess!();
    } on FirebaseAuthException catch (e) {
      print(e);
      onFail!(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signUp({UserStore? user, Function? onFail, Function? onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(email: user!.email!, password: user.password!);

      user.id = result.user!.uid;
      this.user = user;
      await user.saveData();
      onSuccess!();
    } on FirebaseAuthException catch (e) {
      onFail!(getErrorString(e.code));
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User ? firebaseUser}) async {
    final User currentUser = firebaseUser ?? await auth.currentUser!;
    if (currentUser != null) {
      final DocumentSnapshot docUser = await firestore.collection('users').doc(currentUser.uid).get();
      user = UserStore.fromDocument(docUser);

     final docAdmin = await firestore.collection('admins').doc(user!.id).get();
      if(docAdmin.exists){
        user!.admin = true;
      }
      notifyListeners();

    }
  }

  bool get adminEnabled => user != null && user!.admin;

  void signOut(){
    auth.signOut();
    user = null;
    notifyListeners();
  }

  

}
