import 'package:flutter/cupertino.dart';

class ColorViewModel extends ChangeNotifier {
  bool isPurple = false;
  bool isGreen = false;
  bool isRed = false;
  bool isYellow = false;
  get getIsPurple => this.isPurple;

  set setIsPurple(isPurple) {
    this.isPurple = isPurple;
    notifyListeners();
  }

  get getIsGreen => this.isGreen;

  set setIsGreen(isGreen) {
    this.isGreen = isGreen;
    notifyListeners();
  }

  get getIsRed => this.isRed;

  set setIsRed(isRed) {
    this.isRed = isRed;
    notifyListeners();
  }

  get getIsYellow => this.isYellow;

  set setIsYellow(isYellow) {
    this.isYellow = isYellow;
    notifyListeners();
  }
}
