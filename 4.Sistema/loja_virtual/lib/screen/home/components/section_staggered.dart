import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/screen/home/components/add_tile_widget.dart';
import 'package:loja_virtual/screen/home/components/item_tile.dart';
import 'package:loja_virtual/screen/home/components/section_header.dart';
import 'package:provider/provider.dart';
import 'package:loja_virtual/models/section.dart';

class SectionStaggered extends StatelessWidget {

  const SectionStaggered(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return  ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(),
         
            SizedBox(height: 16),
          Consumer<Section>(
            builder: (_, section,__){
              return  MasonryGridView.count(
                physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              crossAxisCount: 4,
              itemCount: homeManager.editing
                      ? section.items!.length + 1
                      : section.items!.length,
              itemBuilder: (_, index){
                 if(index < section.items!.length)
                     return ItemTile(
                 item:  section.items![index]
                  
                );
                  else 
                    return AddTileWidget();
                },
             
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            );
            },
          )
          ],
        ),
      ),
    );
  }
}