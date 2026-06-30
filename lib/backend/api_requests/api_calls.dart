import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

class DatebaseSQLCall {
  static Future<ApiCallResponse> call({
    String? mode = '',
    String? key = '',
    String? sqlString = '',
    String? sqlWhere = '',
    String? sqlFrom = '',
    String? id = '',
    String? sqlSheet = '',
    String? sqlNameString = '',
    String? databaseName = '',
    String? all = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'DatebaseSQL',
      apiUrl: 'https://bdw.npust.edu.tw/F_S/FlutterFlow_link_key.php',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      params: {
        'mode': mode,
        'key': key,
        'sql_string': sqlString,
        'sql_where': sqlWhere,
        'sql_from': sqlFrom,
        'id': id,
        'sql_sheet': sqlSheet,
        'sql_name_string': sqlNameString,
        'Database_name': databaseName,
        'all': all,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? sp(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].specification''',
      ));
  static String? power(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].Power''',
      ));
  static String? switchC(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].switchC''',
      ));
  static String? camlink(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].camlink''',
      ));
  static String? camSwitchC(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$[:].cam_switchC''',
      ));
  static String? patrol(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].auto_patrol''',
      ));
  static String? relaySltC(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].relay_sltC''',
      ));
  static String? relayMode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].relay_mode''',
      ));
  static dynamic warning(dynamic response) => getJsonField(
        response,
        r'''$.warning''',
      );
  static dynamic image(dynamic response) => getJsonField(
        response,
        r'''$[:].image''',
      );
  static String? tempRange(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].temp_range''',
      ));
  static String? rHrange(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].RH_range''',
      ));
  static String? password(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].password''',
      ));
  static String? farmID(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].farmID''',
      ));
  static List<String>? opID(dynamic response) => (getJsonField(
        response,
        r'''$[:].opID''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static String? wUpValue(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].wupvalue''',
      ));
  static String? wDownValue(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$[:].wdownvalue''',
      ));
  static String? readTime(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].read_time''',
      ));
  static String? feedDay(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].Feed_day''',
      ));
  static String? ton(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].ton''',
      ));
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static dynamic imageName(dynamic response) => getJsonField(
        response,
        r'''$[:].image_name''',
      );
  static List<String>? id(dynamic response) => (getJsonField(
        response,
        r'''$[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static dynamic imageDate(dynamic response) => getJsonField(
        response,
        r'''$[:].image_date''',
      );
  static dynamic feedDensity(dynamic response) => getJsonField(
        response,
        r'''$[:].feed_density''',
      );
  static String? updateTime(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$[:].update_time''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}
