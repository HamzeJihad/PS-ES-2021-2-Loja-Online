import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Product> allProducts = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(allProducts.where((p) => p.name!.toLowerCase().contains(search.toLowerCase())));
    }

    return filteredProducts;
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts = await firestore.collection('products').get();

    allProducts = snapProducts.docs.map((d) => Product.fromDocument(d)).toList();
  }

  Product findProductById(String id) {
    //esse for ou o where
    // for(int i = 0; i < allProducts.length ; i++){

    //   if(id == allProducts[i].id){

    //     return allProducts[i];

    //   }
    // }
    try {
      return allProducts.firstWhere((element) => element.id == id);
    } catch (e) {
      return Product();
    }
  }
}
