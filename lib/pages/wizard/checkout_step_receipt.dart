import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import '../../model/imat/shopping_item.dart';
import '../../widgets/wizard_receipt_item_card.dart';

class CheckoutStepReceipt extends StatelessWidget {
  final VoidCallback onDone;
  final String paymentMethod;
  final List<ShoppingItem> receiptItems;
  final double total;

  const CheckoutStepReceipt({
    required this.onDone,
    required this.paymentMethod,
    required this.receiptItems,
    required this.total,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    final deliveryOption = handler.deliveryOption;
    final deliveryTime = handler.deliveryDate ?? DateTime.now().add(const Duration(hours: 2));

    String deliveryMethodLabel;
    switch (deliveryOption) {
      case 'date':
        deliveryMethodLabel = 'På ett specifikt datum';
        break;
      case 'asap':
        deliveryMethodLabel = 'Så fort som möjligt';
        break;
      case 'pickup':
        deliveryMethodLabel = 'Hämta vid utlämning';
        break;
      default:
        deliveryMethodLabel = 'Okänt';
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: AppTheme.paddingSmall),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: AppTheme.wizardCardSize,
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Tack för din beställning!",
                            style: AppTheme.LARGEHeading,
                          ),
                        ),
                        const SizedBox(height: AppTheme.paddingMediumSmall),

                        // Info-ruta
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: Column(
                            children: [
                              _buildStripedInfoRow("Betalningsmetod:", _formatPaymentLabel(paymentMethod), 0),
                              _buildStripedInfoRow("Leveranssätt:", deliveryMethodLabel, 1),
                              _buildStripedInfoRow("Beräknat leveransdatum:", _formatDeliveryDate(deliveryTime), 2),
                              _buildStripedInfoRow("Beräknad leveranstid:", _formatDeliveryTime(deliveryTime), 3),
                              _buildStripedInfoRow("Totalt:", "${total.toStringAsFixed(2)} kr", 4),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppTheme.paddingHuge),

                        // Produktlista
                        Column(
                          children: receiptItems
                              .map((item) => WizardReceiptItemCard(item))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fast knapp längst ner
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.paddingMediumSmall, top: 8),
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.buttonColor2,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                "Till startsidan",
                style: AppTheme.largeHeading.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPaymentLabel(String key) {
    return {
      'card': 'VISA/Mastercard',
      'swish': 'Swish',
      'invoice': 'Faktura',
      'klarna': 'Klarna',
      'qliro': 'Qliro',
    }[key] ?? 'Okänt';
  }

  String _formatDeliveryDate(DateTime dt) {
    return "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  String _formatDeliveryTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildStripedInfoRow(String label, String value, int index) {
    final isEven = index % 2 == 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: isEven ? Colors.grey.shade100 : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.mediumLargeText),
          Text(value, style: AppTheme.mediumLargeText),
        ],
      ),
    );
  }
}
