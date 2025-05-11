import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top bar: structured to align with the three-column layout
          Container(
            height: 80,
            color: Colors.blueGrey[50],
            child: Row(
              children: [
                // Left column (same width as category panel)
                Container(
                  width: 200,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8),
                  child: Placeholder(fallbackHeight: 40, fallbackWidth: 100),
                ),
                // Middle column (same width as main view)
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      width: 400,
                      child: Placeholder(fallbackHeight: 40),
                    ),
                  ),
                ),
                // Right column (same width as basket panel)
                Container(
                  width: 250,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(8),
                  child: Placeholder(fallbackHeight: 40, fallbackWidth: 100),
                ),
              ],
            ),
          ),
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
