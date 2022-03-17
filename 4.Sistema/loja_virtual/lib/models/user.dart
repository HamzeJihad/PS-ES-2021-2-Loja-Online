import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';

class UserStore {

  UserStore({this.email, this.password, this.name, this.id});

  String ? email;
  String ? password;
  String ? name;
  String? confirmPassword;
  String ? id;  
  Address ? address;
  
  UserStore.fromDocument(DocumentSnapshot document){
    id = document.id;
    name = document.get('name');
    email = document.get('email');
    Map<String,dynamic> dataMap = document.data() as Map<String,dynamic>;
     if(dataMap.containsKey('address')){
      address = Address.fromMap(
          document['address'] as Map<String, dynamic>);
    }
  }
  DocumentReference get firestoreRef => FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  bool admin = false;
  
  //salvar todos os dados do usuário no banco de dados
  Future<void> saveData()async{

   await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap(){
   return {
      'name': name,
      'email': email,
       if(address != null)
        'address': address?.toMap(),
    };
  }

  void setAddress(Address address){
    this.address = address;
    saveData();
  }


} 