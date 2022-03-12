import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/admins_user_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/models/store_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/routes/route_generator.dart';
import 'package:provider/provider.dart';

void main() async{

 WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          
          create: (_) => CartManager(),
          update: (_, userManager, cartManager) =>
            cartManager!..updateUser(userManager),
          lazy: false,
          ),

        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false
          ),

        //  ChangeNotifierProvider(
        //   create: (_) => Section(),
        //   lazy: false
        //   ),
  

        ChangeNotifierProvider(
          create: (_) => StoresManager(),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
            adminUsersManager!..updateUser(userManager),
        )
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto de Software',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 4, 125, 141),
        scaffoldBackgroundColor: Color.fromARGB(255, 4, 125, 141),
        backgroundColor: Color.fromARGB(255, 4, 125, 141),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color.fromARGB(255, 4, 125, 141),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        initialRoute: '/base',
        onGenerateRoute: RouteGenerator.generateRoute,
        
     ) );
  }
}

