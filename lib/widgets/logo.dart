import 'dart:math';

import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  width: 200,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8),
                  child: Text('iMat', style: TextStyle(fontSize: 50),),
                );
}
}