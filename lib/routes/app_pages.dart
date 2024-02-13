import 'package:flutter_chat_craft/pages/chat/add_friend/add_friend_binding.dart';
import 'package:flutter_chat_craft/pages/chat/add_friend/add_friend_view.dart';
import 'package:flutter_chat_craft/pages/chat/chat/chat_binding.dart';
import 'package:flutter_chat_craft/pages/chat/chat/chat_view.dart';
import 'package:flutter_chat_craft/pages/chat/conversation_binding.dart';
import 'package:flutter_chat_craft/pages/chat/conversation_view.dart';
import 'package:flutter_chat_craft/pages/chat/new_chat/new_chat_binding.dart';
import 'package:flutter_chat_craft/pages/chat/new_chat/new_chat_view.dart';
import 'package:flutter_chat_craft/pages/common/check_code/check_code_binding.dart';
import 'package:flutter_chat_craft/pages/common/check_code/check_code_view.dart';
import 'package:flutter_chat_craft/pages/home/home_binding.dart';
import 'package:flutter_chat_craft/pages/home/home_view.dart';
import 'package:flutter_chat_craft/pages/login/invite/invite_binding.dart';
import 'package:flutter_chat_craft/pages/login/invite/invite_view.dart';
import 'package:flutter_chat_craft/pages/login/login_binding.dart';
import 'package:flutter_chat_craft/pages/login/login_email/login_email_binding.dart';
import 'package:flutter_chat_craft/pages/login/login_view.dart';
import 'package:flutter_chat_craft/pages/login/register/register_binding.dart';
import 'package:flutter_chat_craft/pages/login/register/register_view.dart';
import 'package:flutter_chat_craft/pages/mine/mine_story_details/mine_story_details_binding.dart';
import 'package:flutter_chat_craft/pages/mine/mine_story_details/mine_story_details_view.dart';
import 'package:flutter_chat_craft/pages/mine/profile/profile_binding.dart';
import 'package:flutter_chat_craft/pages/mine/profile/profile_view.dart';
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
    GetPage(
        name: AppRoutes.chat,
        transition: Transition.rightToLeft,
        page: () => ChatPage(),
        binding: ChatBinding()),
    // GetPage(
    //   name: AppRoutes.mine,
    //   transition: Transition.rightToLeft,
    //   page: () => MinePage(),
    //   binding: MineBinding(),
    // )
    GetPage(
        name: AppRoutes.mineStoryDetails,
        transition: Transition.topLevel,
        page: () => MineStoryDetailsPage(),
        binding: MineStoryDetailsBindings()),
    GetPage(
        name: AppRoutes.newChat,
        transition: Transition.rightToLeft,
        page: () => NewChatPage(),
        binding: NewChatBinding()),
    GetPage(
        name: AppRoutes.profile,
        transition: Transition.rightToLeft,
        page: () => ProfilePage(),
        binding: ProfileBinding()),
    GetPage(
        name: AppRoutes.invite,
        transition: Transition.rightToLeft,
        page: () => InvitePage(),
        binding: InviteBinding()),
  ];
}
