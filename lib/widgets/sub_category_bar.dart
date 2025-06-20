import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class SubcategoryBar extends StatelessWidget {
  final List<String> subcategories;
  final void Function(String subcategory) onTap;
  final VoidCallback onShowAll;
  final String? selectedSubcategory;

  const SubcategoryBar({
    super.key,
    required this.subcategories,
    required this.onTap,
    required this.onShowAll,
    this.selectedSubcategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Wrap(
        spacing: 12,
        runSpacing: 0,
        children: [
          ...subcategories.map((sub) {
            final isSelected = sub == selectedSubcategory;
            return ElevatedButton(
              onPressed: () => onTap(sub),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? AppTheme.buttonColor2 : Colors.white,
                foregroundColor: isSelected ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                side: const BorderSide(color: AppTheme.borderColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: Text(
                sub,
                style: AppTheme.mediumLargeHeading,
              ),
            );
          }),
          ElevatedButton(
            onPressed: onShowAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedSubcategory == null ? AppTheme.buttonColor2 : Colors.white,
              foregroundColor: selectedSubcategory == null ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              side: const BorderSide(color: AppTheme.borderColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text("Alla underkategorier", style: AppTheme.mediumLargeHeading),
          ),
        ],
      ),
    );
  }
}
