import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListMemeWidget extends StatelessWidget {
  ListMemeWidget({
    Key? key,
    required this.imgUrls,
    required this.addImg,
    required this.onTapRightBtn,
    required this.expandMeme,
    required this.listHeight,
  }) : super(key: key);

  final List<String> imgUrls;

  final GestureTapCallback addImg;

  final GestureTapCallback onTapRightBtn;

  final bool expandMeme;

  final double listHeight;
  int length = 0;

  @override
  Widget build(BuildContext context) {
    if (imgUrls.isEmpty) {
      length = 1;
    } else if (imgUrls.length <= 4 && imgUrls.isNotEmpty) {
      length = imgUrls.length + 1;
    } else if (imgUrls.length > 4) {
      length = imgUrls.length + 2;
    }
    return AnimatedContainer(
      height: listHeight,
      duration: const Duration(milliseconds: 200),
      child: GridView.builder(
          physics:
              expandMeme ? ScrollPhysics() : NeverScrollableScrollPhysics(),
          itemCount: length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.w,
          ),
          itemBuilder: (ctx, index) {
            if (index == 0) {
              return addBtn();
            } else if (index == 4 && imgUrls.length > 4) {
              return expandPopup();
            } else {
              int imgIndex = index - 1;
              if (imgUrls.length > 4 && index > 4) {
                imgIndex = index - 2;
              }
              return meMe(imgUrls[imgIndex]);
            }
          }),
    );
  }

  Widget addBtn() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: SvgPicture.asset(
        ImagesRes.icAdd,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
    );
  }

  Widget meMe(String url) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.w),
        child: FadeInImage(
          placeholder: const AssetImage(
            ImagesRes.icBrowser,
          ),
          image: NetworkImage(url),
          fit: BoxFit.fill,
          fadeInDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Widget expandPopup() {
    return GestureDetector(
      onTap: onTapRightBtn,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: SvgPicture.asset(
          ImagesRes.icDownArrow,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
      ),
    );
  }
}
