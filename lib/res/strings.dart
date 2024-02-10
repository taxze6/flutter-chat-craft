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
  static get chatCraft => 'chatCraft'.tr;

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

  static get newChatContent => 'newChatContent'.tr;

  static get cancel => 'cancel'.tr;

  static get newGroup => 'newGroup'.tr;

  static get newGroupContent => 'newGroupContent'.tr;

  static get newContact => 'newContact'.tr;

  static get newContactContent => 'newContactContent'.tr;

  static get addFriend => 'addFriend'.tr;

  static get searchAddFriendInputHint => 'searchAddFriendInputHint'.tr;

  static get shareAdd => 'shareAdd'.tr;

  static get scan => 'scan'.tr;

  static get userNotFound => "userNotFound".tr;

  static get canNotAddSelf => "canNotAddSelf".tr;

  static get addSuccess => 'addSuccess'.tr;

  static get chats => 'chats'.tr;

  static get remove => 'remove'.tr;

  static get top => 'top'.tr;

  static get cancelTop => 'cancelTop'.tr;

  static get picture => 'picture'.tr;

  static get video => 'video'.tr;

  static get voice => 'voice'.tr;

  static get online => 'online'.tr;

  static get offline => 'offline'.tr;

  static get send => 'send'.tr;

  static get promotionalCardText => 'promotionalCardText'.tr;

  static get meMe => 'meMe'.tr;

  static get function => 'function'.tr;

  static get myProfile => 'myProfile'.tr;

  static get sendMessage => 'sendMessage'.tr;

  static get audio => 'audio'.tr;

  static get story => 'story'.tr;

  static get viewAllStory => 'viewAllStory'.tr;

  static get preferences => 'preferences'.tr;

  static get noStory => 'noStory'.tr;

  static get friendSetting => 'friendSetting'.tr;

  static get shareApp => 'shareApp'.tr;

  static get reply => 'reply'.tr;

  static get storyCommentHintText => 'storyCommentHintText'.tr;

  static get operationFailed => 'operationFailed'.tr;

  static get operationSuccessful => 'operationSuccessful'.tr;

  static get pressSpeak => 'pressSpeak'.tr;

  static get releaseSend => 'releaseSend'.tr;

  static get convertFailTips => 'convertFailTips'.tr;

  static get cancelVoiceSend => 'cancelVoiceSend'.tr;

  static get confirmVoiceSend => 'confirmVoiceSend'.tr;

  static get soundToWord => 'soundToWord'.tr;

  static get releaseCancel => 'releaseCancel'.tr;

  static get converting => 'converting'.tr;

  static get friendListIsEmpty => 'friendListIsEmpty'.tr;

  static get notImageData => 'notImageData'.tr;

  static get privateChat => 'privateChat'.tr;

  static get groupChat => 'groupChat'.tr;

  static get massSend => 'massSend'.tr;

  static get notImplemented => 'notImplemented'.tr;

  static get collect => 'collect'.tr;

  static get logout => 'logout'.tr;

  static get profile => 'profile'.tr;

  static get avatar => 'avatar'.tr;

  static get motto => 'motto'.tr;

  static get nickname => 'nickname'.tr;

  static get phone => 'phone'.tr;

  static get save => 'save'.tr;

  static get saveSuccess => 'saveSuccess'.tr;

  static get saveFailed => 'saveFailed'.tr;

  static get camera => 'camera'.tr;

  static get album => 'album'.tr;

  static get settingMotto => 'settingMotto'.tr;

  static get enterMotto => 'enterMotto'.tr;

  static get settingEmail => 'settingEmail'.tr;

  static get enterEmail => 'enterEmail'.tr;

  static get settingPhone => 'settingPhone'.tr;

  static get enterPhone => 'enterPhone'.tr;

  static get settingNickname => 'settingNickname'.tr;

  static get enterNickname => 'enterNickname'.tr;

  static get settingPassword => 'settingPassword'.tr;

  static get enterCurrentPassword => 'enterCurrentPassword'.tr;

  static get enterNewPassword => 'enterNewPassword'.tr;

  static get enterRepeatPassword => 'enterRepeatPassword'.tr;

  static get passwordNotEqual => 'passwordNotEqual'.tr;

  static get confirm => 'confirm'.tr;

  static get maxInput => 'maxInput'.tr;

  static get word => 'word'.tr;

  static get copy => 'copy'.tr;

  static get forward => 'forward'.tr;
}
