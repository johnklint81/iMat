import 'package:flutter/material.dart';
import 'package:imat/widgets/top_bar.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top bar: structured to align with the three-column layout
          TopBar(),
          // Main content area
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 200,
                  color: Colors.grey[200],
                  child: Placeholder(),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: Placeholder(),
                  ),
                ),
                Container(
                  width: 250,
                  color: Colors.grey[100],
                  child: Placeholder(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
