import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screen/address/address_screen.dart';
import 'package:loja_virtual/screen/base_screen/base_screen.dart';
import 'package:loja_virtual/screen/cart/cart_screen.dart';
import 'package:loja_virtual/screen/checkout/checkout_screen.dart';
import 'package:loja_virtual/screen/edit_product/edit_product_screen.dart';
import 'package:loja_virtual/screen/login/login_screen.dart';
import 'package:loja_virtual/screen/products/product_screen.dart';
import 'package:loja_virtual/screen/select_product/select_product_screen.dart';
import 'package:loja_virtual/screen/singup/singup_screen.dart';

class RouteGenerator {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpScreen());

      case '/product':
        return MaterialPageRoute(builder: (_) => ProductScreen(settings.arguments as Product));

      case '/cart':
        return MaterialPageRoute(builder: (_) => CartScreen(),
        settings: settings

        );

      case '/select_product':
              return MaterialPageRoute(
                  builder: (_) => SelectProductScreen()
              );
      case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) => EditProductScreen(
                      settings.arguments as Product
                  )
              ); 

      case '/address':
              return MaterialPageRoute(
                  builder: (_) => AddressScreen()
              );   

      case '/checkout':
            return MaterialPageRoute(
                builder: (_) => CheckoutScreen()
            );             
      case '/base':
      default:
        return MaterialPageRoute(builder: (_) => BaseScreen(),
         settings: settings);
    }
  }
}
