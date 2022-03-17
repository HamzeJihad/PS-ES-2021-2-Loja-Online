import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/product.dart';

class CheckoutManager extends ChangeNotifier {

  CartManager ? cartManager;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager){
    this.cartManager = cartManager;
  }


   bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }
  void checkout({ required Function onStockFail, required Function onSuccess}) async{
        loading = true;
     try {
      await _decrementStock();
    } catch (e){
        onStockFail(e);
   loading = false;
    }

   
    final orderId = await _getOrderId();

    final order = Order.fromCartManager(cartManager!);
    order.orderId = orderId.toString();

    await order.save();
    cartManager!.clear();

    onSuccess();
    loading = false;
  }

   Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc.get('current') as int;
        tx.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      }
      );
      return result['orderId'] as int;
    } catch (e){
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }

   }
  Future<void> _decrementStock(){
    // 1. Ler todos os estoques 3xM
    // 2. Decremento localmente os estoques 2xM
    // 3. Salvar os estoques no firebase 2xM

        return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for(final cartProduct in cartManager!.items){
        Product product = Product();

        if(productsToUpdate.any((p) => p.id == cartProduct.productId)){
          product = productsToUpdate.firstWhere(
                  (p) => p.id == cartProduct.productId);
        } else {
          final doc = await tx.get(
              firestore.doc('products/${cartProduct.productId}')
          );
          product = Product.fromDocument(doc);  //pego os dados do produto atualizado
        }

        cartProduct.product = product; //adiciono o produto atualizado

        final size = product.findSize(cartProduct.size!);
        if(size.stock! - cartProduct.quantity! < 0){
          productsWithoutStock.add(product); //adicionando produto que não está mais disponível
        } else {
          size.stock =  size.stock! - cartProduct.quantity!;
          productsToUpdate.add(product);
        }
      }

      if(productsWithoutStock.isNotEmpty){
        return Future.error(
            '${productsWithoutStock.length} produtos sem estoque');
      }

      for(final product in productsToUpdate){  //deu tudo certo
        tx.update(firestore.doc('products/${product.id}'),  
            {'sizes': product.exportSizeList()});
      }
    });
  }
} 