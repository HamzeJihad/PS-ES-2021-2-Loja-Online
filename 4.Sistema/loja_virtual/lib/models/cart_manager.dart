import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  UserStore? user;
  num productsPrice = 0.0;

  void updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();

    if (user != null) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user!.cartReference.get(); //Pego tudo que está na collection carrinho

    //vamos fazer isso para atualizar quantidade de um item no firebase, dar update, etc. ADDLISTENER
    items = cartSnap.docs.map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)).toList();
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      if (e.quantity != null) {
        e.quantity = e.quantity! + 1;
      }
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);

      //vamos fazer isso para atualizar quantidade de um item no firebase, dar update, etc.
      cartProduct.addListener(_onItemUpdated); //toda vez que der um notifyer no cartproduct, vai chamar o listener aqui
      items.add(cartProduct);
      user!.cartReference.add(cartProduct.toCartItemMap()).then((value) => cartProduct.id = value.id);
      _onItemUpdated();
    }
  }

 void _onItemUpdated() {
   productsPrice = 0.0;
    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];
 
      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.getTotalPrice;
      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  } 
  

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user!.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated); //remover o listener já que ele vai ser excluido 
    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {

    if(cartProduct.id != null)
    user!.cartReference.doc(cartProduct.id).update(cartProduct.toCartItemMap());
  }

  bool get isCartValid {
      for(final cartProduct in items){
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }
}
