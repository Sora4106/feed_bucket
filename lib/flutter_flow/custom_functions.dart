import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';

String dateSet(
  String mode,
  String input,
  String year,
  String month,
  String day,
) {
  DateTime now = DateTime.now();
  if (mode == "initial") {
    //取得目前時間
    if (input == "year") {
      return now.year.toString();
    } else if (input == "month") {
      return now.month.toString();
    } else if (input == "day") {
      return now.day.toString();
    } else if (input == "date") {
      return DateFormat('yyyy-MM-dd').format(now);
    }
  } else if (mode == "add") {
    //按鍵+//year可以拿來當hour,minute
    DateTime date = DateTime(int.parse(year), int.parse(month), int.parse(day));
    if (input == "year") {
      date = DateTime(date.year + 1, date.month, date.day);
    } else if (input == "month") {
      if (int.parse(month) == 12) {
        date = DateTime(date.year + 1, 1, date.day);
      } else {
        DateTime lastday = DateTime(date.year, date.month + 2, 1);
        lastday = lastday.subtract(Duration(days: 1));
        if (date.day > lastday.day) {
          date = DateTime(date.year, date.month + 1, lastday.day);
        } else {
          date = DateTime(date.year, date.month + 1, date.day);
        }
      }
    } else if (input == "day") {
      date = date.add(Duration(days: 1));
    }
    return DateFormat('yyyy-M-d').format(date);
  } else if (mode == "reduce") {
    //按鍵-
    DateTime date = DateTime(int.parse(year), int.parse(month), int.parse(day));
    if (input == "year") {
      date = DateTime(date.year - 1, date.month, date.day);
    } else if (input == "month") {
      if (int.parse(month) == 1) {
        date = DateTime(date.year - 1, 12, date.day);
      } else {
        DateTime lastday = DateTime(date.year, date.month - 2, 1);
        lastday = lastday.subtract(Duration(days: 1));
        if (date.day > lastday.day) {
          date = DateTime(date.year, date.month - 1, lastday.day);
        } else {
          date = DateTime(date.year, date.month - 1, date.day);
        }
      }
    } else if (input == "day") {
      date = date.subtract(Duration(days: 1));
    }
    return DateFormat('yyyy-M-d').format(date);
  } else if (mode == "dateout") {
    DateTime date = DateTime(int.parse(year), int.parse(month), int.parse(day));
    return DateFormat(input).format(date);
  }

  return "";
}

String strsplit(
  String input,
  int pos,
) {
  List<String> array = [];
  array = (input.split("-"));
  return array[pos - 1];
}

int feed(
  List<String> array,
  String mode,
  String specificaton,
  String ton,
) {
  int feedtime = 0;
  int feedton;
  for (var i = 0; i < array.length - 1; i++) {
    if (double.parse(array[i]) - double.parse(array[i + 1]) >
        int.parse(specificaton) * 0.01) {
      feedtime += 1;
    }
  }
  feedton = int.parse(ton) * feedtime;
  if (mode == 'time') {
    return feedtime;
  } else if (mode == 'ton') {
    return feedton;
  }
  return 0;
}

String dateMode(
  String originalDateTime,
  String mode,
) {
  // 解析日期字符串
  DateTime parsedDateTime = DateTime.parse(originalDateTime.substring(0, 4) +
      "-" +
      originalDateTime.substring(4, 6) +
      "-" +
      originalDateTime.substring(6, 8) +
      "T" +
      originalDateTime.substring(8, 10) +
      ":" +
      originalDateTime.substring(10, 12) +
      ":" +
      originalDateTime.substring(12, 14));

  // 定義輸出格式
  DateFormat outputFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

  // 格式化日期
  String formattedDateTime = outputFormat.format(parsedDateTime);
  if (mode == 'date') {
    return formattedDateTime.split(" ")[0];
  } else if (mode == 'time') {
    return (formattedDateTime.split(" ")[1]).substring(0, 5);
  }
  return formattedDateTime;
}

String selectchart(
  String opID,
  String bb,
  String ba,
) {
  bb = bb.replaceAll("-", "");
  ba = ba.replaceAll("-", "");
  return "https://bdw.npust.edu.tw/F_S/index.html?&app=" +
      opID +
      "&curve1=High&curve2=temp&curve3=RH&curve4=feed_weight&curve5=&bb=" +
      bb +
      "&ba=" +
      ba +
      "&top=30&left=150&width=800&height=650&fontSize=40";
}

FFUploadedFile? base64ToUploadedFile(String base64) {
  try {
    final base64Data = base64.substring(base64.indexOf(',') + 1);
    final bytes = base64Decode(base64Data);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final extension = base64.split('/').first.split(':').last;
    final fileName = '$id.$extension';
    return FFUploadedFile(
      bytes: bytes,
    );
  } catch (e) {
    print('Erreur lors de la conversion Base64 : $e');
    // Gérer l'erreur selon vos besoins
    return null; // Ou une autre valeur par défaut
  }
}

String rangeColor(
  String range,
  String value,
) {
  List<String> array = [];
  array = (range.split("-"));
  if (double.parse(value) > double.parse(array[1]) ||
      double.parse(value) < double.parse(array[0])) {
    return "#d41212";
  } else if (double.parse(value) == double.parse(array[1]) ||
      double.parse(value) == double.parse(array[0])) {
    return "#9DA639";
  } else {
    return "#12151c";
  }
}

int getStringIndex(
  List<String> items,
  String value,
) {
  return items.indexOf(value);
}

List<int> sortIndicesByNaturalOrder(List<String> items) {
  final indexedItems = List.generate(
    items.length,
    (index) => MapEntry(index, items[index]),
  );

  indexedItems.sort((left, right) {
    final comparison = _naturalCompare(left.value, right.value);
    if (comparison != 0) {
      return comparison;
    }
    return left.key.compareTo(right.key);
  });

  return indexedItems.map((entry) => entry.key).toList();
}

int _naturalCompare(String left, String right) {
  final leftTokens = _naturalTokens(left.trim());
  final rightTokens = _naturalTokens(right.trim());
  final tokenCount = math.min(leftTokens.length, rightTokens.length);

  for (var index = 0; index < tokenCount; index++) {
    final leftToken = leftTokens[index];
    final rightToken = rightTokens[index];
    final leftNumber = int.tryParse(leftToken);
    final rightNumber = int.tryParse(rightToken);

    if (leftNumber != null && rightNumber != null) {
      final numberComparison = leftNumber.compareTo(rightNumber);
      if (numberComparison != 0) {
        return numberComparison;
      }
      continue;
    }

    final textComparison = leftToken.compareTo(rightToken);
    if (textComparison != 0) {
      return textComparison;
    }
  }

  if (leftTokens.length != rightTokens.length) {
    return leftTokens.length.compareTo(rightTokens.length);
  }

  return left.compareTo(right);
}

List<String> _naturalTokens(String input) {
  return RegExp(r'\d+|\D+')
      .allMatches(input)
      .map((match) => match.group(0) ?? '')
      .where((token) => token.isNotEmpty)
      .toList();
}

String intToString(int value) {
  return value.toString();
}

bool isBelowOrEqual(
  String minValue,
  String measuredValue,
) {
  final double min = double.parse(minValue);
  final double measured = double.parse(measuredValue);

  // 判斷量測值是否小於或等於下限
  return measured <= min;
}
