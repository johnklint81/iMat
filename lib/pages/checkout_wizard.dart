import 'package:flutter/material.dart';
import 'package:imat_app/pages/wizard/checkout_step_cart.dart';
import 'package:imat_app/pages/wizard/wizard_progress_bar.dart';
import 'package:imat_app/pages/wizard/checkout_step_address.dart';
import 'package:imat_app/pages/wizard/checkout_step_delivery.dart';
import 'package:imat_app/pages/wizard/checkout_step_payment.dart';
import 'package:imat_app/pages/wizard/checkout_step_receipt.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../model/imat_data_handler.dart';
import '../widgets/account_view.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/account_button.dart';

class CheckoutWizard extends StatefulWidget {
  const CheckoutWizard({super.key});

  @override
  State<CheckoutWizard> createState() => _CheckoutWizardState();
}

class _CheckoutWizardState extends State<CheckoutWizard> {
  bool showAccount = false;
  int _step = 0;
  String _paymentMethod = 'VISA/Mastercard'; // default

  void _nextStep() {
    setState(() {
      if (_step < 4) _step++;
    });
  }
  double getTotalAmount() {
    final cart = context.read<ImatDataHandler>().getShoppingCart();
    return cart.items.fold<double>(
      0.0,
          (sum, item) => sum + item.total,
    );
  }

  void _previousStep() {
    setState(() {
      if (_step > 0) _step--;
    });
  }
  String _getStepTitle() {
    switch (_step) {
      case 0: return "Kundvagn";
      case 1: return "Adress";
      case 2: return "Leverans";
      case 3: return "Betalning";
      case 4: return "Kvitto";
      default: return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          centerWidget: Center(
            child: Text(
              _getStepTitle(),
              style: AppTheme.LARGEHeading,
            ),
          ),

          rightWidget: AccountButton(
          isActive: showAccount,
          onPressed: () {
            setState(() {
              showAccount = !showAccount;
            });
          },
        ),

          onTitleTap: () {
            setState(() {
              showAccount = false;
            });
            final iMat = Provider.of<ImatDataHandler>(context, listen: false);
            iMat.selectAllProducts();

            // Navigate back to the main view
            Navigator.of(context).popUntil((route) => route.isFirst);
          }

      ),


      body: Container(
        color: AppTheme.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Step Indicator Row
            const SizedBox(height: 12),
            WizardStepIndicator(currentStep: _step),
            const SizedBox(height: 16),
            const SizedBox(height: 16),

            // Step content
            Expanded(
              child: showAccount
                  ? const AccountView()
                  : IndexedStack(
                index: _step,
                children: [
                  CheckoutStepCart(
                    onNext: _nextStep,
                    onCancel: () => Navigator.pop(context),
                  ),
                  CheckoutStepAddress(
                    onNext: _nextStep,
                    onBack: _previousStep,
                  ),
                  CheckoutStepDelivery(
                    onNext: _nextStep,
                    onBack: _previousStep,
                  ),
                  CheckoutStepPayment(
                    onNext: _nextStep,
                    onBack: _previousStep,
                    onSelectedMethod: (methodKey) {
                      setState(() {
                        _paymentMethod = {
                          'card': 'VISA/Mastercard',
                          'swish': 'Swish',
                          'invoice': 'Faktura',
                          'klarna': 'Klarna',
                          'qliro': 'Qliro',
                        }[methodKey]!;
                      });
                    },
                    totalAmount: getTotalAmount(),
                  ),
                  CheckoutStepReceipt(
                    onDone: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    paymentMethod: _paymentMethod,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),

    );
  }
}
