import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TranslationHelper {
  TranslationHelper._();

  static getDeviceLanguages(BuildContext context) {
    var deviceLanguages = context.deviceLocale.countryCode!.toLowerCase();
    switch (deviceLanguages) {
      case "tr":
        return LocaleType.tr;
      case "en":
        return LocaleType.en;
    }
    
  }
}
