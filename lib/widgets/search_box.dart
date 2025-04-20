import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/custom_text_style.dart';


class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchBox({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: TextField(
        style: myTextStyle15(),
        controller: controller,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: "Search items...",
          hintStyle: myTextStyle15(fontColor: Colors.black45),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: AppColors.main.withAlpha(80),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(55.0),
            borderSide: BorderSide(color: AppColors.main),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.main),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.main),
          ),
        ),
      ),
    );
  }
}
