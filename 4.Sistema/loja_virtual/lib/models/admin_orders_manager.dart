import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/helpers/status.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';

class AdminOrdersManager extends ChangeNotifier {

  final List<Order> _orders = [];
  UserStore ? userFilter;
    List<Status> statusFilter = [Status.preparing];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription  ? _subscription;  //serve para cancelar o snapshot que fica tirando uma 'foto' a cada vez que muda
  //qualquer coisa na collection orders, se não usarmos o subscription irá rodar sempre.

  void updateAdmin({bool ? adminEnabled}){
    _orders.clear();

    _subscription?.cancel();
    if(adminEnabled??false){
      _listenToOrders();
    }
  }

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();

    if(userFilter != null){
      output = output.where((o) => o.userId == userFilter!.id).toList();
    }

    return output.where((o) => statusFilter.contains(o.status)).toList();  //filtrar por status
  }



 void setUserFilter(UserStore user, bool set){
   if(set)
    userFilter = user;

  else 
    userFilter = null;   
    notifyListeners();
  }


  void _listenToOrders(){
    _subscription = firestore.collection('orders').snapshots().listen(
      (event) {
        for(final change in event.docChanges){
          switch(change.type){
            case DocumentChangeType.added:
              _orders.add(
                Order.fromDocument(change.doc)
              );
              break;
            case DocumentChangeType.modified:
              final modOrder = _orders.firstWhere(
                  (o) => o.orderId == change.doc.id);
              modOrder.updateFromDocument(change.doc);
              break;
            case DocumentChangeType.removed:
              debugPrint('Deu problema sério!!!');
              break;
          }
        }
        notifyListeners();
    });
  }

   void setStatusFilter({Status? status, bool? enabled}){
    if(enabled  ?? false){
      statusFilter.add(status!);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

} 