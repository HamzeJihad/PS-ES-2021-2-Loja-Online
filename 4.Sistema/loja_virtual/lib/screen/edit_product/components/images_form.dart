import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screen/edit_product/components/image_source_sheet.dart';

class ImagesForm extends StatelessWidget {

  const ImagesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
     initialValue: List.from(product.images!),
        validator: (images){
        if(images?.isEmpty ?? true)
          return 'Insira ao menos uma imagem';
        return null;
      },
      onSaved: (images) => product.newImages = images,
      builder: (state){
        
         void onImageSelected(File file){
          state.value?.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        
        return Column(
          children: [
                
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: AspectRatio(
                
                aspectRatio: 16/9,
                child: CarouselSlider(
                  
                   options: CarouselOptions(
          aspectRatio: 16/9,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: true,
                  reverse: false,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                      ),

                  items: state.value!.map<Widget>((image){
                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        if(image is String)
                          Image.network(image, fit: BoxFit.fill,)
                        else
                          Image.file(image as File,fit: BoxFit.fill, ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: (){
                              state.value!.remove(image);
                              state.didChange(state.value);
                            
                              print(state);
                            },
                          ),
                        )
                      ],
                    );
                  }).toList()..add(
                    Material(
                      
                      color: Colors.grey[300],
                      child: Container(
                        width: double.infinity,
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          color: Theme.of(context).primaryColor,
                          iconSize: 50,
                          onPressed: (){
                            showModalBottomSheet(
                                context: context,
                                builder: (_) => ImageSourceSheet(
                                  onImageSelected:onImageSelected
                                )
                            );
                          },
                        ),
                      ),
                    )
                  ),
                
                ),
              ),
            ),

             if(state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}