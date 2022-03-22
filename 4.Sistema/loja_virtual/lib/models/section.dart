import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section  extends ChangeNotifier{

    Section({this.id,this.name, this.type, this.items}){
       items = items ?? [];
       originalItems = List.from(items?? []);
    }

  Section.fromDocument(DocumentSnapshot document){
    name = document.get('name') as String;
    id = document.id;

    type = document.get('type') as String;
    items = (document.get('items') as List).map((e) => SectionItem.fromMap(e as Map<String,dynamic>)).toList();
  }
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;
      
    DocumentReference get firestoreRef => firestore.doc('home/$id');
    Reference get storageRef => storage.ref().child('home/$id');
    

  String ? id;
  String? name;
  String ?type;
  List<SectionItem> ? items;
  List<SectionItem> ? originalItems;


  //salvar a seção
  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if(id == null){
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

      for(final item in items!){
      if(item.image is File){
        //envio de uma imagem para o storage
        final UploadTask task = storageRef.child(Uuid().v1())
            .putFile(item.image as File);
        final TaskSnapshot snapshot = await task;
        final String url = await snapshot.ref.getDownloadURL();

        item.image = url;
      }
    }

    //passando pelos itens antes da edição e verificando se ainda existe
    for(final original in originalItems!){
      if(!items!.contains(original)){
        try {
          final ref =  storage.ref(
              original.image as String
          );
          await ref.delete();
        // ignore: empty_catches
        } catch (e){}
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items?.map((e) => e.toMap()).toList()
    };

    await firestoreRef.update(itemsData);

  }

  
  Future<void> delete() async {
    await firestoreRef.delete();
    for(final item in items ?? []){
   if((item.image as String).contains('firebase')){
      try {
        final ref = storage.ref(
            item.image as String
        );
        await ref.delete();
      // ignore: empty_catches
      } catch (e){}
    }}
  }

   void addItem(SectionItem item){
    items?.add(item);
    notifyListeners();
  }
    void removeItem(SectionItem item){
    items?.remove(item);
    notifyListeners();
  }

   Section clone(){
    return Section(
      name: name,
      id: id,
      type: type,
      items: items!.map((e) => e.clone()).toList(), //fazemos isso para não ter erro de modificar no items e impactar no items da section também
    );
  }


  String _error = '';
  String get error => _error;
  set error(String value){
    _error = value;
    notifyListeners();
  } 
 bool valid(){
    if(name == null || name!.isEmpty){
      error = 'Título inválido';
    } else if(items!.isEmpty){
      error = 'Insira ao menos uma imagem';
    } else {
      error = '';
    }
    return error == '';
  }
} 