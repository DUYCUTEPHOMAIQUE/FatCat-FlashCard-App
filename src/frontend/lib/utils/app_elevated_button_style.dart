import 'package:FatCat/constants/colors.dart';
import 'package:flutter/material.dart';

class AppElevatedButtonStyles {
  static final categoryHome = ElevatedButton.styleFrom(
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    side: BorderSide(
      color: AppColors.borderCard.withOpacity(0.25),
      width: 2,
    ),
  );
}
