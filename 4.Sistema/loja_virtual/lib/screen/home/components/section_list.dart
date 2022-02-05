import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Section.dart';
import 'package:loja_virtual/screen/home/components/item_tile.dart';
import 'package:loja_virtual/screen/home/components/section_header.dart';


class SectionList extends StatelessWidget {

  const SectionList(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(section),
          SizedBox(height: 16),
            SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index){
               return ItemTile(
               item:  section.items![index]
                
              );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 4,),
              itemCount: section.items!.length,
            ),
          )
        ],
      ),
    );
  }
}