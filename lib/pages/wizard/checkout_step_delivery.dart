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
                  children: _options.entries.map((entry) {
                    return RadioListTile<String>(
                      value: entry.key,
                      groupValue: _selectedOption,
                      title: Text(entry.value, style: AppTheme.mediumLargeText),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                          style: AppTheme.mediumHeading.copyWith(color: Colors.white)
                        ,),
                    ),
                    ElevatedButton(
                      onPressed: widget.onNext,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.buttonColor1,
                          foregroundColor: Colors.black
                      ),
                      child: Text(
                          'Nästa',
                          style: AppTheme.mediumHeading.copyWith(color: Colors.white),),
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
