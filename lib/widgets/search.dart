import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final allProducts = iMat.products;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: AppTheme.searchbarHeight,
          alignment: Alignment.center,
          child: RawAutocomplete<Product>(
            textEditingController: _controller,
            focusNode: _focusNode,
            optionsBuilder: (TextEditingValue value) {
              if (value.text.isEmpty) return const Iterable<Product>.empty();
              final results = allProducts.where((p) =>
                  p.name.toLowerCase().startsWith(value.text.toLowerCase()));
              // Update filtered list as you type
              WidgetsBinding.instance.addPostFrameCallback((_) {
                iMat.selectSelection(results.toList());
              });
              return results;
            },
            displayStringForOption: (p) => p.name,
            onSelected: (selected) {
              iMat.selectSelection([selected]);
            },
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (value) =>
                    iMat.selectSelection(iMat.findProducts(value)),
                onChanged: (value) =>
                    iMat.selectSelection(iMat.findProducts(value)),
                style: const TextStyle(
                  fontSize: AppTheme.searchbarFontSize,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Sök produkter...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.white,
                  elevation: 4,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final Product option = options.elementAt(index);
                        final bool isHighlighted =
                            AutocompleteHighlightedOption.of(context) == index;

                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Container(
                            color: isHighlighted
                                ? Colors.orange.shade100
                                : null,
                            padding: const EdgeInsets.all(12),
                            child: Text(option.name,
                                style: AppTheme.mediumText),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
