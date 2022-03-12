import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  ImageSourceSheet({this.onImageSelected});

  final Function(File) ? onImageSelected;

  final ImagePicker picker = ImagePicker();


   Future<void> editImage(String path, BuildContext context) async {
    File ? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Editar Imagem',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
        
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Editar Imagem',
        cancelButtonTitle: 'Cancelar',
        doneButtonTitle: 'Concluir',
      )
    );
    if(croppedFile != null){
      onImageSelected!(croppedFile);
    }
  }
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: Theme.of(context).primaryColor,
      onClosing: (){},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
        ElevatedButton(
        onPressed: ()async {
             final XFile? file =
                  await picker.pickImage(source: ImageSource.camera);
                  editImage(file!.path, context);
        },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor),
            child: const Text("Câmera",
                  ),
                ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor),
        onPressed: () async{
              final XFile? file =
                  await picker.pickImage(source: ImageSource.gallery);
              editImage(file!.path, context);
        },
            child: const Text("Galeria",
                  ),
                ),  
         
        ],
      ),
    );
  }
}