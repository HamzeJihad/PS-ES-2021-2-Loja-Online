// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;


    final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
         actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            textColor: Colors.white,
            child: const Text(
              'CRIAR CONTA',
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      
      ),
      
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager,__){

                return ListView(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: <Widget>[
                TextFormField(
                  enabled: !userManager.loading,
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (email) {
                      if(!emailValid(email!))
                      return 'E-mail inválido';
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: passController ,
                    enabled: !userManager.loading,
                  decoration: InputDecoration(
                      hintText: 'Senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      )),
                  autocorrect: false,
                  obscureText: !showPassword,
                  validator: (pass) {
                    if (pass!.isEmpty || pass.length < 6) return 'Senha inválida';
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: const Text('Esqueci minha senha'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    
                    onPressed: userManager.loading ? null:  () {

                       if(formKey.currentState!.validate()){

                           context.read<UserManager>().signIn(
                          user:UserStore(
                            email: emailController.text,
                            password: passController.text
                            
                          ),
                           onFail: (e){
                            scaffoldKey.currentState!.showSnackBar(
                              SnackBar(
                                content: Text('Falha ao entrar: $e'),
                                backgroundColor: Colors.red,
                              )
                            );
                          },
                          onSuccess: (){
                             Navigator.of(context).pop();
                          }
                        
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      
                      
                    ),
                    child:  userManager.loading ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ): const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            );
         
              },
            )
          ),
        ),
      ),
    );
  }
}
