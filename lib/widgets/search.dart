import 'package:flutter/material.dart';

class SearchCustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool filled;
  final ValueChanged<String>? onChanged;

  const SearchCustomSearchField({
    Key? key,
    this.controller,
    this.hintText = "Search...",
    this.onChanged,
    this.filled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1), 
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xff8A96A3),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xff8A96A3),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffDEDEDE)),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color:Color(0xffDEDEDE),),
          borderRadius: BorderRadius.circular(6),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffDEDEDE)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
