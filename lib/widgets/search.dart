import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    return Container(
      height: AppTheme.searchbarHeight,
      alignment: Alignment.center,
      child: TextField(
        onSubmitted: (value) =>
            iMat.selectSelection(iMat.findProducts(value)),
        style: const TextStyle(
          fontSize: AppTheme.searchbarFontSize,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          hintText: 'Sök produkter...',
          isDense: false,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.black),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search, size: 36, color: Colors.black),
              SizedBox(width: AppTheme.paddingTiny),
            ],
          ),


        ),
      ),
    );
  }
}
