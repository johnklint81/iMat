import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/product_detail.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/app_theme.dart';

class ProductDetailDialog extends StatefulWidget {
  final Product product;
  final ProductDetail? detail;

  const ProductDetailDialog({
    super.key,
    required this.product,
    this.detail,
  });

  @override
  _ProductDetailDialogState createState() => _ProductDetailDialogState();
}

class _ProductDetailDialogState extends State<ProductDetailDialog> {
  late final ScrollController _descController;

  @override
  void initState() {
    super.initState();
    _descController = ScrollController();
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iMat = Provider.of<ImatDataHandler>(context, listen: false);
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppTheme.backgroundColor,
      child: SizedBox(
        width: AppTheme.detailCardSize,
        height: maxHeight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
          child: Column(
            children: [
              // Scrollable area
              Expanded(
                child: SingleChildScrollView(
                  child: DefaultTextStyle(
                    style: AppTheme.largeText.copyWith(color: Colors.black),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 28),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Center(
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: iMat.getImage(widget.product),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(widget.product.name,
                            style: AppTheme.largeHeading.copyWith(
                              color: Colors.black,
                              height: 1.0,
                            )),
                        const SizedBox(height: 8),
                        Text(
                          "${widget.product.price.toStringAsFixed(2)} ${widget.product.unit}",
                          style: AppTheme.largeHeading.copyWith(
                            color: Colors.black,
                            fontFamily: 'Georgia',
                            height: 1.0,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                        ),
                        if (widget.detail != null) ...[
                          const SizedBox(height: 8),
                          const Divider(color: Colors.black, thickness: 1, height: 32),
                          RichText(
                            text: TextSpan(
                              style: AppTheme.largeText.copyWith(color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: "Innehåll: ",
                                  style: TextStyle(decoration: TextDecoration.underline),
                                ),
                                TextSpan(text: widget.detail!.contents),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              style: AppTheme.largeText.copyWith(color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: "Ursprung: ",
                                  style: TextStyle(decoration: TextDecoration.underline),
                                ),
                                TextSpan(text: widget.detail!.origin),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Beskrivning:",
                            style: AppTheme.largeText.copyWith(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Scrollbar(
                            controller: _descController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _descController,
                              child: Text(
                                widget.detail!.description,
                                style: AppTheme.largeText.copyWith(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.paddingLarge),

              // Välj button
              Center(
                child: SizedBox(
                  width: AppTheme.productCardButtonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      final item = ShoppingItem(widget.product);
                      iMat.shoppingCartAdd(item);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.buttonColor2,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(
                        color: AppTheme.borderColor,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Välj",
                      style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
