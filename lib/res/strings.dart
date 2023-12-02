import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lang/en_US.dart';
import 'lang/zh_CN.dart';

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static const fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'zh_CN': zh_CN,
      };
}

class StrRes {
  static get welcomeUse => 'welcomeUse'.tr;

  static get welcomeUseContent => 'welcomeUseContent'.tr;

  static get contactMe => 'contactMe'.tr;

  static get enterChatCraft => 'enterChatCraft'.tr;

  static get login => 'login'.tr;

  static get loginContent => 'loginContent'.tr;

  static get username => 'username'.tr;

  static get usernameInputHintText => 'usernameInputHintText'.tr;

  static get password => 'password'.tr;

  static get passwordInputHintText => 'passwordInputHintText'.tr;

  static get forgetPassword => "forgetPassword".tr;

  static get loginContinue => "loginContinue".tr;

  static get loginWithEmail => "loginWithEmail".tr;

  static get havenNotRegistered => "havenNotRegistered".tr;

  static get register => "register".tr;

  static get email => "email".tr;

  static get emailInputHintText => 'emailInputHintText'.tr;

  static get haveAccount => 'haveAccount'.tr;

  static get createAccount => 'createAccount'.tr;

  static get confirmPasswordInputHintText => 'confirmPasswordInputHintText'.tr;

  static get confirmPassword => 'confirmPassword'.tr;

  static get termsService => 'termsService'.tr;

  static get networkException => 'networkException'.tr;

  static get loginError => "loginError".tr;

  static get inputEmptyReminder => 'inputEmptyReminder'.tr;

  static get loginSuccess => 'loginSuccess'.tr;

  static get sendCode => 'sendCode'.tr;

  static get sendCodeSuccess => 'sendCodeSuccess'.tr;

  static get sendCodeError => 'sendCodeError'.tr;

  static get confirmYourNumber => 'confirmYourNumber'.tr;

  static get confirmYourNumberHint => 'confirmYourNumberHint'.tr;

  static get sendCodeAgain => 'sendCodeAgain'.tr;

  static get checkCodeError => 'checkCodeError'.tr;

  static get checkCodeSuccess => 'checkCodeSuccess'.tr;

  static get usernameRegistrationRules => 'usernameRegistrationRules'.tr;

  static get passwordRegistrationRules => 'passwordRegistrationRules'.tr;

  static get newChat => 'newChat'.tr;

  static get cancel => 'cancel'.tr;
}
