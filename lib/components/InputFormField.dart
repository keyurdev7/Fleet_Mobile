import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class InputFormField extends StatelessWidget {
  InputFormField(
      {this.hintText,
        this.prefixIcon,
        this.suffixIcon,
        this.obscureText,
        this.onSave,
        this.keyboardType,
        this.onChanged,
        this.maxLength,
        this.textInputAction,
        this.validator,
        this.controller,
        this.onPressed,
        this.maxLines,
        this.minLines,
        this.isEnabled,
      });

  final Icon prefixIcon;
  final IconButton suffixIcon;
  final String hintText;
  final bool obscureText;
  final Function onSave;
  final Function onPressed;
  final maxLength;
  final keyboardType;
  final Function onChanged;
  final bool tempObscureText = false;
  final int maxLines;
  final int minLines;
  final textInputAction;
  final MultiValidator validator;
  final bool isEnabled;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          textInputAction: textInputAction,
          onChanged: onChanged,
          maxLength: maxLength,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          onSaved: onSave,
          validator: validator,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]),
              borderRadius: BorderRadius.circular(25),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue[500]),
              borderRadius: BorderRadius.circular(25),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]),
              borderRadius: BorderRadius.circular(25),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.black45
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            counterText: "",
            fillColor: Color(0xFFF2F9FE),
          ),
          enabled: isEnabled,
        ),
      ],
    );
  }
}
