import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';


class OrdersManager extends ChangeNotifier {

    StreamSubscription?  _subscription;

  UserStore?  user;

  List<Order> orders = [];

  List<String> imagesAux = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateUser(UserStore user){
    this.user = user;
     orders.clear();  //limpar os pedidos já que vai listar eles
      _subscription?.cancel(); //cancelar o stream

    if(user != null){
      _listenToOrders();
    }
  }

  //listar pedidos do usuário pelo id dele

  void _listenToOrders(){
    _subscription =  firestore.collection('orders').where('user', isEqualTo: user!.id)   //ficar observando mudanças
        .snapshots().listen(
    (event) {
      for(final change in event.docChanges){  //docChanges é uma lista de todas as mudanças do doc
          switch(change.type){
            case DocumentChangeType.added:  //houve adição
              orders.add(
                Order.fromDocument(change.doc)   //eu adiciono aos meus pedidos a mudança
              );
              break;
            case DocumentChangeType.modified:   //houve modificação
              final modOrder = orders.firstWhere(    //vou identificar o pedido que sofreu alteração
                  (o) => o.orderId == change.doc.id);

              for(int i =0 ; i< modOrder.items!.length; i++){
                  imagesAux.add(modOrder.items![i].product.images!.first);
              }    
              modOrder.updateFromDocument(change.doc);
              break;
            case DocumentChangeType.removed:
              debugPrint('Deu problema sério!!!');
              break;
          }}
          notifyListeners();  //notificando mudanças
          print(imagesAux);

    });
  }


  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();   //dispose quando não for mais usar
  }
} 