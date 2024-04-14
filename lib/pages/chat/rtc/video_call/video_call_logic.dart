import 'package:get/get.dart';

enum VideoAction {
  cancel,
  connect,
}
enum SignalingState {
  connectionOpen,
  connectionClosed,
  connectionError,
}

enum CallState {
  callStateNew,
  callStateRinging,
  callStateInvite,
  callStateConnected,
  callStateBye,
}

enum VideoSource {
  camera,
  screen,
}


class VideoCallLogic extends GetxController {

}
