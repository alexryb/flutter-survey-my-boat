import 'dart:typed_data';

import 'package:uuid/uuid.dart';

class StringUtils {

  static String stringToParagraph(String srcStr) {
    String trgStr = "";
    List<String> sents = srcStr.split(". ");
    int count = 0;
    for (String str in sents) {
      count++;
      if (count < 5) {
        trgStr = "$trgStr$str. ";
      } else {
        count = 0;
        trgStr = "$trgStr$str.\n\n";
      }
    }
      if(trgStr.length > 2) {
        return trgStr.substring(0, trgStr.length - 2);
      } else {
        return trgStr;
      }
  }

  static String generateGuid() {
    return Uuid().v4().replaceAll("-", "").toUpperCase();
  }

  static Uint8List stringToBytes(String source) {
    // String (Dart uses UTF-16) to bytes
    var list = List<int>.empty(growable: true);
    for (var rune in source.runes) {
      if (rune >= 0x10000) {
        rune -= 0x10000;
        int firstWord = (rune >> 10) + 0xD800;
        list.add(firstWord >> 8);
        list.add(firstWord & 0xFF);
        int secondWord = (rune & 0x3FF) + 0xDC00;
        list.add(secondWord >> 8);
        list.add(secondWord & 0xFF);
      }
      else {
        list.add(rune >> 8);
        list.add(rune & 0xFF);
      }
    }
    Uint8List bytes = Uint8List.fromList(list);
    return bytes;
  }

  static String bytesToString(Uint8List bytes) {
    // Bytes to UTF-16 string
    StringBuffer buffer = new StringBuffer();
    for (int i = 0; i < bytes.length;) {
      int firstWord = (bytes[i] << 8) + bytes[i + 1];
      if (0xD800 <= firstWord && firstWord <= 0xDBFF) {
        int secondWord = (bytes[i + 2] << 8) + bytes[i + 3];
        buffer.writeCharCode(((firstWord - 0xD800) << 10) + (secondWord - 0xDC00) + 0x10000);
        i += 4;
      }
      else {
        buffer.writeCharCode(firstWord);
        i += 2;
      }
    }

    // Outcome
    String outcome = buffer.toString();
    return outcome;
  }
}