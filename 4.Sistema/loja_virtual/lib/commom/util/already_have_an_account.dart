import 'package:flutter/material.dart';
import 'package:loja_virtual/commom/util/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool ? login;
  final Function() ?press;
  const AlreadyHaveAnAccountCheck({
    Key ? key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login! ? "Não tem uma conta? " : "Já tem uma conta? ",
          style: TextStyle(color:  Colors.white,),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login! ? "Cadastrar" : "Login",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}