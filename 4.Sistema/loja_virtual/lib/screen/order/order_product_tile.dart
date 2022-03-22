import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/orders_manager.dart';
import 'package:provider/provider.dart';

class OrderProductTile extends StatefulWidget {

  const OrderProductTile(this.cartProduct, {this.indexPhoto});

  final CartProduct ? cartProduct;  
  final int ? indexPhoto;

  @override
  State<OrderProductTile> createState() => _OrderProductTileState();
}

class _OrderProductTileState extends State<OrderProductTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(
            '/product', arguments: widget.cartProduct!.product);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(8),
        child:  Consumer<OrdersManager>(
        builder: (_, ordersManager, __){
          return Row(
          children: <Widget>[
           widget.cartProduct!.product.images!.isNotEmpty? 
            SizedBox(
              height: 60,
              width: 60,
              child: Image.network(widget.cartProduct!.product.images!.first),
            ):
            SizedBox(
              height: 60,
              width: 60,
              child: Image.network(ordersManager.imagesAux.first),
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.cartProduct?.product.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    'Tamanho: ${widget.cartProduct?.size?? ''}',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'R\$ ${(widget.cartProduct?.fixedPrice ?? widget.cartProduct?.unitPrice) ?? 10
                        .toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),
            Text(
              '${widget.cartProduct?.quantity ?? ''}',
              style: const TextStyle(
                fontSize: 20
              ),
            ),
          ],
        );
        })
      ),
    );
  }
}