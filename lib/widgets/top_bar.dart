import 'package:flutter/material.dart';
import 'package:imat/widgets/login.dart';
import 'package:imat/widgets/logo.dart';
import 'package:imat/widgets/searching_bar.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
            height: 80,
            color: Colors.cyanAccent,
            child: Row(
              children: [
                // Left column (same width as category panel)
                Logo(),
                // Middle column (same width as main view)
                SearchingBar(),
                // Right column (same width as basket panel)
                Login(),
              ],
            ),
          );
  }
}