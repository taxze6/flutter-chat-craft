import 'package:get/get.dart';

class InviteState {
  late String name;
  late String email;

  String? avatar;
  String? motto;
  String? phone;

  InviteState() {
    name = Get.arguments['name'];
    email = Get.arguments['email'];
  }
}
