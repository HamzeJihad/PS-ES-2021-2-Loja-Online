import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/commom/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screen/admin_orders/admin_orders_screen.dart';
import 'package:loja_virtual/screen/admin_users/admin_users_screen.dart';
import 'package:loja_virtual/screen/home/home_screen.dart';
import 'package:loja_virtual/screen/order/orders_screen.dart';
import 'package:loja_virtual/screen/products/components/products_screen.dart';
import 'package:loja_virtual/screen/stores/stores_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

    @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => PageManager(pageController),
        child: Consumer<UserManager>(builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            children: [
              HomeScreen(),
              ProductsScreen(),
              OrdersScreen(),

              StoresScreen(),
              if (userManager.adminEnabled) ...[
               AdminUsersScreen(),
                AdminOrdersScreen()
              ]
            ],
          );
        }));
  }
}
