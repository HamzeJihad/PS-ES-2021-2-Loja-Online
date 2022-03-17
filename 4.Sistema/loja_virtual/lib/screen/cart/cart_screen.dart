import 'package:flutter/material.dart';
import 'package:loja_virtual/commom/empty_card.dart';
import 'package:loja_virtual/commom/login_card.dart';
import 'package:loja_virtual/commom/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/screen/cart/cart_tile.dart';

import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __){
           if(cartManager.user == null){
            return LoginCard();
          }

          if(cartManager.items.isEmpty){
            return EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum produto no carrinho!',
            );
          }
          return ListView(
            children:[
               Column(
              children: cartManager.items.map(
                  (cartProduct) => CartTile(cartProduct)
              ).toList(),
            

            ),
          
              PriceCard(buttonText: 'Continuar para entrega', onPressed: cartManager.isCartValid ? (){
                 Navigator.of(context).pushNamed('/address');
              } :null), 
            ],

          );
        },
      ),
    );
  }
}