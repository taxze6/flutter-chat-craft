class IMUtils {
  //Format the time.
  static String? formatTime(String? iso8601Time) {
    if (iso8601Time == null) {
      return null;
    } else {
      var dateTime = DateTime.parse(iso8601Time);
      return _timeFormatEx(dateTime.millisecondsSinceEpoch ~/ 1000);
    }
  }

  static String _timeFormatEx(int time) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var now = DateTime.now();
    // 今天，显示时分
    // 昨天，显示昨天
    // 其他，显示年月日
    if (dateTime.day == now.day) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    var yesterday = now.subtract(const Duration(days: 1));
    if (dateTime.day == yesterday.day) {
      return "昨天 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    }

    var week = now.subtract(const Duration(days: 7));
    if (dateTime.millisecondsSinceEpoch > week.millisecondsSinceEpoch) {
      var weekday = "星期一";
      switch (dateTime.weekday) {
        case 2:
          weekday = "星期二";
          break;
        case 3:
          weekday = "星期三";
          break;
        case 4:
          weekday = "星期四";
          break;
        case 5:
          weekday = "星期五";
          break;
        case 6:
          weekday = "星期六";
          break;
        case 7:
          weekday = "星期日";
          break;
      }

      return "$weekday ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    }

    // 其他情况，显示年月日
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}
