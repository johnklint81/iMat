import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blueGrey,
        child: Container(
                      width: 90,
                      height: 50,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(8),
                      child: Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_circle_rounded),
                          Text('Konto')
                        ],
                      ),
                    ),
      ),
    );
  }
}