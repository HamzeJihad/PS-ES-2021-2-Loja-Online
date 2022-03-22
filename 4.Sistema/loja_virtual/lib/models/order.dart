import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/helpers/status.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';


class Order {


  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user!.id!;
    address = cartManager.address;
    status = Status.preparing;

  }
    DocumentReference get firestoreRef =>
    firestore.collection('orders').doc(orderId);

    void updateFromDocument(DocumentSnapshot doc){   //pego apenas o status pq é o único que pode ser modificado
    status = Status.values[doc.get('status') as int];
  }
    Order.fromDocument(DocumentSnapshot doc){
    orderId = doc.id;

    items = (doc.get('items') as List<dynamic>).map((e){
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc.get('price') as num;
    userId = doc.get('user') as String;
    address = Address.fromMap(doc.get('address') as Map<String, dynamic>);
    date = doc.get('date') as Timestamp;
    status = Status.values[doc.get('status') as int];

  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set(
      {
        'items': items!.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user': userId,
        'address': address!.toMap(),
         'status': status!.index,
        'date': Timestamp.now(),
      }
    );
  }


  String? orderId;
  List<CartProduct> ?items;
  num ?price;
  String ?userId;
  Address ?address;
  Timestamp ?date;

    String get formattedId => '#${orderId?.padLeft(6, '0')}';

   String get statusText => getStatusText(status!);
  Status ? status;

  static String getStatusText(Status status) {
    switch(status){
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparação';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

    //avançar o status do pedido ou diminuir
    Function() get back {
    return status!.index >= Status.transporting.index ?
      (){
        status = Status.values[status!.index - 1];
        firestoreRef.update(
          {'status': status!.index}
        );
      } : (){};
  }

  Function() get advance {
    return status!.index <= Status.transporting.index ?
      (){
        status = Status.values[status!.index + 1];
      firestoreRef.update(
          {'status': status!.index}
        );
      }: (){};
  }

    void cancel(){
    status = Status.canceled;
    firestoreRef.update({'status': status!.index});
  }
} 