import 'package:flutter/material.dart';
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
    _nameController = TextEditingController(text: customer.firstName + ' ' + customer.lastName);
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

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.mediumText),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            validator: (value) => value == null || value.isEmpty ? 'Fältet krävs' : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.all(12),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildField('Namn:', _nameController),
                      _buildField('Gatuadress:', _streetController),
                      _buildField('Postnummer:', _zipController),
                      _buildField('Stad:', _cityController),
                      _buildField('Telefonnummer:', _phoneController),
                    ],
                  ),
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
                      onPressed: _handleNext,
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
