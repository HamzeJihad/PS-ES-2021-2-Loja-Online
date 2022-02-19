import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';


class AdminUsersManager extends ChangeNotifier{

  List<UserStore> users = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription ? _subscription;

  void updateUser(UserManager userManager){
    _subscription?.cancel();
    if(userManager.adminEnabled){
      _listenToUsers();
    }
     else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers(){

    //diferença do get para o snap é que o snap atualiza caso chegar um novo user

     _subscription = firestore.collection('users').snapshots()
        .listen((snapshot){
      users = snapshot.docs.map((d) => UserStore.fromDocument(d)).toList();
      users.sort((a, b) =>
          a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      notifyListeners();
    });
    // var faker = Faker();

    // for(int i = 0; i < 1000; i++){
    //   users.add(UserStore(
    //     name: faker.person.name(),
    //     email: faker.internet.email()
    //   ));
    

    users.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

    notifyListeners();
  }

  List<String> get names => users.map((e) => e.name!).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();

  }
} 