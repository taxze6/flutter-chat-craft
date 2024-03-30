import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';

class FluentEmojiIconData {
  static List<String> emojiNames = [
    "flGrinningFace",
    "flGrinningSquintingFace",
    "flSmilingFaceWithHearts",
    "flFire",
    "flSmilingFaceWithHalo",
    "flSmilingFaceWithSunglasses",
    "flAngryFace",
    "flAnguishedFace",
    "flAnxiousFaceWithSweat",
    "flAstonishedFace",
    "flBeamingFaceWithSmilingEyes",
    "flCatFace",
    "flClownFace",
    "flColdFace",
    "flConfoundedFace",
    "flConfusedFace",
    "flDisappointedFace",
    "flDisguisedFace",
    "flDogFace",
    "flDottedLineFace",
    "flDowncastFaceWithSweat",
    "flDragonFace",
    "flLoudlyCryingFace",
    "flRosette",
    "flSafetyPin",
    "flSchool",
    "flScissors"
  ];

  static FluentData stringGetFluentsData(String emojiName) {
    switch (emojiName) {
      case "flGrinningFace":
        return Fluents.flGrinningFace;
      case "flGrinningSquintingFace":
        return Fluents.flGrinningSquintingFace;
      case "flSmilingFaceWithHearts":
        return Fluents.flSmilingFaceWithHearts;
      case "flFire":
        return Fluents.flFire;
      case "flSmilingFaceWithHalo":
        return Fluents.flSmilingFaceWithHalo;
      case "flSmilingFaceWithSunglasses":
        return Fluents.flSmilingFaceWithSunglasses;
      case "flAngryFace":
        return Fluents.flAngryFace;
      case "flAnguishedFace":
        return Fluents.flAnguishedFace;
      case "flAnxiousFaceWithSweat":
        return Fluents.flAnxiousFaceWithSweat;
      case "flAstonishedFace":
        return Fluents.flAstonishedFace;
      case "flBeamingFaceWithSmilingEyes":
        return Fluents.flBeamingFaceWithSmilingEyes;
      case "flCatFace":
        return Fluents.flCatFace;
      case "flClownFace":
        return Fluents.flClownFace;
      case "flColdFace":
        return Fluents.flColdFace;
      case "flConfoundedFace":
        return Fluents.flConfoundedFace;
      case "flConfusedFace":
        return Fluents.flConfusedFace;
      case "flDisappointedFace":
        return Fluents.flDisappointedFace;
      case "flDisguisedFace":
        return Fluents.flDisguisedFace;
      case "flDogFace":
        return Fluents.flDogFace;
      case "flDottedLineFace":
        return Fluents.flDottedLineFace;
      case "flDowncastFaceWithSweat":
        return Fluents.flDowncastFaceWithSweat;
      case "flDragonFace":
        return Fluents.flDragonFace;
      case "flLoudlyCryingFace":
        return Fluents.flLoudlyCryingFace;
      case "flRosette":
        return Fluents.flRosette;
      case "flSafetyPin":
        return Fluents.flSafetyPin;
      case "flSchool":
        return Fluents.flSchool;
      case "flScissors":
        return Fluents.flScissors;
      default:
        return Fluents.flGrinningFace;
    }
  }
}
