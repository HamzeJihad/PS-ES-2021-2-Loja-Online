import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

class CartProduct extends ChangeNotifier{


  CartProduct.fromProduct(this._product){
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name ?? '';

  }

  CartProduct.fromDocument(DocumentSnapshot document){
    id = document.id; 
    productId = document.get('pid');
    quantity = document.get('quantity');
    size = document.get('size');

    firestore.doc('products/$productId').get().then((value) {
    product = Product.fromDocument(value);
    });
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String ?productId;
  int ?quantity;
  String ?size;
  String  ? id;
  Product ? _product;
  num ? fixedPrice;

   Product get product => _product!;
  set product(Product value){
    _product = value;
    notifyListeners();
  }



   ItemSize get itemSize {
    if(product.name != null) 
    return product.findSize(size!);

    else return ItemSize();
  }

  num get unitPrice {
    if(itemSize.price != null){
    return itemSize.price ?? 0;
    }
    else return 0;
  }

  num get getTotalPrice{

    return unitPrice * quantity!;
  }

  Map<String, dynamic> toCartItemMap(){
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

    Map<String, dynamic> toOrderItemMap(){
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice,  //para o user ver o preço que ele pagou, não salvar apenas o id, pq o preço muda

    };
  }


  bool stackable(Product product){
    return product.id == productId && product.selectedSize.name == size;
  }
  

   void increment(){
    quantity = quantity! + 1;
    notifyListeners();
  }

  void decrement(){
    quantity = quantity! -1;
    notifyListeners();
  }


    bool get hasStock {
    final size = itemSize;
    if(size.name == null) return false;
    return size.stock! >= quantity!;
  }

}