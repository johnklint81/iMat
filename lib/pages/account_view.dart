import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/pages/account_views/customer_info.dart';
import 'package:imat_app/pages/account_views/orders.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  int selectedIndex = 0;
  final List<String> tabs = [
    'Kunduppgifter',
    'Ordrar',
    'Returer',
    'Bevakningar'
  ];

  @override
  Widget build(BuildContext context) {
    final name = context
        .read<ImatDataHandler>()
        .getCustomer()
        .firstName;

    Widget content;
    switch (selectedIndex) {
      case 0:
        content = const CustomerInfo();
        break;
      case 1:
        content = const Orders();
        break;
      default:
        content = Text(
          "Innehåll för '${tabs[selectedIndex]}'",
          style: AppTheme.mediumText,
        );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top greeting
              Text(
                "Hi $name",
                style: AppTheme.VLARGEHeading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.paddingMedium),

              // Top buttons
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                children: List.generate(tabs.length, (index) {
                  final selected = index == selectedIndex;
                  return ElevatedButton(
                    onPressed: () => setState(() => selectedIndex = index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selected ? AppTheme.buttonColor1 : Colors
                          .white,
                      foregroundColor: selected ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppTheme.borderColor),
                      ),
                    ),
                    child: Text(tabs[index], style: AppTheme.largeHeading),
                  );
                }),
              ),

              const SizedBox(height: AppTheme.paddingLarge),

              // Frame with tab content
              Container(
                width: AppTheme.accountViewSize,
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
                child: content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}