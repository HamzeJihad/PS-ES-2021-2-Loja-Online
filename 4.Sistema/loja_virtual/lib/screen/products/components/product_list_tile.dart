import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';

class ProductListTile extends StatelessWidget {

  ProductListTile(this.product, {this.showButton});

  int ? showButton =0;

  bool moreFont  =false;

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(0),
              child: Row(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(product.images!.first, fit: BoxFit.cover,),
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          product.name!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4, right: 16),
                              child: Text(
                                'A partir de',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                          'R\$${product.basePrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).primaryColor
                          ),
                        )
                          ],
                        ),
                        
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        //   if(showButton ==100 )
        //   Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: ElevatedButton(
        //       onPressed: (){
                
        //       }, child: Text('Diminuir fonte')),
        //   )
        ],
      ),
    );
  }
}