import 'package:flutter/material.dart';

class BankOffersModel {
  final String imageLink;
  final String? bankOffers;
  final Color? color;
  final Color? borderColor;

  BankOffersModel(
      {required this.imageLink, this.bankOffers, this.color, this.borderColor});
}
