import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/pages/chat/conversation_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../../common/apis.dart';
import '../../../common/global_data.dart';
import '../../../widget/toast_utils.dart';
import 'widget/chat_item_view.dart';
import 'widget/interactive_dialog/interactive_dialog.dart';

class ChatLogic extends GetxController {
  final conversationLogic = Get.find<ConversationLogic>();
  int? groupId = Get.arguments["groupId"];
  UserInfo userInfo = Get.arguments["userInfo"];
  TextEditingController textEditingController = TextEditingController();
  FocusNode textFocusNode = FocusNode();
  RxList<Message> messageList = <Message>[].obs;
  ScrollController scrollController = ScrollController();

  /// The status of message sending,
  /// there are two kinds of success or failure, true success, false failure
  StreamController<MsgStreamEv<bool>> msgSendStatusSubject =
      StreamController<MsgStreamEv<bool>>.broadcast();
  StreamController<MsgStreamEv<double>> msgProgressController =
      StreamController<MsgStreamEv<double>>.broadcast();
  int chatStart = 0;
  int chatEnd = 30;
  int chatListSize = 30;

  bool isShowToolsDialog = false;

  @override
  void onInit() {
    super.onInit();
    messageAddListen();
  }

  @override
  void onClose() {
    super.onClose();
    textEditingController.dispose();
    scrollController.dispose();
    msgSendStatusSubject.close();
    msgProgressController.close();
  }

  void messageAddListen() {
    conversationLogic.webSocketManager.listen((msg) {
      //Add message to the list.
      Message message = Message.fromJson(
        json.decode(msg),
      );
      print('Received: ${message.toString()}');
      if (message.formId == userInfo.userID) {
        // messageList.insert(0, message);
        messageList.add(message);
      }
    }, onError: (error) {
      ToastUtils.toastText(error.toString());
    });
  }

  void sendMessage() {
    if (textEditingController.text.isEmpty) {
      ToastUtils.toastText("");
      return;
    }
    var message = Message(
      msgId: generateMessageId(userInfo.userID),
      targetId: userInfo.userID,
      type: ConversationType.single,
      formId: GlobalData.userInfo.userID,
      contentType: MessageType.text,
      content: textEditingController.text,
      sendTime: DateTime.now().toString(),
    );
    bool isSendSuccess =
        conversationLogic.webSocketManager.sendMsg(message.toJsonString());
    if (isSendSuccess) {
      // messageList.insert(0, message);
      messageList.add(message);
      textEditingController.clear();
      scrollBottom();
    }
  }

  Future<bool> getHistoryMsgList() async {
    var data = await Apis.getRedisMsg(
      targetId: userInfo.userID,
      start: chatStart,
      end: chatEnd,
      isRev: true,
    );
    if (data == false) {
      return false;
    } else {
      for (var info in data) {
        Message message = Message.fromJson(json.decode(info));
        messageList.add(message);
        print(message.toString());
      }
      chatStart = chatEnd;
      chatEnd += chatListSize;
      update(["chatList"]);
    }
    return false;
  }

  void scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void showToolsDialog(BuildContext context) {
    isShowToolsDialog = true;
    showDialog(
      context: context,
      barrierColor: const Color(0x573D3D3D),
      builder: (BuildContext context) {
        return InteractiveDialog(
          height: 290.w,
          openCamera: () => onTapCamera(),
          openPhotoAlbum: () => onTapAlbum(),
        );
      },
    ).then((value) {
      isShowToolsDialog = false;
    });
  }

  /// Open the album
  void onTapAlbum() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      Get.context!,
    ).whenComplete(() {
      Get.back();
    });
    if (null != assets) {
      for (var asset in assets) {
        handleAssets(asset);
      }
    }
  }

  /// Turn on the camera
  void onTapCamera() async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      Get.context!,
      pickerConfig: const CameraPickerConfig(
        enableAudio: true,
        enableRecording: true,
      ),
    ).whenComplete(() {
      Get.back();
    });
    handleAssets(entity);
  }

  void handleAssets(AssetEntity? assetEntity) async {
    if (assetEntity != null) {
      print('--------assets type-----${assetEntity.type}');
      var file = await assetEntity.file;
      var path = file!.path;
      var name = assetEntity.title ?? "";
      print('--------assets path-----$path');
      switch (assetEntity.type) {
        case AssetType.image:
          //upload image
          sendPicture(imagePath: path, imageName: name);
          break;
        default:
          break;
      }
    }
  }

  void sendPicture(
      {required String imagePath, required String imageName}) async {
    Message message = Message(
      msgId: generateMessageId(userInfo.userID),
      targetId: userInfo.userID,
      type: ConversationType.single,
      formId: GlobalData.userInfo.userID,
      contentType: MessageType.picture,
      content: imagePath,
      sendTime: DateTime.now().toString(),
    );
    print("imagePath:$imagePath");
    messageList.add(message);
    scrollBottom();
    var data = await Apis.uploadFile(
      filePath: imagePath,
      fileName: imageName,
      fileType: MessageType.picture,
      onSendProgress: (int sent, int total) {
        msgProgressController.sink.add(MsgStreamEv(
          msgId: message.msgId!,
          value: sent / total * 100,
        ));
        print('上传进度：${sent / total * 100}%');
      },
    );
    if (data != false) {
      var message = Message(
        msgId: generateMessageId(userInfo.userID),
        targetId: userInfo.userID,
        type: ConversationType.single,
        formId: GlobalData.userInfo.userID,
        contentType: MessageType.picture,
        content: data,
      );
      bool isSendSuccess =
          conversationLogic.webSocketManager.sendMsg(message.toJsonString());
      if (isSendSuccess) {
        // image upload success
      }
    }
  }

  ///send vocie
  void sendVoice({required int duration, required String path}) async {
    print("duration${duration},path:${path}");
    Message message = Message(
      msgId: generateMessageId(userInfo.userID),
      targetId: userInfo.userID,
      type: ConversationType.single,
      formId: GlobalData.userInfo.userID,
      contentType: MessageType.voice,
      content: path,
      sendTime: DateTime.now().toString(),
      sound: SoundElem(
        sourceUrl: "",
        soundPath: path,
        dataSize: 0,
        duration: duration,
      ),
    );
    print("voicePath:$path");
    messageList.add(message);
    scrollBottom();
    var data = await Apis.uploadFile(
      filePath: path,
      fileName: path.split('/').last,
      fileType: MessageType.voice,
      onSendProgress: (int sent, int total) {
        msgProgressController.sink.add(MsgStreamEv(
          msgId: message.msgId!,
          value: sent / total * 100,
        ));
        print('上传进度：${sent / total * 100}%');
      },
    );
    if (data != false) {
      Message message = Message(
        msgId: generateMessageId(userInfo.userID),
        targetId: userInfo.userID,
        type: ConversationType.single,
        formId: GlobalData.userInfo.userID,
        contentType: MessageType.voice,
        content: path,
        sendTime: DateTime.now().toString(),
        sound: SoundElem(
          sourceUrl: "",
          soundPath: path,
          dataSize: 0,
          duration: duration,
        ),
      );
      bool isSendSuccess =
          conversationLogic.webSocketManager.sendMsg(message.toJsonString());
      if (isSendSuccess) {
        // image upload success
      }
    }
  }

  Message indexOfMessage(
    int index,
  ) =>
      messageList.reversed.elementAt(index);

  String generateMessageId(int targetUserId) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    return '$currentTime-${GlobalData.userInfo.userID}-$targetUserId';
  }
}
