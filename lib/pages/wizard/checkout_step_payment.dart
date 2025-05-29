import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import '../../model/imat/shopping_item.dart';

class CheckoutStepPayment extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final ValueChanged<String> onSelectedMethod;
  final Function(List<ShoppingItem> items, double total) onSetReceiptData;
  final double totalAmount;

  const CheckoutStepPayment({
    required this.onNext,
    required this.onBack,
    required this.onSelectedMethod,
    required this.onSetReceiptData,
    required this.totalAmount,
    super.key,
  });

  @override
  State<CheckoutStepPayment> createState() => _CheckoutStepPaymentState();
}

class _CheckoutStepPaymentState extends State<CheckoutStepPayment> {
  String _selectedMethod = 'card';

  final Map<String, String> _methodImages = {
    'card': 'assets/images/visamc.jpg',
    'swish': 'assets/images/swish.png',
    'invoice': 'assets/images/invoice.webp',
    'klarna': 'assets/images/klarna.png',
    'qliro': 'assets/images/qliro.png',
  };

  final Map<String, String> _methods = {
    'card': 'VISA/Mastercard',
    'swish': 'Swish',
    'invoice': 'Faktura',
    'klarna': 'Klarna',
    'qliro': 'Qliro',
  };

  double _calculateTotal(List<ShoppingItem> items) {
    return items.fold<double>(0.0, (sum, item) => sum + item.total);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.backgroundColor,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: AppTheme.paddingSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppTheme.wizardCardSize,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.borderColor,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _methods.entries.map((entry) {
                    return RadioListTile<String>(
                      value: entry.key,
                      groupValue: _selectedMethod,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedMethod = value;
                          });
                          context.read<ImatDataHandler>().setPaymentMethod(value);
                        }
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.value, style: AppTheme.mediumLargeText),
                          Image.asset(
                            _methodImages[entry.key] ?? 'assets/images/default.png',
                            width: 72,
                            height: 64,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),

                    );
                  }).toList(),

                ),
              ),
              const SizedBox(height: AppTheme.paddingMediumSmall),
              SizedBox(
                width: AppTheme.wizardCardSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor2,
                      ),
                      child: Text(
                        'Tillbaka',
                        style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final cart = context.read<ImatDataHandler>().getShoppingCart().items;
                        if (cart.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              title: Center(
                                child: Text(
                                  "Varukorgen är tom",
                                  style: AppTheme.largeHeading.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              content: Text(
                                "Du måste ha minst en vara i varukorgen för att slutföra köpet.",
                                style: AppTheme.mediumLargeText,
                                textAlign: TextAlign.center,
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppTheme.buttonColor2,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  ),
                                  child: Text(
                                    "OK",
                                    style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        // Visa bekräftelseruta
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              title: const Text('Bekräfta ditt köp', style: AppTheme.LARGEHeading),
                              content: SizedBox(
                                width: 500,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Är du säker på att du vill genomföra köpet?', style: AppTheme.largeText),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Totalsumma: ${_calculateTotal(cart).toStringAsFixed(2)} kr',
                                      style: AppTheme.LARGEHeading,
                                    ),
                                  ],
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppTheme.buttonColor2,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  ),
                                  child: Text(
                                    'Avbryt',
                                    style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    final handler = context.read<ImatDataHandler>();
                                    final items = List<ShoppingItem>.from(handler.getShoppingCart().items);
                                    final total = _calculateTotal(items);
                                    widget.onSelectedMethod(_selectedMethod);

                                    widget.onSetReceiptData(items, total); // Sätt före placeOrder

                                    await handler.placeOrder();
                                    widget.onNext();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.buttonColor1,
                                  ),
                                  child: Text(
                                    'Köp',
                                    style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor1,
                      ),
                      child: Text(
                        'Betala',
                        style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
