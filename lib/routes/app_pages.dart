import 'package:flutter_chat_craft/pages/chat/add_friend/add_friend_binding.dart';
import 'package:flutter_chat_craft/pages/chat/add_friend/add_friend_view.dart';
import 'package:flutter_chat_craft/pages/chat/conversation_binding.dart';
import 'package:flutter_chat_craft/pages/chat/conversation_view.dart';
import 'package:flutter_chat_craft/pages/common/check_code/check_code_binding.dart';
import 'package:flutter_chat_craft/pages/common/check_code/check_code_view.dart';
import 'package:flutter_chat_craft/pages/home/home_binding.dart';
import 'package:flutter_chat_craft/pages/home/home_view.dart';
import 'package:flutter_chat_craft/pages/login/login_binding.dart';
import 'package:flutter_chat_craft/pages/login/login_email/login_email_binding.dart';
import 'package:flutter_chat_craft/pages/login/login_view.dart';
import 'package:flutter_chat_craft/pages/login/register/register_binding.dart';
import 'package:flutter_chat_craft/pages/login/register/register_view.dart';
import 'package:flutter_chat_craft/pages/splash/splash_binding.dart';
import 'package:flutter_chat_craft/pages/splash/splash_view.dart';
import 'package:get/get.dart';

import '../pages/login/login_email/login_email_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(
        name: AppRoutes.splash,
        page: () => SplashPage(),
        binding: SplashBinding()),
    GetPage(
        name: AppRoutes.login,
        transition: Transition.rightToLeft,
        page: () => LoginPage(),
        binding: LoginBinding()),
    GetPage(
        name: AppRoutes.loginEmail,
        transition: Transition.rightToLeft,
        page: () => LoginEmailPage(),
        binding: LoginEmailBinding()),
    GetPage(
        name: AppRoutes.register,
        transition: Transition.rightToLeft,
        page: () => RegisterPage(),
        binding: RegisterBinding()),
    GetPage(
        name: AppRoutes.checkCode,
        transition: Transition.rightToLeft,
        page: () => CheckCodeView(),
        binding: CheckCodeBinding()),
    GetPage(
        name: AppRoutes.home,
        transition: Transition.fadeIn,
        page: () => HomePage(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.conversation,
        transition: Transition.fadeIn,
        page: () => ConversationPage(),
        binding: ConversationBinding()),
    GetPage(
        name: AppRoutes.addFriend,
        transition: Transition.rightToLeft,
        page: () => AddFriendPage(),
        binding: AddFriendBinding()),
  ];
}
