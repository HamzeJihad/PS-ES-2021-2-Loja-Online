import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screen/products/components/size_widget.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {

  const ProductScreen(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name!),
          centerTitle: true,
           actions: <Widget>[
           
           Consumer<UserManager>(
             builder: (_, userManager, __){
               if(userManager.adminEnabled){

                 return IconButton(
                    onPressed: (){
                      Navigator.of(context)
                          .pushReplacementNamed('/edit_product', arguments: product);
                    },
                    icon: Icon(Icons.edit));
               }

               return Container();
             },
           )
            
          ],
        ),
        
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: CarouselSlider(
                items: product.images?.map((url) => Container(child: Center(child:  Image.network(url),),)).toList(),
              
                options: CarouselOptions(

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ 19.99',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  Text(
                    product.description!,
                    style: const TextStyle(
                      fontSize: 16
                    ),
                  ),

                    Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tamanhos',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes!.map((s){
                      return SizeWidget(size: s);
                    }).toList(),
                    
                  ),
                    const SizedBox(height: 32,),
                  if(product.hasStock)
                    Consumer2<UserManager, Product>(
                      builder: (_, userManager, product, __){
                        return SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: product.selectedSize.name != null ? (){
                              if(userManager.isLoggedIn){
                                context.read<CartManager>().addToCart(product);
                                 Navigator.of(context).pushNamed('/cart');
                              } else {
                                Navigator.of(context).pushNamed('/login');
                              }
                            } : null,

                              style: ElevatedButton.styleFrom(
                            primary: product.selectedSize.name != null ? 
                            Theme.of(context).primaryColor : Colors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), ),
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            
                      
                    ),
                          
                            child: Text(
                              userManager.isLoggedIn
                                  ? 'Adicionar ao Carrinho'
                                  : 'Entre para Comprar',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    )
                ],

                
              ),
            )
          ],
        ),
      ),
    );
  }
}