import 'package:flutter/material.dart';

import '../app_theme.dart';

class ShoppingCartWidget extends StatelessWidget {
  const ShoppingCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFFFFEECE),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Kundvagn',
              style: AppTheme.largeHeading,
            ),
          ),

          const SizedBox(height: 12),

          const Align(
            alignment: Alignment.topCenter,
            child: Icon(Icons.shopping_basket, size: 48, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            "Din kundvagn är tom.",
            style: AppTheme.mediumText,
          ),
          const SizedBox(height: 4),
          Text(
            "Lägg till varor genom att klicka på 'Välj'.",
            style: AppTheme.smallText.copyWith(color: Colors.grey),
          ),

          const Spacer(),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black12, width: 2),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Totalt:',
                  style: AppTheme.mediumHeading,
                ),
                Text(
                  '0.00 kr',
                  style: AppTheme.mediumHeading,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.paddingLarge),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(color: Colors.black12, width: 2),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                  "Gå till kassan",
                  style: AppTheme.mediumHeading),
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
        ],
      ),
    );
  }
}
