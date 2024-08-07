
import 'package:intl/intl.dart';

class Utils {

  static String getFormattedTimeEvent(int time) {
    DateFormat newFormat =  DateFormat("h:mm a");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

}