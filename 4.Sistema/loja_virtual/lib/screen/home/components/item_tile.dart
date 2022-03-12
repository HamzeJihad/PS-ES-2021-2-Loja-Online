import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:io';

class ItemTile extends StatelessWidget {
  const ItemTile({Key? key, this.item}) : super(key: key);

  final SectionItem? item;
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return GestureDetector(
       onLongPress: homeManager.editing ? (){
        showDialog(
          context: context,
          builder: (_){
          final product = context.read<ProductManager>()
                .findProductById(item!.product ?? '');
            return AlertDialog(
               content: product.id != null
                ? ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.network(product.images!.first),
                    title: Text(product.name ?? ''),
                    subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
                )
                : null,
              title: const Text('Editar Item'),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    context.read<Section>().removeItem(item!);
                    Navigator.of(context).pop();
                  },
                  textColor: Colors.red,
                  child: const Text('Excluir'),
                ),

                 FlatButton(
                  onPressed: () async {
                    if(product.id  != null){
                      item!.product = null;
                    } else {
                      final Product product = await Navigator.of(context)
                          .pushNamed('/select_product') as Product;
                      item!.product = product.id;
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    product.id  != null
                      ? 'Desvincular'
                      : 'Vincular'
                  ),
                ),
              ],
            );
          }
        );
      } : null,
      onTap: () {
        if (item?.product != null) {
          final product = context.read<ProductManager>().findProductById(item!.product!);

          if(product != null){
            Navigator.of(context).pushNamed('/product', arguments: product);
          }
        }
      },
      child: AspectRatio(
          aspectRatio: 1,
          child:  item?.image is String ?
           FadeInImage.memoryNetwork(
            
            image: item!.image!,
            placeholder: kTransparentImage,
            fit: BoxFit.cover,
          ) 
          :  Image.file(item?.image as File, fit: BoxFit.cover,),
    ));
  }
}
