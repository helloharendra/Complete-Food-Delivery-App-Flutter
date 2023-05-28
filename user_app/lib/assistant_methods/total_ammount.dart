import 'package:flutter/material.dart';

class TotalAmmount extends ChangeNotifier {
 
 double _totalAmount=0;

  double get tAmmount=>_totalAmount;

  displayTotolAmmount(double number) async{
    _totalAmount=number;

    await Future.delayed(const Duration(microseconds: 100),(){
      notifyListeners();
    }
    
    );
  }

}
