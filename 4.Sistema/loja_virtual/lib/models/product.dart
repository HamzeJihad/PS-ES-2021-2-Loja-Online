import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';

class Product extends ChangeNotifier {
  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.get('images') as List<dynamic>);
    sizes = ((document.get('sizes') as List<dynamic>)).map((s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();
  }

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

ItemSize findSize(String name){ 
    try {
      return sizes!.firstWhere((s) => s.name == name);
    } catch (e){
      return ItemSize();
    }
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
  String? id;
  String? name;
  String? description;
  List<String>? images;
  List<ItemSize>? sizes;
}
