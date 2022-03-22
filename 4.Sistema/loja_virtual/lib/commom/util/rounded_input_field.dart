import 'package:flutter/material.dart';
import 'package:loja_virtual/commom/util/constants.dart';
import 'package:loja_virtual/commom/util/text_field_container.dart';
import 'package:loja_virtual/helpers/validators.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextFieldContainer(
      child: TextFormField(
        validator: (email) {
          if (!emailValid(email!)) return 'E-mail inválido';
          return null;
        },
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
