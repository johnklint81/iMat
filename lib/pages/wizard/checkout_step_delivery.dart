import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class CheckoutStepDelivery extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CheckoutStepDelivery({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<CheckoutStepDelivery> createState() => _CheckoutStepDeliveryState();
}

class _CheckoutStepDeliveryState extends State<CheckoutStepDelivery> {
  String _selectedOption = 'asap';

  final Map<String, String> _options = {
    'asap': 'Så fort som möjligt',
    'date': 'På ett specifikt datum',
    'pickup': 'Hämta vid utlämning',
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
                width: 600,
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
                  children: _options.entries.map((entry) {
                    return RadioListTile<String>(
                      value: entry.key,
                      groupValue: _selectedOption,
                      title: Text(entry.value, style: AppTheme.mediumText),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedOption = value;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppTheme.paddingMediumSmall),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onBack,
                      child: const Text('Tillbaka'),
                    ),
                    ElevatedButton(
                      onPressed: widget.onNext,
                      child: const Text('Nästa'),
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
