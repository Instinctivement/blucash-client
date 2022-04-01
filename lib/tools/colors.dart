import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

const Color primary = Color(0xFF49BAEB);
const Color secondary = Color(0xFF5874B9);
const Color grey = Color(0xFF7D97A1);
const Color dark = Color(0xFF212529);
const Color container = Color(0xFFF2F5F8);
Color alert = Colors.yellow.shade200;
Color white = Colors.white;

 checkcode(String? code) {
  bool isUrl = isURL(code!); 
  bool isMail = isEmail(code); 
  bool length = isLength(code, 100, 1024);
  if (isUrl || isMail || !length) {
    return false;
  } else {
    return true;
  }
  

}