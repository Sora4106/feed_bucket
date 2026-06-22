import '/backend/api_requests/api_calls.dart';
import '/components/app_branding.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:flutter/material.dart';
import 'map_page_model.dart';
export 'map_page_model.dart';

class MapPageWidget extends StatefulWidget {
  const MapPageWidget({
    super.key,
    this.farmID,
    this.farmName,
  });

  final String? farmID;
  final String? farmName;

  static String routeName = 'map_page';
  static String routePath = '/mapPage';

  @override
  State<MapPageWidget> createState() => _MapPageWidgetState();
}

class _MapPageWidgetState extends State<MapPageWidget> {
  late MapPageModel _model;
  late Future<List<_FarmMapMarker>> _mapMarkersFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapPageModel());
    _mapMarkersFuture = _loadMapMarkers();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<List<_FarmMapMarker>> _loadMapMarkers() async {
    final farmId = widget.farmID;
    if (farmId == null || farmId.isEmpty) {
      return const [];
    }

    final response = await DatebaseSQLCall.call(
      mode: 'select',
      key: 'any',
      sqlString: 'id,opID,GPS,warning,temp,RH,High,feed_weight,Power',
      sqlWhere: 'farmID=$farmId',
      sqlFrom: 'controller',
    );

    if (!response.succeeded) {
      throw Exception('Unable to load map markers.');
    }

    final rows = (getJsonField(
          response.jsonBody,
          r'''$[:]''',
          true,
        ) as List?) ??
        const [];

    final markers = <_FarmMapMarker>[];
    for (final row in rows) {
      final powerValue = getJsonField(row, r'''$.Power''').toString();
      if (powerValue != 'Y') {
        continue;
      }

      final gps = getJsonField(row, r'''$.GPS''').toString();
      final coordinate = _parseGpsCoordinate(gps);
      if (coordinate == null) {
        continue;
      }

      markers.add(
        _FarmMapMarker(
          title: _normalizeValue(
                getJsonField(row, r'''$.opID''').toString(),
              ) ??
              '飼料桶',
          latitude: coordinate.latitude,
          longitude: coordinate.longitude,
          temperature: _normalizeValue(
            getJsonField(row, r'''$.temp''').toString(),
          ),
          humidity: _normalizeValue(
            getJsonField(row, r'''$.RH''').toString(),
          ),
          height: _normalizeValue(
            getJsonField(row, r'''$.High''').toString(),
          ),
          feedWeight: _normalizeValue(
            getJsonField(row, r'''$.feed_weight''').toString(),
          ),
          warning: _warningText(
            getJsonField(row, r'''$.warning''').toString(),
          ),
        ),
      );
    }

    return markers;
  }

  String? _normalizeValue(String rawValue) {
    if (rawValue.isEmpty || rawValue == 'null') {
      return null;
    }
    return rawValue;
  }

  String? _warningText(String rawValue) {
    switch (rawValue) {
      case 'YN':
        return '滿桶警示';
      case 'NN':
        return '設備異常';
      case 'NY':
        return '低料警示';
      default:
        return null;
    }
  }

  _MapCoordinate? _parseGpsCoordinate(String rawGps) {
    if (rawGps.isEmpty ||
        rawGps == 'null' ||
        rawGps == 'N' ||
        rawGps == '0000.00000,00000.00000') {
      return null;
    }

    final parts = rawGps.split(',').map((part) => part.trim()).toList();
    if (parts.length != 2) {
      return null;
    }

    final latitude = _convertDmToDecimal(parts[0], 2);
    final longitude = _convertDmToDecimal(parts[1], 3);
    if (latitude == null || longitude == null) {
      return null;
    }

    return _MapCoordinate(latitude: latitude, longitude: longitude);
  }

  double? _convertDmToDecimal(String rawValue, int degreeDigits) {
    final normalized = rawValue.trim();
    if (!RegExp(r'^\d+(?:\.\d+)?$').hasMatch(normalized)) {
      return null;
    }

    final wholeNumber = normalized.split('.').first;
    if (wholeNumber.length < degreeDigits + 2) {
      return null;
    }

    final degrees = double.tryParse(normalized.substring(0, degreeDigits));
    final minutes = double.tryParse(normalized.substring(degreeDigits));
    if (degrees == null || minutes == null || minutes < 0 || minutes >= 60) {
      return null;
    }

    return double.parse((degrees + (minutes / 60)).toStringAsFixed(7));
  }

  String _buildMapHtml(List<_FarmMapMarker> markers) {
    const defaultCenter = _MapCoordinate(
      latitude: 23.69781,
      longitude: 120.960515,
    );
    final center = markers.isEmpty
        ? defaultCenter
        : _MapCoordinate(
            latitude: markers
                    .map((marker) => marker.latitude)
                    .reduce((sum, value) => sum + value) /
                markers.length,
            longitude: markers
                    .map((marker) => marker.longitude)
                    .reduce((sum, value) => sum + value) /
                markers.length,
          );

    final payload = jsonEncode({
      'center': {
        'lat': center.latitude,
        'lng': center.longitude,
      },
      'markers': markers.map((marker) => marker.toJson()).toList(),
    });

    return '''
<!DOCTYPE html>
<html lang="zh-Hant">
  <head>
    <meta charset="utf-8">
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"
    >
    <link
      rel="stylesheet"
      href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
    >
    <style>
      html, body {
        margin: 0;
        padding: 0;
        width: 100%;
        height: 100%;
        background: #dceaf1;
        font-family: Arial, sans-serif;
      }

      #map {
        width: 100%;
        height: 100%;
      }

      .map-empty {
        position: absolute;
        top: 16px;
        left: 16px;
        right: 16px;
        z-index: 999;
        padding: 12px 14px;
        border-radius: 14px;
        background: rgba(255, 255, 255, 0.96);
        color: #17324d;
        font-size: 14px;
        line-height: 1.5;
        box-shadow: 0 10px 24px rgba(0, 0, 0, 0.12);
      }

      .leaflet-container {
        background: #dceaf1;
      }

      .popup-title {
        margin: 0 0 8px;
        color: #17324d;
        font-size: 15px;
        font-weight: 700;
      }

      .popup-line {
        margin: 0 0 4px;
        color: #587084;
        font-size: 13px;
      }
    </style>
  </head>
  <body>
    <div id="map"></div>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
      const payload = $payload;

      const map = L.map('map', {
        zoomControl: true,
        attributionControl: true,
      }).setView(
        [payload.center.lat, payload.center.lng],
        payload.markers.length > 1 ? 17 : 18,
      );

      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 20,
        attribution: '&copy; OpenStreetMap contributors',
      }).addTo(map);

      const bucketIcon = L.icon({
        iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
        iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
        shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41]
      });

      const bounds = [];

      payload.markers.forEach(function(marker) {
        const popupParts = [];
        popupParts.push('<div class="popup-title">' + escapeHtml(marker.title) + '</div>');
        popupParts.push(metricLine('溫度', marker.temperature));
        popupParts.push(metricLine('濕度', marker.humidity));
        popupParts.push(metricLine('高度', marker.height));
        popupParts.push(metricLine('餵食重量', marker.feedWeight));

        if (marker.warning) {
          popupParts.push('<div class="popup-line">警示：' + escapeHtml(marker.warning) + '</div>');
        }

        L.marker([marker.lat, marker.lng], { icon: bucketIcon })
          .addTo(map)
          .bindPopup(popupParts.filter(Boolean).join(''));

        bounds.push([marker.lat, marker.lng]);
      });

      if (bounds.length === 1) {
        map.setView(bounds[0], 19);
      } else if (bounds.length > 1) {
        map.fitBounds(bounds, { padding: [28, 28] });
      } else {
        const emptyBanner = document.createElement('div');
        emptyBanner.className = 'map-empty';
        emptyBanner.textContent = '目前沒有可顯示的 GPS 定位資料。';
        document.body.appendChild(emptyBanner);
      }

      function metricLine(label, value) {
        if (!value) {
          return '';
        }

        return '<div class="popup-line">' + label + '：' + escapeHtml(value) + '</div>';
      }

      function escapeHtml(value) {
        return String(value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;')
          .replace(/'/g, '&#39;');
      }
    </script>
  </body>
</html>
''';
  }

  Widget _buildMapErrorState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: AppBranding.softPanelDecoration(context, radius: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.map_outlined,
            size: 42.0,
            color: AppBranding.textMuted,
          ),
          const SizedBox(height: 12.0),
          Text(
            AppBranding.localized(
              context,
              zh: '地圖資料暫時無法載入',
              en: 'Map data is temporarily unavailable',
            ),
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  color: AppBranding.textStrong,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6.0),
          Text(
            AppBranding.localized(
              context,
              zh: '請確認網路與後端資料來源是否正常，再重新開啟此頁面。',
              en: 'Please verify network access and backend connectivity, then reopen this page.',
            ),
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: AppBranding.textMuted,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBranding.buildPageAppBar(
          context,
          title: AppBranding.localized(
            context,
            zh: '農場地圖',
            en: 'Farm Map',
          ),
          onBack: () => context.pop(),
        ),
        body: SafeArea(
          top: true,
          child: AppBranding.buildPageBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppBranding.buildInfoBanner(
                        context,
                        title: valueOrDefault<String>(widget.farmName, '-'),
                        subtitle: AppBranding.localized(
                          context,
                          zh: '查看這個農場中目前在線裝置的位置與狀態。',
                          en: 'Review the current locations and statuses of devices in this farm.',
                        ),
                        icon: Icons.map_outlined,
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: Container(
                          decoration: AppBranding.panelDecoration(
                            context,
                            radius: 24.0,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: FutureBuilder<List<_FarmMapMarker>>(
                            future: _mapMarkersFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppBranding.actionColor,
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return _buildMapErrorState(context);
                              }

                              return FlutterFlowWebView(
                                content: _buildMapHtml(
                                  snapshot.data ?? <_FarmMapMarker>[],
                                ),
                                html: true,
                                bypass: false,
                                width: double.infinity,
                                height: double.infinity,
                                verticalScroll: false,
                                horizontalScroll: false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapCoordinate {
  const _MapCoordinate({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class _FarmMapMarker {
  const _FarmMapMarker({
    required this.title,
    required this.latitude,
    required this.longitude,
    this.temperature,
    this.humidity,
    this.height,
    this.feedWeight,
    this.warning,
  });

  final String title;
  final double latitude;
  final double longitude;
  final String? temperature;
  final String? humidity;
  final String? height;
  final String? feedWeight;
  final String? warning;

  Map<String, dynamic> toJson() => {
        'title': title,
        'lat': latitude,
        'lng': longitude,
        'temperature': temperature,
        'humidity': humidity,
        'height': height,
        'feedWeight': feedWeight,
        'warning': warning,
      };
}
