import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/pages/chat/conversation_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../../../common/apis.dart';
import '../../../common/global_data.dart';
import '../../../im/im_utils.dart';
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
  IntervalDo intervalSendTypingMsg = IntervalDo();

  /// The status of message sending,
  /// there are two kinds of success or failure, true success, false failure
  StreamController<MsgStreamEv<bool>> msgSendStatusSubject =
      StreamController<MsgStreamEv<bool>>.broadcast();
  StreamController<MsgStreamEv<double>> msgProgressController =
      StreamController<MsgStreamEv<double>>.broadcast();

  ///Click on the message to process voice playback, video playback, picture preview, etc.
  StreamController<int> clickSubjectController =
      StreamController<int>.broadcast();
  int chatStart = 0;
  int chatEnd = 30;
  int chatListSize = 30;

  bool isShowToolsDialog = false;
  Timer? typingTimer;
  Rx<bool> typing = false.obs;

  Message? quoteMessage;
  Rx<String> quoteContent = "".obs;

  @override
  void onInit() {
    super.onInit();
    messageAddListen();
    // 自定义消息点击事件
    clickSubjectController.stream.listen((index) {
      if (kDebugMode) {
        print('index:$index');
      }
      // parseClickEvent(indexOfMessage(index, calculate: false));
    });
    inputListener();
  }

  @override
  void onClose() {
    super.onClose();
    textEditingController.dispose();
    scrollController.dispose();
    msgSendStatusSubject.close();
    msgProgressController.close();
    clickSubjectController.close();
  }

  void inputListener() {
    textEditingController.addListener(() {
      //There is text in the input box
      intervalSendTypingMsg.run(
        fuc: () => sendTypingMsg(focus: true),
        milliseconds: 2000,
      );
    });
    textFocusNode.addListener(() {
      //Lost input box focus
      if (!textFocusNode.hasFocus) {
        sendTypingMsg(focus: false);
      } else {
        sendTypingMsg(focus: true);
      }
    });
  }

  void messageAddListen() {
    conversationLogic.webSocketManager.listen((msg) {
      Message message = Message.fromJson(
        json.decode(msg),
      );
      if (kDebugMode) {
        print('Received: ${message.toString()}');
      }
      if (message.formId == userInfo.userID) {
        //Monitor input status
        if (message.msgId == typingId) {
          _typing(message);
        } else {
          // messageList.insert(0, message);
          messageList.removeWhere((element) => element.msgId == typingId);
          messageList.add(message);
          // if (message.contentType == MessageType.replyEmoji) {
          //   for (var element in messageList) {
          //     if (element.msgId == message.quoteMessage?.msgId) {
          //       element.replyEmojis?.add(message.content);
          //     }
          //   }
          // } else {
          // }
        }
      }
    }, onError: (error) {
      ToastUtils.toastText(error.toString());
    });
  }

  void _typing(Message message) {
    if (message.content == "yes") {
      // Other party is typing
      if (null == typingTimer) {
        typing.value = true;
        _addOrRemoveTypingMessageWidget(message, true);
        typingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
          // Cancel the timer in two seconds
          typing.value = false;
          _addOrRemoveTypingMessageWidget(message, false);
          typingTimer?.cancel();
          typingTimer = null;
        });
      }
    } else {
      // Stop typing
      typing.value = false;
      _addOrRemoveTypingMessageWidget(message, false);
      typingTimer?.cancel();
      typingTimer = null;
    }
  }

  void _addOrRemoveTypingMessageWidget(Message message, bool focus) {
    if (focus) {
      Iterable<Message> hasMessage =
          messageList.where((message) => message.msgId == typingId);
      if (hasMessage.isEmpty) {
        messageList.add(message);
      }
    } else {
      messageList.removeWhere((element) => element.msgId == typingId);
    }
    messageList.refresh();
  }

  /// Prompt the other party for the current user’s input status
  void sendTypingMsg({bool focus = false}) async {
    Message message = Message(
      msgId: typingId,
      targetId: userInfo.userID,
      type: ConversationType.single,
      formId: GlobalData.userInfo.userID,
      contentType: MessageType.typing,
      content: focus ? "yes" : "no",
      messageSenderName: GlobalData.userInfo.userName,
      messageSenderFaceUrl: GlobalData.userInfo.avatar,
    );
    _sendMessage(message, addToUI: false);
  }

  void _sendMessage(
    Message message, {
    int? userId,
    int? groupId,
    bool addToUI = true,
  }) {
    if (null == userId && null == groupId || userId == userInfo.userID) {
      if (addToUI) {
        // Do not need to add "Failed to repeat" to the UI.
        messageList.add(message);
        scrollBottom();
      }
      //send message
      conversationLogic.webSocketManager
          .sendMsg(message)
          .then((value) => _sendSucceeded(message, value))
          .catchError((e) => _sendFailed(message, e))
          .whenComplete(() => _sendCompleted(message));
      _reset(message);
    }
  }

  /// The logic after processing the message flow is completed.
  void _sendCompleted(Message message) {
    if (kDebugMode) {
      print("has completed");
    }
    if (message.contentType == MessageType.typing ||
        message.type == ConversationType.heart) {
    } else {
      messageList.refresh();
    }
  }

  /// Message sent successfully.
  void _sendSucceeded(Message oldMsg, Message newMsg) {
    if (kDebugMode) {
      print('message send success----');
    }
    // oldMsg.status = MessageStatus.succeeded;
    oldMsg.update(newMsg);
    if (kDebugMode) {
      print("oldMsg:${oldMsg.toString()}");
      print("newMsg:${newMsg.toString()}");
      print("identical:${identical(oldMsg, newMsg)}");
    }
    msgSendStatusSubject.sink.add(MsgStreamEv<bool>(
      msgId: oldMsg.msgId!,
      value: true,
    ));
  }

  /// Message sending failed.
  void _sendFailed(Message message, e) {
    if (kDebugMode) {
      print('message send failed e :$e');
    }
    message.status = MessageStatus.failed;
    msgSendStatusSubject.sink.add(MsgStreamEv<bool>(
      msgId: message.msgId!,
      value: false,
    ));
  }

  void _reset(Message message) {
    if (message.contentType == MessageType.text ||
        message.contentType == MessageType.atText ||
        message.contentType == MessageType.quote) {
      textEditingController.clear();
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
        if (kDebugMode) {
          print(message.toString());
        }
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
      if (kDebugMode) {
        print('--------assets type-----${assetEntity.type}');
      }
      var file = await assetEntity.file;
      var path = file!.path;
      var name = assetEntity.title ?? "";
      if (kDebugMode) {
        print('--------assets path-----$path');
      }
      switch (assetEntity.type) {
        case AssetType.image:
          //upload image
          sendPicture(imageFile: file, imageName: name);
          break;
        default:
          break;
      }
    }
  }

  void sendTextMessage() {
    var message = Message(
      msgId: generateMessageId(userInfo.userID),
      targetId: userInfo.userID,
      type: ConversationType.single,
      formId: GlobalData.userInfo.userID,
      contentType: MessageType.text,
      content: textEditingController.text,
      messageSenderName: GlobalData.userInfo.userName,
      messageSenderFaceUrl: GlobalData.userInfo.avatar,
      sendTime: DateTime.now().toString(),
      status: MessageStatus.sending,
    );
    if (quoteMessage != null) {
      message.quoteMessage = quoteMessage;
      message.contentType = MessageType.quote;
      quoteMessage = null;
      quoteContent.value = '';
    }
    _sendMessage(message);
  }

  void sendPicture({required File imageFile, required String imageName}) async {
    double imageWidth = 0.0;
    double imageHeight = 0.0;
    double fileSize = await imageFile.length() / (1024 * 1024);
    Image image = Image.file(imageFile);
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    Size imageSize = await completer.future;
    double width = 0.5.sw;
    double height = 0.25.sh;
    double actualWidth = imageSize.width;
    double actualHeight = imageSize.height;
    double scale = 1.0;
    if (actualWidth > width || actualHeight > height) {
      double widthScale = width / actualWidth;
      double heightScale = height / actualHeight;
      scale = widthScale < heightScale ? widthScale : heightScale;
    }
    width = actualWidth * scale;
    height = actualHeight * scale;
    imageWidth = width;
    imageHeight = height;
    if (kDebugMode) {
      print("imageWidth:$imageWidth");
      print("imageHeight:$imageHeight");
    }
    ImageElement imageElement = ImageElement(
      image: imageFile.path,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      fileSize: fileSize,
    );
    Message message = Message(
      msgId: generateMessageId(userInfo.userID),
      targetId: userInfo.userID,
      type: ConversationType.single,
      formId: GlobalData.userInfo.userID,
      contentType: MessageType.picture,
      content: imageFile.path,
      messageSenderName: GlobalData.userInfo.userName,
      messageSenderFaceUrl: GlobalData.userInfo.avatar,
      image: imageElement,
      sendTime: DateTime.now().toString(),
      status: MessageStatus.sending,
    );
    if (kDebugMode) {
      print("imagePath:${imageFile.path}");
    }
    var data = await Apis.uploadFile(
      filePath: imageFile.path,
      fileName: imageName,
      fileType: MessageType.picture,
      onSendProgress: (int sent, int total) {
        msgProgressController.sink.add(
          MsgStreamEv(
            msgId: message.msgId!,
            value: sent / total * 100,
          ),
        );
        if (kDebugMode) {
          print('Upload progress：${sent / total * 100}%');
        }
      },
    );
    if (data != false) {
      ImageElement imageElement = ImageElement(
        image: data,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        fileSize: fileSize,
      );
      message = Message(
        msgId: generateMessageId(userInfo.userID),
        targetId: userInfo.userID,
        type: ConversationType.single,
        formId: GlobalData.userInfo.userID,
        contentType: MessageType.picture,
        content: data,
        messageSenderName: GlobalData.userInfo.userName,
        messageSenderFaceUrl: GlobalData.userInfo.avatar,
        image: imageElement,
        sendTime: DateTime.now().toString(),
        status: MessageStatus.sending,
      );
    }
    _sendMessage(message);
  }

  ///send vocie
  void sendVoice({
    required int duration,
    required String path,
    required int fileSize,
  }) async {
    double fileSizeInMB = fileSize / (1024 * 1024);
    if (kDebugMode) {
      print("duration$duration,path:$path,fileSize:$fileSizeInMB");
    }
    Message message = Message(
      msgId: generateMessageId(userInfo.userID),
      targetId: userInfo.userID,
      type: ConversationType.single,
      formId: GlobalData.userInfo.userID,
      contentType: MessageType.voice,
      content: path,
      messageSenderName: GlobalData.userInfo.userName,
      messageSenderFaceUrl: GlobalData.userInfo.avatar,
      sendTime: DateTime.now().toString(),
      sound: SoundElement(
        sourceUrl: "",
        soundPath: path,
        dataSize: fileSizeInMB,
        duration: duration,
      ),
      status: MessageStatus.sending,
    );
    if (kDebugMode) {
      print("voicePath:$path");
    }
    var data = await Apis.uploadFile(
      filePath: path,
      fileName: path.split('/').last,
      fileType: MessageType.voice,
      onSendProgress: (int sent, int total) {
        msgProgressController.sink.add(MsgStreamEv(
          msgId: message.msgId!,
          value: sent / total * 100,
        ));
        if (kDebugMode) {
          print('Upload progress：${sent / total * 100}%');
        }
      },
    );
    if (data != false) {
      message = Message(
        msgId: generateMessageId(userInfo.userID),
        targetId: userInfo.userID,
        type: ConversationType.single,
        formId: GlobalData.userInfo.userID,
        contentType: MessageType.voice,
        content: data,
        messageSenderName: GlobalData.userInfo.userName,
        messageSenderFaceUrl: GlobalData.userInfo.avatar,
        sendTime: DateTime.now().toString(),
        sound: SoundElement(
          sourceUrl: data,
          soundPath: path,
          dataSize: fileSizeInMB,
          duration: duration,
        ),
        status: MessageStatus.sending,
      );
    }
    _sendMessage(message);
  }

  void onTapReplyMenu(Message? message) {
    if (message == null) {
      quoteMessage = null;
      quoteContent.value = '';
    } else {
      quoteMessage = message;
      var name = message.messageSenderName;
      quoteContent.value = "$name：${IMUtils.messageTypeToString(
        messageType: message.contentType!,
        content: message.content,
      )}";
      textFocusNode.requestFocus();
    }
  }

  void onReplyEmoji(String value, Message message) {
    message.replyEmojis?.add(value);
    // message.contentType = MessageType.updateEmoji;
    // Message msg = Message(
    //   msgId: generateMessageId(userInfo.userID),
    //   targetId: userInfo.userID,
    //   type: ConversationType.single,
    //   formId: GlobalData.userInfo.userID,
    //   contentType: MessageType.replyEmoji,
    //   // contentType: MessageType.updateEmoji,
    //   content: value,
    //   quoteMessage: message,
    //   messageSenderName: GlobalData.userInfo.userName,
    //   messageSenderFaceUrl: GlobalData.userInfo.avatar,
    // );
    _sendMessage(message, addToUI: false);
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
