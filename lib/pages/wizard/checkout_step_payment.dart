import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class CheckoutStepPayment extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final ValueChanged<String> onSelectedMethod;

  final double totalAmount;

  const CheckoutStepPayment({
    required this.onNext,
    required this.onBack,
    required this.onSelectedMethod,
    required this.totalAmount,
    super.key,
  });



  @override
  State<CheckoutStepPayment> createState() => _CheckoutStepPaymentState();
}

class _CheckoutStepPaymentState extends State<CheckoutStepPayment> {
  String _selectedMethod = 'card';

  final Map<String, String> _methods = {
    'card': 'VISA/Mastercard',
    'swish': 'Swish',
    'invoice': 'Faktura',
    'klarna': 'Klarna',
    'qliro': 'Qliro',
  };

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
                      title: Text(entry.value, style: AppTheme.mediumLargeText),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedMethod = value;
                          });
                          widget.onSelectedMethod(value);
                        }
                      },
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

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              title: const Text('Bekräfta ditt köp', style: AppTheme.LARGEHeading),
                              content: SizedBox(
                                width: 500, // or any desired width
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Vill du genomföra köpet?', style: AppTheme.largeText),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Totalsumma: ${widget.totalAmount.toStringAsFixed(2)} kr',
                                      style: AppTheme.largeHeading,
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
                                    await handler.placeOrder();

                                    widget.onNext(); // Now safe to navigate
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
