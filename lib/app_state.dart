import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _accountNumber = prefs.getString('ff_accountNumber') ?? _accountNumber;
    });
    _safeInit(() {
      _password = prefs.getString('ff_password') ?? _password;
    });
    _safeInit(() {
      _check = prefs.getBool('ff_check') ?? _check;
    });
    _safeInit(() {
      _testWaitFlag = prefs.getBool('ff_testWaitFlag') ?? _testWaitFlag;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _bb = '';
  String get bb => _bb;
  set bb(String value) {
    _bb = value;
  }

  String _ba = '';
  String get ba => _ba;
  set ba(String value) {
    _ba = value;
  }

  List<String> _opID = [];
  List<String> get opID => _opID;
  set opID(List<String> value) {
    _opID = value;
  }

  void addToOpID(String value) {
    opID.add(value);
  }

  void removeFromOpID(String value) {
    opID.remove(value);
  }

  void removeAtIndexFromOpID(int index) {
    opID.removeAt(index);
  }

  void updateOpIDAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    opID[index] = updateFn(_opID[index]);
  }

  void insertAtIndexInOpID(int index, String value) {
    opID.insert(index, value);
  }

  List<String> _farmID = [];
  List<String> get farmID => _farmID;
  set farmID(List<String> value) {
    _farmID = value;
  }

  void addToFarmID(String value) {
    farmID.add(value);
  }

  void removeFromFarmID(String value) {
    farmID.remove(value);
  }

  void removeAtIndexFromFarmID(int index) {
    farmID.removeAt(index);
  }

  void updateFarmIDAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    farmID[index] = updateFn(_farmID[index]);
  }

  void insertAtIndexInFarmID(int index, String value) {
    farmID.insert(index, value);
  }

  List<String> _name = [];
  List<String> get name => _name;
  set name(List<String> value) {
    _name = value;
  }

  void addToName(String value) {
    name.add(value);
  }

  void removeFromName(String value) {
    name.remove(value);
  }

  void removeAtIndexFromName(int index) {
    name.removeAt(index);
  }

  void updateNameAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    name[index] = updateFn(_name[index]);
  }

  void insertAtIndexInName(int index, String value) {
    name.insert(index, value);
  }

  String _accountNumber = '';
  String get accountNumber => _accountNumber;
  set accountNumber(String value) {
    _accountNumber = value;
    prefs.setString('ff_accountNumber', value);
  }

  String _password = '';
  String get password => _password;
  set password(String value) {
    _password = value;
    prefs.setString('ff_password', value);
  }

  bool _check = false;
  bool get check => _check;
  set check(bool value) {
    _check = value;
    prefs.setBool('ff_check', value);
  }

  String _versionName = '1.0.4';
  String get versionName => _versionName;
  set versionName(String value) {
    _versionName = value;
  }

  SetdateStruct _setdate = SetdateStruct.fromSerializableMap(jsonDecode(
      '{\"FeedBucketHeight\":\"0\",\"FullBucketAlert\":\"0\",\"LowFeedAlert\":\"0\",\"DataTransmissionInterval\":\"0\",\"ShelfLife\":\"0\",\"FeedSprayCount\":\"0\",\"TemperatureRange\":\"0-0\",\"HumidityRange\":\"0-0\"}'));
  SetdateStruct get setdate => _setdate;
  set setdate(SetdateStruct value) {
    _setdate = value;
  }

  void updateSetdateStruct(Function(SetdateStruct) updateFn) {
    updateFn(_setdate);
  }

  List<String> _id = [];
  List<String> get id => _id;
  set id(List<String> value) {
    _id = value;
  }

  void addToId(String value) {
    id.add(value);
  }

  void removeFromId(String value) {
    id.remove(value);
  }

  void removeAtIndexFromId(int index) {
    id.removeAt(index);
  }

  void updateIdAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    id[index] = updateFn(_id[index]);
  }

  void insertAtIndexInId(int index, String value) {
    id.insert(index, value);
  }

  bool _testWaitFlag = false;
  bool get testWaitFlag => _testWaitFlag;
  set testWaitFlag(bool value) {
    _testWaitFlag = value;
    prefs.setBool('ff_testWaitFlag', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}
