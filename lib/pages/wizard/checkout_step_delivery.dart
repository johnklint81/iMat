import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

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
  DateTime? _selectedDate;

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
                  children: [
                    ..._options.entries.map((entry) {
                      return RadioListTile<String>(
                        value: entry.key,
                        groupValue: _selectedOption,
                        title: Text(entry.value, style: AppTheme.mediumLargeText),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedOption = value;
                              _selectedDate = null;
                            });
                          }
                        },
                      );
                    }),
                    if (_selectedOption == 'date') ...[
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppTheme.buttonColor2,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: AppTheme.borderColor, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: now,
                            lastDate: now.add(const Duration(days: 30)),
                            locale: const Locale('sv'),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  dialogBackgroundColor: AppTheme.backgroundColor,
                                  colorScheme: ColorScheme.light(
                                    primary: AppTheme.buttonColor1,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  datePickerTheme: DatePickerThemeData(
                                    backgroundColor: AppTheme.backgroundColor,
                                    surfaceTintColor: AppTheme.backgroundColor,
                                    todayForegroundColor: MaterialStateProperty.all(Colors.black),
                                    todayBackgroundColor: MaterialStateProperty.all(Colors.transparent),
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: ButtonStyle(
                                      textStyle: MaterialStateProperty.all(
                                        AppTheme.mediumHeading.copyWith(fontSize: 16),
                                      ),
                                      foregroundColor: MaterialStateProperty.all(Colors.white),
                                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                                        final isCancel = states.contains(MaterialState.disabled);
                                        return isCancel ? Colors.deepOrange : Colors.green;
                                      }),
                                    ),
                                  ),
                                ),
                                child: MediaQuery(
                                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.4),
                                  child: child!,
                                ),
                              );
                            },
                          );

                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                        child: Text(
                          _selectedDate != null
                              ? 'Valt datum: ${_selectedDate!.toLocal().toString().split(' ')[0]}'
                              : 'Välj datum',
                          style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
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
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Tillbaka', style: AppTheme.mediumHeading.copyWith(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final handler = Provider.of<ImatDataHandler>(context, listen: false);
                        handler.deliveryOption = _selectedOption;
                        handler.deliveryDate = _selectedDate;
                        widget.onNext();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor1,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Nästa', style: AppTheme.mediumHeading.copyWith(color: Colors.white)),
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
