import 'package:flutter/material.dart';

class Restaurent1Model {
  final String imageLink;
  final String restaurentItemNameAndPrice;
  final IconData icon1;
  final String restaurentName;
  final String restaurentItemCategory;
  final IconData restaurentItemCategoryIcon;
  final String restaurentRating;
  final String restaurentDiscount;
  final String deliveryTiming;
  final String restaurentDistance;
  final String restaurentPrice;

  Restaurent1Model(
      {required this.imageLink,
      required this.restaurentItemNameAndPrice,
      required this.icon1,
      required this.restaurentName,
      required this.restaurentItemCategory,
      required this.restaurentItemCategoryIcon,
      required this.restaurentRating,
      required this.restaurentDiscount,
      required this.deliveryTiming,
      required this.restaurentDistance,
      required this.restaurentPrice});
}
