import 'package:flutter/material.dart';
import 'package:loja_virtual/commom/util/already_have_an_account.dart';
import 'package:loja_virtual/commom/util/background.dart';
import 'package:loja_virtual/commom/util/rounded_button.dart';
import 'package:loja_virtual/commom/util/rounded_input_field.dart';
import 'package:loja_virtual/commom/util/rounded_password_field.dart';
import 'package:loja_virtual/screen/singup/singUpRegisterScreen.dart';
import 'package:loja_virtual/screen/singup/singup_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';


class BodyLogin extends StatelessWidget {
  const BodyLogin({
    Key?  key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              SizedBox(height: size.height * 0.03),
             Padding(
               padding: const EdgeInsets.only(left: 32.0, right: 32),
               child: Image.asset(
                "assets/images/image_login_register.png",
                height: size.height * 0.35,
            ),
             ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Seu e-mail",
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "Logar",
                press: () {},
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreenRegister();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}