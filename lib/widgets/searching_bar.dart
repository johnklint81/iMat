import 'package:flutter/material.dart';

class SearchingBar extends StatelessWidget {
  const SearchingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 800,
        child: SearchAnchor.bar(
          barHintText: 'Skriv här för att hitta en vara...',
          suggestionsBuilder: (BuildContext context, SearchController controller){
            return List<ListTile>.generate(5, (int index){
              final String item = 'item $index';
              return ListTile(title: Text(item),
                onTap: (){true;},
          );
        }
      );
    }
              )
            )
          );
  }
 
}