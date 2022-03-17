import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/commom/custom_icon_button.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/src/provider.dart';

class CepInputField extends StatefulWidget {



   CepInputField(this.address);

  final Address? address;

  @override
  State<CepInputField> createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
    final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();
    if(widget.address?.zipCode == null)  //exibir o campo de digitar cep
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
            enabled: !cartManager.loading,
           controller: cepController,
          decoration: const InputDecoration(
            isDense: true,
            
            labelText: 'CEP',
            hintText: '12.345-678'
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
             CepInputFormatter(),
          ],
           validator: (cep){
            if(cep!.isEmpty)
              return 'Campo obrigatório';
            else if(cep.length != 10)
              return 'CEP Inválido';
            return null;
          },
          keyboardType: TextInputType.number,
        ),

          if(cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
        RaisedButton(
          onPressed: !cartManager.loading ? () async {
              try {
                  await context.read<CartManager>().getAddress(cepController.text);
                } catch (e){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                      backgroundColor: Colors.red,
                    )
                  );
                }

          }: null,
          textColor: Colors.white,
          color: primaryColor,
          disabledColor: primaryColor.withAlpha(100),
          child: const Text('Buscar CEP'),
        ),
      ],
    );

      //remover o cep
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address?.zipCode}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 20,
              onTap: (){
                context.read<CartManager>().removeAddress();
              },
            ),
          ]));
  }
}