import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class CheckoutStepPayment extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final ValueChanged<String> onSelectedMethod;

  const CheckoutStepPayment({
    required this.onNext,
    required this.onBack,
    required this.onSelectedMethod,
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
                          widget.onSelectedMethod(value); // ⬅️ Notify parent
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
                          foregroundColor: Colors.black
                      ),
                      child: Text(
                          'Tillbaka',
                        style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: widget.onNext,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.buttonColor1,
                          foregroundColor: Colors.black
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
