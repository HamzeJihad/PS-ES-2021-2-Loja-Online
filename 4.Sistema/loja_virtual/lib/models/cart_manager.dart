import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/services/cepaberto_service.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  UserStore? user;
   Address ? address;
   num productsPrice = 0.0;
    num ? deliveryPrice;

    num get totalPrice => productsPrice + (deliveryPrice ?? 0);

    final FirebaseFirestore firestore = FirebaseFirestore.instance;


  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  

  void updateUser(UserManager userManager) {
    
    user = userManager.user;
     productsPrice = 0.0;

    items.clear();
     removeAddress();

    if (user != null) {
      _loadCartItems();
       _loadUserAddress();
    }
  }
   Future<void> _loadUserAddress() async {
    if(user?.address != null
        && await calculateDelivery(user!.address!.lat!, user!.address!.long!)){
      address = user?.address;
      notifyListeners();
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

  //deletar carrinho do user
  void clear() {
    for(final cartProduct in items){
      user!.cartReference.doc(cartProduct.id).delete();
    }
    items.clear();
    notifyListeners();
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

  bool get isAddressValid => address != null && deliveryPrice != null;


   Future<void> getAddress(String cep) async {
        loading = true;

    final cepAbertoService = CepAbertoService();

    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if(cepAbertoAddress != null){
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade?.nome,
          state: cepAbertoAddress.estado?.sigla,
          lat: cepAbertoAddress.latitude,
          long: cepAbertoAddress.longitude
        );

      }

        loading = false;

    }catch(e){
       loading = false;
      return Future.error('CEP Inválido');
    }
  
  }


  void removeAddress(){
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  //receber o endereço e chamar a função calcular
  Future<void> setAddress(Address address) async {
    loading = true;
    this.address = address;

    
    if(await calculateDelivery(address.lat!, address.long!)){
       user?.setAddress(address);
         loading = false;
       //atualizar os dados do  valor da frete
    } else {
       loading = false;
      return Future.error('Endereço fora do raio de entrega :(');
    }
  }


  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.doc('aux/delivery').get();

    final latStore = doc.get('lat') as double;
    final longStore = doc.get('long') as double;
    final base = doc.get('base') as num;
    final km = doc.get('km') as num;
    final maxkm = doc.get('maxkm') as num;

    double dis =  Geolocator.distanceBetween(latStore, longStore, lat, long);

    dis /= 1000.0;

     if(dis > maxkm){
      return false;
    }

    deliveryPrice = base + dis * km;
    return true;
  }
}
