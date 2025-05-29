import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/app_theme.dart';
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
  TimeOfDay? _selectedTime;

  final Map<String, String> _options = {
    'asap': 'Så fort som möjligt',
    'date': 'På ett specifikt datum',
    'pickup': 'Hämta vid utlämning',
  };

  bool get _canProceed {
    if (_selectedOption == 'date') {
      // kräver både datum och tid
      return _selectedDate != null && _selectedTime != null;
    }
    // övriga alternativ går alltid vidare
    return true;
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
              // Kortet med valen
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
                    // Radioknapparna
                    ..._options.entries.map((entry) {
                      return RadioListTile<String>(
                        value: entry.key,
                        groupValue: _selectedOption,
                        title: Text(entry.value, style: AppTheme.mediumLargeText),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedOption = value;
                            _selectedDate = null;
                            _selectedTime = null;
                          });
                        },
                      );
                    }).toList(),

                    // Datum- och tidsväljare om “date” är valt
                    if (_selectedOption == 'date') ...[
                      const SizedBox(height: 12),

                      // Rad med två knappar: datum + tid
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppTheme.buttonColor1,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: AppTheme.borderColor, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            onPressed: () async {
                              final now = DateTime.now();
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: now,
                                lastDate: now.add(const Duration(days: 30)),
                                locale: const Locale('sv'),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _selectedDate = pickedDate;
                                  _selectedTime = null;
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
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: _selectedDate == null
                                  ? Colors.grey.shade400
                                  : AppTheme.buttonColor1,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: AppTheme.borderColor, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            onPressed: _selectedDate == null
                                ? null
                                : () async {
                              final now = TimeOfDay.now();
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: now,
                                builder: (context, child) => Localizations.override(
                                  context: context,
                                  locale: const Locale('sv'),
                                  child: child!,
                                ),
                              );

                              if (pickedTime != null) {
                                setState(() {
                                  _selectedTime = pickedTime;
                                });
                              }
                            },
                            child: Text(
                              _selectedTime != null
                                  ? 'Vald tid: ${_selectedTime!.format(context)}'
                                  : 'Välj tid',
                              style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.paddingMediumSmall),

              // Knappen “Tillbaka” och “Nästa”
              SizedBox(
                width: AppTheme.wizardCardSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tillbaka
                    ElevatedButton(
                      onPressed: widget.onBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor2,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Tillbaka',
                        style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                      ),
                    ),

                    // Nästa: inaktiverad tills giltigt
                    ElevatedButton(
                      onPressed: _canProceed
                          ? () {
                        // Spara i handler
                        final handler =
                        Provider.of<ImatDataHandler>(context, listen: false);
                        DateTime? dt;
                        if (_selectedOption == 'date' &&
                            _selectedDate != null &&
                            _selectedTime != null) {
                          dt = DateTime(
                            _selectedDate!.year,
                            _selectedDate!.month,
                            _selectedDate!.day,
                            _selectedTime!.hour,
                            _selectedTime!.minute,
                          );
                        }
                        handler.setDelivery(_selectedOption, dt);
                        widget.onNext();
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canProceed
                            ? AppTheme.buttonColor1
                            : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Nästa',
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
