import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/app_theme.dart';

class CheckoutStepAddress extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CheckoutStepAddress({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<CheckoutStepAddress> createState() => _CheckoutStepAddressState();
}

class _CheckoutStepAddressState extends State<CheckoutStepAddress> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _streetController;
  late TextEditingController _zipController;
  late TextEditingController _cityController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final customer = context.read<ImatDataHandler>().getCustomer();
    _nameController = TextEditingController(text: '${customer.firstName} ${customer.lastName}');
    _streetController = TextEditingController(text: customer.address);
    _zipController = TextEditingController(text: customer.postCode);
    _cityController = TextEditingController(text: customer.postAddress);
    _phoneController = TextEditingController(text: customer.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      final handler = context.read<ImatDataHandler>();
      final nameParts = _nameController.text.trim().split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      handler.setCustomer(
        Customer(
          firstName,
          lastName,
          _phoneController.text.trim(),
          '', // mobilePhone
          '', // email
          _streetController.text.trim(),
          _zipController.text.trim(),
          _cityController.text.trim(),
        ),
      );
      widget.onNext();
    }
  }

  Widget _buildField(String label, TextEditingController controller,
      {List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.largeHeading),
          TextFormField(
            controller: controller,
            validator: (value) => value == null || value.isEmpty ? 'Fältet krävs' : null,
            inputFormatters: inputFormatters,
            textInputAction: TextInputAction.next,
            style: AppTheme.largeText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
          ),
        ],
      ),
    );
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
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 700, // justera vid behov
                ),
                child: SingleChildScrollView(
                  child: Container(
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
                    child: Form(
                      key: _formKey,
                      child: FocusTraversalGroup(
                        child: Column(
                          children: [
                            _buildField(
                              'Namn:',
                              _nameController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZåäöÅÄÖ ]')),
                              ],
                            ),
                            _buildField(
                              'Gatuadress:',
                              _streetController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZåäöÅÄÖ0-9 ]')),
                              ],
                            ),
                            _buildField(
                              'Postnummer:',
                              _zipController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(5),
                              ],
                            ),
                            _buildField(
                              'Ort:',
                              _cityController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZåäöÅÄÖ ]')),
                              ],
                            ),
                            _buildField(
                              'Telefonnummer:',
                              _phoneController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(15),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.paddingMedium),
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
                        style: AppTheme.largeHeading.copyWith(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _handleNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor1,
                      ),
                      child: Text(
                        'Nästa',
                        style: AppTheme.largeHeading.copyWith(color: Colors.white),
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
