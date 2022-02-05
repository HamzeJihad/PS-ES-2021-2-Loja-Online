import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/store.dart';

class StoresManager extends ChangeNotifier {

  StoresManager(){
    _loadStoreList();
  }

  List<Store> stores = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('stores').get();

    stores = snapshot.docs.map((d) => Store.fromDocument(d)).toList();
    
    notifyListeners();
  }

} 