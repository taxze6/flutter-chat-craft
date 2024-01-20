import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ChatRecordVoiceView extends StatelessWidget {
  const ChatRecordVoiceView(
      {Key? key,
      required this.selectedCancelArea,
      required this.selectedSoundToWordArea,
      required this.selectedPressArea,
      required this.showSpeechRecognizing,
      required this.showRecognizeFailed,
      this.onCancel,
      this.onConfirm})
      : super(key: key);

  final bool selectedCancelArea;
  final bool selectedSoundToWordArea;
  final bool selectedPressArea;
  final bool showSpeechRecognizing;
  final bool showRecognizeFailed;
  final Function()? onCancel;
  final Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF000000).withOpacity(0.6),
      child: Stack(
        children: [
          Positioned(
            top: 360.h,
            left: 0,
            width: 375.w,
            child: _selectedPressAreaAnimationView(),
          ),
          Positioned(
            top: 360.h,
            left: 29.w,
            child: _selectedCancelAreaAnimationView(),
          ),
          Positioned(
            top: 526.h,
            left: 35.w,
            child: _unselectedCancelAreaView(),
          ),
          Positioned(
            top: 513.h,
            left: 30.w,
            child: _selectedCancelAreaView(),
          ),
          Positioned(
            top: 526.h,
            right: 35.w,
            child: _unselectedSoundToWordAreaView(),
          ),
          Positioned(
            top: 513.h,
            right: 30.w,
            child: _selectedSoundToWordAreaView(),
          ),
          Positioned(
            top: 513.h,
            right: 30.w,
            child: _recognizingProgressView(),
          ),
          Positioned(
            top: 491.h,
            left: 56.w,
            child: _selectedCancelAreaText(),
          ),
          Positioned(
            top: 491.h,
            right: 48.w,
            child: _selectedSoundToWordAreaText(),
          ),
          Positioned(
            top: 651.h,
            left: 0,
            width: 375.w,
            child: _selectedPressAreaReleaseText(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _bottomBg(),
          ),
          Positioned(
            bottom: 30.h,
            left: 0,
            width: 375.w,
            child: _speakerIcon(),
          ),
          Positioned(
            top: 360.h,
            left: 22.w,
            width: 331.w,
            child: _soundToWordAnimationView(),
          ),
          Positioned(
            top: 538.h,
            left: 54.w,
            child: _cancelSendView(),
          ),
          Positioned(
            top: 538.h,
            left: 0,
            child: _confirmSendView(),
          ),
          Positioned(
            top: 513.h,
            right: 30.w,
            child: _convertFailBtnView(),
          ),
          Positioned(
            top: 360.h,
            left: 22.w,
            child: _convertFailTipsView(),
          ),
        ],
      ),
    );
  }

  Widget _convertFailBtnView() => Visibility(
        visible: showRecognizeFailed,
        child: Image.asset(
          ImagesRes.icVoiceConvertFail,
          width: 102.w,
          height: 102.h,
        ),
      );

  Widget _convertFailTipsView() => Visibility(
        visible: showRecognizeFailed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 331.w,
              height: 95.h,
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 27.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFFA5251),
              ),
              child: Text(
                StrRes.convertFailTips,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: 331.w,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 60.w),
              child: ClipPath(
                clipper: _ArrowClipper(),
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  color: const Color(0xFFFA5251),
                ),
              ),
            )
          ],
        ),
      );

  Widget _cancelSendView() => Visibility(
        visible: showSpeechRecognizing || showRecognizeFailed,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onCancel,
          child: Column(
            children: [
              Image.asset(
                ImagesRes.icVoiceCancel,
                width: 18.w,
                height: 24.h,
              ),
              Text(
                StrRes.cancelVoiceSend,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      );

  Widget _confirmSendView() => Container(
        alignment: Alignment.center,
        width: 375.w,
        child: Visibility(
          visible: showSpeechRecognizing || showRecognizeFailed,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onConfirm,
            child: Column(
              children: [
                Image.asset(
                  ImagesRes.icVoiceConfirm,
                  width: 24.w,
                  height: 24.h,
                ),
                Text(
                  StrRes.confirmVoiceSend,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _recognizingProgressView() => Visibility(
        visible: showSpeechRecognizing,
        child: Container(
          width: 102.w,
          height: 102.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFFFFF),
            ),
            child: Center(
              child: SizedBox(
                width: 40.w,
                height: 40.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _bottomBg() => Visibility(
        visible: !showSpeechRecognizing && !showRecognizeFailed,
        child: Image.asset(
          selectedPressArea
              ? ImagesRes.icVoiceRecordBackWhite
              : ImagesRes.icVoiceRecordBackGrey,
          width: 375.w,
          height: 125.h,
          fit: BoxFit.fill,
        ),
      );

  Widget _speakerIcon() => Visibility(
        visible: !showSpeechRecognizing && !showRecognizeFailed,
        child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            ImagesRes.icVoiceRecordSpeaker,
            width: 36.w,
            height: 36.h,
            // color: Colors.blue,
          ),
        ),
      );

  Widget _selectedPressAreaReleaseText() => Visibility(
        visible: selectedPressArea,
        child: Text(
          StrRes.releaseSend,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFBEBEBE),
            fontSize: 14.sp,
          ),
        ),
      );

  Widget _selectedSoundToWordAreaText() => Visibility(
        visible: selectedSoundToWordArea,
        child: Text(
          StrRes.soundToWord,
          style: TextStyle(
            color: const Color(0xFFBEBEBE),
            fontSize: 14.sp,
          ),
        ),
      );

  Widget _selectedCancelAreaText() => Visibility(
        visible: selectedCancelArea,
        child: Text(
          StrRes.releaseCancel,
          style: TextStyle(
            color: const Color(0xFFBEBEBE),
            fontSize: 14.sp,
          ),
        ),
      );

  Widget _selectedSoundToWordAreaView() => Visibility(
        visible: selectedSoundToWordArea,
        child: Image.asset(
          ImagesRes.icVoiceRecordZiWhite,
          width: 102.w,
          height: 102.h,
        ),
      );

  Widget _unselectedSoundToWordAreaView() => Visibility(
        visible: !selectedSoundToWordArea,
        child: Image.asset(
          ImagesRes.icVoiceRecordZiGrey,
          width: 82.w,
          height: 82.h,
        ),
      );

  Widget _selectedCancelAreaView() => Visibility(
        visible: selectedCancelArea,
        child: Image.asset(
          ImagesRes.icVoiceRecordCancelWhite,
          width: 102.w,
          height: 102.h,
        ),
      );

  Widget _unselectedCancelAreaView() => Visibility(
        visible: !selectedCancelArea &&
            !showSpeechRecognizing &&
            !showRecognizeFailed,
        child: Image.asset(
          ImagesRes.icVoiceRecordCancelGrey,
          width: 82.w,
          height: 82.h,
        ),
      );

  Widget _selectedCancelAreaAnimationView() => Visibility(
        visible: selectedCancelArea,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 95.h,
              width: 104.w,
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 27.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFFA5251),
              ),
              child: Lottie.asset(
                'assets/anim/voice_record.json',
                width: 60.w,
                height: 25.h,
                fit: BoxFit.contain,
              ),
            ),
            ClipPath(
              clipper: _ArrowClipper(),
              child: Container(
                width: 10.w,
                height: 10.w,
                color: const Color(0xFFFA5251),
              ),
            )
          ],
        ),
      );

  Widget _selectedPressAreaAnimationView() => Visibility(
        visible: selectedPressArea,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 194.w,
                height: 95.h,
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 27.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFFFFFFFF),
                ),
                child: Lottie.asset(
                  'assets/anim/voice_record.json',
                  width: 140.w,
                  height: 35.h,
                  fit: BoxFit.contain,
                ),
              ),
              ClipPath(
                clipper: _ArrowClipper(),
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  color: const Color(0xFFFFFFFF),
                ),
              )
            ],
          ),
        ),
      );

  Widget _soundToWordAnimationView() => Visibility(
        visible: selectedSoundToWordArea,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 311.w,
                height: 95.h,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFFFFFFFF),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Lottie.asset(
                        'assets/anim/voice_record.json',
                        width: 45.w,
                        height: 20.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        StrRes.converting,
                        style: TextStyle(
                          color: const Color(0xFFBEBEBE),
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 311.w,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 50.w),
                child: ClipPath(
                  clipper: _ArrowClipper(),
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, -2);
    path.lineTo(size.width, -2);
    path.lineTo(size.width / 2, size.height * 2 / 4);

    // path.moveTo(0, size.height);
    // path.lineTo(size.width / 2, size.height / 2);
    // path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
