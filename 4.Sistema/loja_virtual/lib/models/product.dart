import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {

    Product({this.id, this.name, this.description, this.images, this.sizes}){
   images = images ?? [];
   sizes = sizes ?? [];
  } 

    String? id;
  String? name;
  String? description;
  List<String>? images;
  List<ItemSize>? sizes;

  bool  _loading = false;

bool get loading => _loading;


  set loading(bool value){
    _loading = value;
    notifyListeners();
  }
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;
    DocumentReference get firestoreRef => firestore.doc('products/$id');
    Reference get storageRef => storage.ref().child('products').child(id??'');

  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.get('images') as List<dynamic>);
    sizes = ((document.get('sizes') as List<dynamic>)).map((s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();
  }


   Product clone(){
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images!),
      sizes: sizes?.map((size) => size.clone()).toList(),
    );
  }
  List<dynamic>? newImages;
  ItemSize _selectedSize = ItemSize();
  ItemSize get selectedSize {
    if (_selectedSize != null)
      return _selectedSize;
    else
      return ItemSize();
  }

  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }
  

 num get basePrice {
    num lowest = double.infinity;
    for(final size in sizes!){
      if(size.price! < lowest && size.hasStock)
        lowest = size.price!;
    }
    return lowest;
  }
ItemSize findSize(String name){ 
    try {
      return sizes!.firstWhere((s) => s.name == name);
    } catch (e){
      return ItemSize();
    }
  }


 List<Map<String, dynamic>> exportSizeList(){
    return sizes!.map((size) => size.toMap()).toList();
  }

  //SALVAR OS DADOS BÁSICOS, NAME, DESCRIPTION E SIZES.
  Future<void> save() async {
        loading = true;

    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
    };

    if(id == null){ //criando produto
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      //atualizando
      await firestoreRef.update(data);
      
    }

     final List<String> updateImages = [];


    for(final newImage in newImages!){
      if(images!.contains(newImage)){
        updateImages.add(newImage as String);
      } else {
        final UploadTask task = storageRef.child(Uuid().v1()).putFile(newImage as File);
        final TaskSnapshot snapshot = await task;
        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }

          for(final image in images!){
          if(!newImages!.contains(image)){
            try {
              final ref = storage.refFromURL(image);
              await ref.delete(); //deletando a imagem que não está mais sendo utilizada do firebase
            } catch (e){
              debugPrint('Falha ao deletar $image');
            }
          }
        }
 
    await firestoreRef.update({'images': updateImages}); //dar um update no produto com as novas imagens
 
    images = updateImages;
 
    loading = false;
  }
  num get totalStock {
    num stock = 0;
    for(final size in (sizes ?? [])){
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0;
  }



  
    // IMAGES [URL1, URL2, URL3]
    // NEWIMAGES [URL2, URL3, FILE1, FILE2]
    // UPDATED [URL2, URL3, FURL1, FURL2]

    // MANDA FILE1 PRO STORAGE -> FURL1
    // MANDA FILE2 PRO STORAGE -> FURL2
    // EXCLUI IMAGEM URL1 DO STORAGE

    // IMAGES [URL1, URL2, URL3]
    // NEWIMAGES [URL3, FILE1]
    // UPDATE [URL3, FURL1]

    // MANDA FILE1 PRO STORAGE -> FURL1
    // EXLUIR URL1 DO STORAGE
    // EXLUIR URL2 DO STORAGE

   
}
