// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// 參數設定資料存取區
class SetdateStruct extends BaseStruct {
  SetdateStruct({
    String? feedBucketHeight,
    String? fullBucketAlert,
    String? lowFeedAlert,
    String? dataTransmissionInterval,
    String? shelfLife,
    String? feedSprayCount,
    String? temperatureRange,
    String? humidityRange,
    String? feedDensity,
  })  : _feedBucketHeight = feedBucketHeight,
        _fullBucketAlert = fullBucketAlert,
        _lowFeedAlert = lowFeedAlert,
        _dataTransmissionInterval = dataTransmissionInterval,
        _shelfLife = shelfLife,
        _feedSprayCount = feedSprayCount,
        _temperatureRange = temperatureRange,
        _humidityRange = humidityRange,
        _feedDensity = feedDensity;

  // "FeedBucketHeight" field.
  String? _feedBucketHeight;
  String get feedBucketHeight => _feedBucketHeight ?? '';
  set feedBucketHeight(String? val) => _feedBucketHeight = val;

  bool hasFeedBucketHeight() => _feedBucketHeight != null;

  // "FullBucketAlert" field.
  String? _fullBucketAlert;
  String get fullBucketAlert => _fullBucketAlert ?? '';
  set fullBucketAlert(String? val) => _fullBucketAlert = val;

  bool hasFullBucketAlert() => _fullBucketAlert != null;

  // "LowFeedAlert" field.
  String? _lowFeedAlert;
  String get lowFeedAlert => _lowFeedAlert ?? '';
  set lowFeedAlert(String? val) => _lowFeedAlert = val;

  bool hasLowFeedAlert() => _lowFeedAlert != null;

  // "DataTransmissionInterval" field.
  String? _dataTransmissionInterval;
  String get dataTransmissionInterval => _dataTransmissionInterval ?? '';
  set dataTransmissionInterval(String? val) => _dataTransmissionInterval = val;

  bool hasDataTransmissionInterval() => _dataTransmissionInterval != null;

  // "ShelfLife" field.
  String? _shelfLife;
  String get shelfLife => _shelfLife ?? '';
  set shelfLife(String? val) => _shelfLife = val;

  bool hasShelfLife() => _shelfLife != null;

  // "FeedSprayCount" field.
  String? _feedSprayCount;
  String get feedSprayCount => _feedSprayCount ?? '';
  set feedSprayCount(String? val) => _feedSprayCount = val;

  bool hasFeedSprayCount() => _feedSprayCount != null;

  // "TemperatureRange" field.
  String? _temperatureRange;
  String get temperatureRange => _temperatureRange ?? '';
  set temperatureRange(String? val) => _temperatureRange = val;

  bool hasTemperatureRange() => _temperatureRange != null;

  // "HumidityRange" field.
  String? _humidityRange;
  String get humidityRange => _humidityRange ?? '';
  set humidityRange(String? val) => _humidityRange = val;

  bool hasHumidityRange() => _humidityRange != null;

  // "feed_density" field.
  String? _feedDensity;
  String get feedDensity => _feedDensity ?? '';
  set feedDensity(String? val) => _feedDensity = val;

  bool hasFeedDensity() => _feedDensity != null;

  static SetdateStruct fromMap(Map<String, dynamic> data) => SetdateStruct(
        feedBucketHeight: data['FeedBucketHeight'] as String?,
        fullBucketAlert: data['FullBucketAlert'] as String?,
        lowFeedAlert: data['LowFeedAlert'] as String?,
        dataTransmissionInterval: data['DataTransmissionInterval'] as String?,
        shelfLife: data['ShelfLife'] as String?,
        feedSprayCount: data['FeedSprayCount'] as String?,
        temperatureRange: data['TemperatureRange'] as String?,
        humidityRange: data['HumidityRange'] as String?,
        feedDensity: data['feed_density'] as String?,
      );

  static SetdateStruct? maybeFromMap(dynamic data) =>
      data is Map ? SetdateStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'FeedBucketHeight': _feedBucketHeight,
        'FullBucketAlert': _fullBucketAlert,
        'LowFeedAlert': _lowFeedAlert,
        'DataTransmissionInterval': _dataTransmissionInterval,
        'ShelfLife': _shelfLife,
        'FeedSprayCount': _feedSprayCount,
        'TemperatureRange': _temperatureRange,
        'HumidityRange': _humidityRange,
        'feed_density': _feedDensity,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'FeedBucketHeight': serializeParam(
          _feedBucketHeight,
          ParamType.String,
        ),
        'FullBucketAlert': serializeParam(
          _fullBucketAlert,
          ParamType.String,
        ),
        'LowFeedAlert': serializeParam(
          _lowFeedAlert,
          ParamType.String,
        ),
        'DataTransmissionInterval': serializeParam(
          _dataTransmissionInterval,
          ParamType.String,
        ),
        'ShelfLife': serializeParam(
          _shelfLife,
          ParamType.String,
        ),
        'FeedSprayCount': serializeParam(
          _feedSprayCount,
          ParamType.String,
        ),
        'TemperatureRange': serializeParam(
          _temperatureRange,
          ParamType.String,
        ),
        'HumidityRange': serializeParam(
          _humidityRange,
          ParamType.String,
        ),
        'feed_density': serializeParam(
          _feedDensity,
          ParamType.String,
        ),
      }.withoutNulls;

  static SetdateStruct fromSerializableMap(Map<String, dynamic> data) =>
      SetdateStruct(
        feedBucketHeight: deserializeParam(
          data['FeedBucketHeight'],
          ParamType.String,
          false,
        ),
        fullBucketAlert: deserializeParam(
          data['FullBucketAlert'],
          ParamType.String,
          false,
        ),
        lowFeedAlert: deserializeParam(
          data['LowFeedAlert'],
          ParamType.String,
          false,
        ),
        dataTransmissionInterval: deserializeParam(
          data['DataTransmissionInterval'],
          ParamType.String,
          false,
        ),
        shelfLife: deserializeParam(
          data['ShelfLife'],
          ParamType.String,
          false,
        ),
        feedSprayCount: deserializeParam(
          data['FeedSprayCount'],
          ParamType.String,
          false,
        ),
        temperatureRange: deserializeParam(
          data['TemperatureRange'],
          ParamType.String,
          false,
        ),
        humidityRange: deserializeParam(
          data['HumidityRange'],
          ParamType.String,
          false,
        ),
        feedDensity: deserializeParam(
          data['feed_density'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SetdateStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SetdateStruct &&
        feedBucketHeight == other.feedBucketHeight &&
        fullBucketAlert == other.fullBucketAlert &&
        lowFeedAlert == other.lowFeedAlert &&
        dataTransmissionInterval == other.dataTransmissionInterval &&
        shelfLife == other.shelfLife &&
        feedSprayCount == other.feedSprayCount &&
        temperatureRange == other.temperatureRange &&
        humidityRange == other.humidityRange &&
        feedDensity == other.feedDensity;
  }

  @override
  int get hashCode => const ListEquality().hash([
        feedBucketHeight,
        fullBucketAlert,
        lowFeedAlert,
        dataTransmissionInterval,
        shelfLife,
        feedSprayCount,
        temperatureRange,
        humidityRange,
        feedDensity
      ]);
}

SetdateStruct createSetdateStruct({
  String? feedBucketHeight,
  String? fullBucketAlert,
  String? lowFeedAlert,
  String? dataTransmissionInterval,
  String? shelfLife,
  String? feedSprayCount,
  String? temperatureRange,
  String? humidityRange,
  String? feedDensity,
}) =>
    SetdateStruct(
      feedBucketHeight: feedBucketHeight,
      fullBucketAlert: fullBucketAlert,
      lowFeedAlert: lowFeedAlert,
      dataTransmissionInterval: dataTransmissionInterval,
      shelfLife: shelfLife,
      feedSprayCount: feedSprayCount,
      temperatureRange: temperatureRange,
      humidityRange: humidityRange,
      feedDensity: feedDensity,
    );
