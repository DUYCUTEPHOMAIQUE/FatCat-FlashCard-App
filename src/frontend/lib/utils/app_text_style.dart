import 'package:FatCat/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle normalText = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle viewAllText = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static final categoryHomeText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static final boldText20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static final boldText28SigmarOne = TextStyle(
    fontFamily: 'SigmarOne',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  static final boldText28 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  static final boldText16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
}
