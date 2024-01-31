import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/apis.dart';
import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/pages/mine/profile/widget/password_dialog.dart';
import 'package:flutter_chat_craft/pages/mine/profile/widget/setting_dialog.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/widget/loading_view.dart';
import 'package:flutter_chat_craft/widget/toast_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'profile_state.dart';

class ProfileLogic extends GetxController {
  final ProfileState state = ProfileState();

  void modifyAvatar() async {
    showMaterialModalBottomSheet(
      expand: false,
      context: Get.context!,
      backgroundColor: Colors.transparent,
      builder: (context) => Material(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Center(
                  child: Text(
                    StrRes.camera,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                onTap: onTapCamera,
              ),
              ListTile(
                title: Center(
                  child: Text(
                    StrRes.album,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                onTap: onTapAlbum,
              ),
              const Divider(
                color: Color(0xFFEFEFEF),
              ),
              ListTile(
                title: Center(
                  child: Text(
                    StrRes.cancel,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
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
          uploadPicture(imageFile: file, imageName: name);
          break;
        default:
          break;
      }
    }
  }

  void uploadPicture({required File imageFile, required String imageName}) async {
    ///todo 这里需要一个loading遮罩
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
    var data = await Apis.uploadFile(
      filePath: imageFile.path,
      fileName: imageName,
      fileType: MessageType.picture,
      onSendProgress: (int sent, int total) {},
    );
    ///todo 解除loading遮罩
    if (data != false) {
      state.userInfo.avatar = data;
      update(['avatar']);
    }
  }

  void modifyMotto() {
    Get.dialog(
      SettingDialog(
        title: StrRes.settingMotto,
        hint: StrRes.enterMotto,
        inputDataType: InputDataType.motto,
        value: state.userInfo.motto,
        onConfirm: (value) async {
          state.userInfo.motto = value;
          update(['motto']);
        },
      ),
    );
  }

  void modifyPhone() {
    Get.dialog(
      SettingDialog(
        title: StrRes.settingPhone,
        hint: StrRes.enterPhone,
        inputDataType: InputDataType.phone,
        value: state.userInfo.phone,
        onConfirm: (value) async {
          state.userInfo.phone = value;
          update(['phone']);
        },
      ),
    );
  }

  void modifyEmail() {
    Get.dialog(
      SettingDialog(
        title: StrRes.settingEmail,
        hint: StrRes.enterEmail,
        inputDataType: InputDataType.email,
        value: state.userInfo.email,
        onConfirm: (value) async {
          state.userInfo.email = value;
          update(['email']);
        },
      ),
    );
  }

  void modifyNickname() {
    Get.dialog(
      SettingDialog(
        title: StrRes.settingNickname,
        hint: StrRes.enterNickname,
        inputDataType: InputDataType.nickname,
        value: state.userInfo.userName,
        onConfirm: (value) async {
          state.userInfo.userName = value;
          update(['nickname']);
        },
      ),
    );
  }

  void modifyPassword() {
    Get.dialog(const PasswordDialog());
  }

  void save() async {
    var data = await LoadingView.singleton.wrap(asyncFunction: () => Apis.modifyUserInfo(userInfo: state.userInfo));
    if (data == false) {
      ToastUtils.toastText(StrRes.saveFailed);
    } else {
      GlobalData.userInfo = state.userInfo;
      ToastUtils.toastText(StrRes.saveSuccess);
    }
  }
}
