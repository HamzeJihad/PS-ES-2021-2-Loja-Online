import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/screen/edit_product/components/images_form.dart';
import 'package:loja_virtual/screen/edit_product/components/sizes_form.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
   EditProductScreen(Product p) :   editing = p != null,
        product = p != null ? p.clone() : Product();

  final Product product;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
        final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar produto' : 'Criar produto'),
          centerTitle: true,
        ),

  backgroundColor: Colors.white,
          body: Form(
            key: formKey,
            child: ListView(
            children: <Widget>[
              ImagesForm(product),
          Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                       onSaved: (name) => product.name = name,
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                      ),
                      validator: (name){
                        if(name!.length < 6)
                          return 'Título muito curto';
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      onSaved: (desc) => product.description = desc,
                      initialValue: product.description,
                      style: const TextStyle(
                          fontSize: 16
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: InputBorder.none
                      ),
                      maxLines: null,
                      validator: (desc){
                        if(desc!.length < 10)
                          return 'Descrição muito curta';
                        return null;
                      },
                    ),
                SizesForm(product),

                SizedBox(height: 32,),
                Consumer<Product>(
                  builder: (_,product,__){

                    return  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                      onPressed: !product.loading ?()async  {
                        if(formKey.currentState!.validate()){
                              formKey.currentState?.save();  //chama o onsaved de todos os que estão englobados no formkey

                         await product.save();

                        context.read<ProductManager>()
                            .update(product);

                        Navigator.of(context).pop();
                        }
                        else{

                          print('invalido');                      }
                      } : null,
                      child:  !product.loading ? Text(
                        'Salvar',
                                          
                      ): CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
                    ),);
                  },
                )
                  ]))
            ],
        ),
          ),
      ),
    );
  }
}