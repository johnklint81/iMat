import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

import '../../app_theme.dart';

class CustomerInfo extends StatefulWidget {
  const CustomerInfo({super.key});

  @override
  State<CustomerInfo> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  bool _editing = false;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _addressController;
  late TextEditingController _postalController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    final customer = context.read<ImatDataHandler>().getCustomer();

    _firstNameController = TextEditingController(text: customer.firstName);
    _lastNameController = TextEditingController(text: customer.lastName);
    _addressController = TextEditingController(text: customer.address);
    _postalController = TextEditingController(text: customer.postCode);
    _cityController = TextEditingController(text: customer.postAddress);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _postalController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final updatedCustomer = context.read<ImatDataHandler>().getCustomer()
      ..firstName = _firstNameController.text
      ..lastName = _lastNameController.text
      ..address = _addressController.text
      ..postCode = _postalController.text
      ..postAddress = _cityController.text;

    await context.read<ImatDataHandler>().setCustomer(updatedCustomer);
    setState(() => _editing = false);
  }


  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(_editing ? Icons.check : Icons.edit),

              tooltip: _editing ? "Spara" : "Redigera",
              onPressed: () {
                if (_editing) {
                  _saveChanges();
                } else {
                  setState(() => _editing = true);
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildField(
            "Förnamn",
            _firstNameController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZåäöÅÄÖ]')),
            ],
          ),
          _buildField(
            "Efternamn",
            _lastNameController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZåäöÅÄÖ]')),
            ],
          ),
          _buildField(
            "Gatuadress",
            _addressController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZåäöÅÄÖ0-9 ]')),
            ],
          ),
          _buildField(
            "Postnummer",
            _postalController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
          ),
          _buildField(
            "Ort",
            _cityController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZåäöÅÄÖ]')),
            ],
          ),

        ],
      ),
    );
  }
  Widget _buildField(String label, TextEditingController controller, {List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        enabled: _editing,
        inputFormatters: inputFormatters,
        style: AppTheme.largeHeading,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.mediumLargeHeading,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }


}
