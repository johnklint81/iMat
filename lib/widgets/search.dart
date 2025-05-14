import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();

    return Expanded(
              child: TextField( 
                onSubmitted: (value) {iMat.selectSelection(iMat.findProducts(value));},// search
                decoration: InputDecoration(
                  hintText: 'Sök produkter...',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            );
  }
}