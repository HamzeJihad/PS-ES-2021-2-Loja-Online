import 'package:flutter/material.dart';
import 'package:loja_virtual/commom/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/screen/home/home_screen.dart';
import 'package:loja_virtual/screen/products/components/products_screen.dart';
import 'package:loja_virtual/screen/stores/stores_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {


  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: PageView(
        controller: pageController,
       children: [


         HomeScreen(),
             ProductsScreen(),



              Scaffold(
           drawer: CustomDrawer(),
           appBar: AppBar(
             title: Text('Home 2 '),
           ) ,),

           StoresScreen()
         
       ],
      ),
    );
  }
}