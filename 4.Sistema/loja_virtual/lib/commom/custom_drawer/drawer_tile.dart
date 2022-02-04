import 'package:flutter/material.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {

  DrawerTile({this.iconData, this.title, this.page});

  final IconData ? iconData;
  final String ? title;
  final int ? page;

  @override
  Widget build(BuildContext context) {

    final int currentPage = context.watch<PageManager>().page;
    return InkWell(
      onTap: (){
        context.read<PageManager>().setPage(page ?? 0);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Icon(iconData, color:  currentPage == page ? Theme.of(context).primaryColor : Colors.grey,size: 32,),
            ),
            Text(title ?? '', style: TextStyle(color: Colors.grey, fontSize: 16),)
          ],
        ),
      ),
    );
  }
}