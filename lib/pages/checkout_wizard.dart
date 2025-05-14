import 'package:flutter/material.dart';
import 'package:imat_app/pages/wizard/checkout_step_cart.dart';
import 'package:imat_app/pages/wizard/wizard_progress_bar.dart';
import 'package:imat_app/pages/wizard/checkout_step_address.dart';
import 'package:imat_app/pages/wizard/checkout_step_delivery.dart';
import 'package:imat_app/pages/wizard/checkout_step_payment.dart';
import 'package:imat_app/pages/wizard/checkout_step_receipt.dart';
import '../app_theme.dart';
import '../widgets/custom_app_bar.dart';

class CheckoutWizard extends StatefulWidget {
  const CheckoutWizard({super.key});

  @override
  State<CheckoutWizard> createState() => _CheckoutWizardState();
}

class _CheckoutWizardState extends State<CheckoutWizard> {
  int _step = 0;
  String _paymentMethod = 'VISA/Mastercard'; // default

  void _nextStep() {
    setState(() {
      if (_step < 4) _step++;
    });
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
        centerWidget: Text(
          _getStepTitle(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        rightWidget: IconButton(
          icon: const Icon(Icons.person, size: AppTheme.paddingHuge),
          onPressed: () {
            // Pop all routes until the root (MainView)
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        onTitleTap: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
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
              child: IndexedStack(
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
