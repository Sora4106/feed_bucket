import '/backend/api_requests/api_calls.dart';
import '/components/app_branding.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'controller_page_model.dart';
export 'controller_page_model.dart';

class ControllerPageWidget extends StatefulWidget {
  const ControllerPageWidget({
    super.key,
    this.opIDlist,
    this.farmName,
    this.farmIDlist,
    this.idList,
  });

  final List<String>? opIDlist;
  final String? farmName;
  final List<String>? farmIDlist;
  final List<String>? idList;

  static String routeName = 'controller_page';
  static String routePath = '/controllerPage';

  @override
  State<ControllerPageWidget> createState() => _ControllerPageWidgetState();
}

class _ControllerPageWidgetState extends State<ControllerPageWidget> {
  static const Duration _autoRefreshInterval = Duration(seconds: 30);

  late ControllerPageModel _model;
  late List<String> _bucketNames;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, Future<ApiCallResponse>> _bucketMetricsFutures = {};
  final Map<String, Future<ApiCallResponse>> _bucketImageFutures = {};
  String? _renamingBucketId;
  InstantTimer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ControllerPageModel());
    _syncBucketNamesFromWidget();
    _startAutoRefresh();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didUpdateWidget(covariant ControllerPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listEquals(widget.idList, oldWidget.idList) ||
        !listEquals(widget.opIDlist, oldWidget.opIDlist)) {
      _syncBucketNamesFromWidget();
      final activeIds = (widget.idList ?? const <String>[]).toSet();
      _bucketMetricsFutures.removeWhere((id, _) => !activeIds.contains(id));
      _bucketImageFutures.removeWhere((id, _) => !activeIds.contains(id));
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _model.dispose();
    super.dispose();
  }

  void _syncBucketNamesFromWidget() {
    final ids = widget.idList ?? const <String>[];
    final names = widget.opIDlist ?? const <String>[];
    _bucketNames = List<String>.generate(
      ids.length,
      (index) => index < names.length ? names[index] : '',
    );
  }

  String _bucketLabelFor(String rawName, String bucketId) {
    final normalized = rawName.trim();
    return normalized.isEmpty ? 'Bucket $bucketId' : normalized;
  }

  String _escapeSqlValue(String value) {
    return value.replaceAll("'", "''");
  }

  dynamic _firstRow(dynamic jsonBody) {
    if (jsonBody is Map<String, dynamic>) {
      return jsonBody;
    }

    final rows = (getJsonField(
          jsonBody ?? const [],
          r'''$[:]''',
          true,
        ) as List?) ??
        const [];
    return rows.isNotEmpty ? rows.first : null;
  }

  String _verifiedBucketName(dynamic jsonBody) {
    final row = _firstRow(jsonBody);
    final rawValue = getJsonField(
      row ?? const {},
      r'''$.opID''',
    ).toString();
    final normalized = rawValue.trim();
    if (normalized.isEmpty || normalized == 'null') {
      return '';
    }
    return normalized;
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = InstantTimer.periodic(
      duration: _autoRefreshInterval,
      startImmediately: false,
      callback: (_) {
        if (!mounted || _renamingBucketId != null) {
          return;
        }
        _refreshBucketData();
      },
    );
  }

  void _refreshBucketData() {
    _bucketMetricsFutures.clear();
    _bucketImageFutures.clear();
    safeSetState(() {});
  }

  void _showSnackBar(
    String message, {
    bool isError = false,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              isError ? AppBranding.dangerColor : AppBranding.successColor,
        ),
      );
  }

  Future<String?> _showRenameBucketDialog(String currentName) async {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return _RenameBucketDialog(initialName: currentName);
      },
    );
  }

  Future<void> _renameBucket({
    required int index,
    required _BucketEntry bucket,
  }) async {
    final currentName = _bucketLabelFor(bucket.opId, bucket.id);
    final renamedValue = await _showRenameBucketDialog(currentName);
    final nextName = renamedValue?.trim() ?? '';

    if (nextName.isEmpty || nextName == currentName) {
      return;
    }

    setState(() {
      _renamingBucketId = bucket.id;
    });

    final escapedName = _escapeSqlValue(nextName);
    final updateResponse = await DatebaseSQLCall.call(
      mode: 'update',
      key: 'any',
      sqlString: 'opID=$escapedName',
      sqlWhere: 'id=${bucket.id}',
      sqlSheet: 'controller',
    );
    final verifyResponse = await DatebaseSQLCall.call(
      mode: 'select',
      key: 'any',
      sqlString: 'id,opID',
      sqlWhere: 'id=${bucket.id}',
      sqlFrom: 'controller',
    );

    final verifiedName = _verifiedBucketName(verifyResponse.jsonBody);
    final savedSuccessfully = updateResponse.succeeded &&
        verifyResponse.succeeded &&
        verifiedName == nextName;

    if (!mounted) {
      return;
    }

    setState(() {
      _renamingBucketId = null;
      if (savedSuccessfully && index < _bucketNames.length) {
        _bucketNames[index] = nextName;
      }
    });

    if (savedSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FFAppState().update(() {
          if (index < FFAppState().opID.length) {
            FFAppState().updateOpIDAtIndex(index, (_) => nextName);
          } else if (index == FFAppState().opID.length) {
            FFAppState().insertAtIndexInOpID(index, nextName);
          }
        });
      });

      _showSnackBar(
        AppBranding.localized(
          context,
          zh: '飼料桶名稱已更新',
          en: 'Bucket name updated',
        ),
      );
      return;
    }

    _showSnackBar(
      AppBranding.localized(
        context,
        zh: '名稱未成功寫回資料庫，請再試一次',
        en: 'The bucket name was not written back to the database',
      ),
      isError: true,
    );
  }

  List<_BucketEntry> get _bucketEntries {
    final ids = widget.idList ?? const <String>[];

    return List.generate(
      ids.length,
      (index) => _BucketEntry(
        id: ids[index],
        opId: _bucketLabelFor(
          index < _bucketNames.length ? _bucketNames[index] : '',
          ids[index],
        ),
      ),
    );
  }

  Future<ApiCallResponse> _metricsFutureForBucket(String bucketId) {
    return _bucketMetricsFutures.putIfAbsent(
      bucketId,
      () => DatebaseSQLCall.call(
        mode: 'select',
        key: 'any',
        sqlString: 'temp,RH,High,feed_weight,update_time,temp_range,RH_range',
        sqlWhere: 'id=$bucketId',
        sqlFrom: 'controller',
      ),
    );
  }

  Future<ApiCallResponse> _imageFutureForBucket(String bucketId) {
    return _bucketImageFutures.putIfAbsent(
      bucketId,
      () => DatebaseSQLCall.call(
        mode: 'select',
        key: 'IPcam_image',
        id: bucketId,
      ),
    );
  }

  String _formatImageDate(String? rawValue) {
    final raw = rawValue ?? '';
    if (raw.isEmpty || raw == 'null') {
      return AppBranding.localized(
        context,
        zh: '沒有照片時間',
        en: 'No photo timestamp',
      );
    }

    if (raw.length >= 14 &&
        RegExp(r'^\d{14}$').hasMatch(raw.substring(0, 14))) {
      return '${functions.dateMode(raw, 'date')} ${functions.dateMode(raw, 'time')}';
    }

    return raw;
  }

  Widget _buildBucketOverviewEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: AppBranding.softPanelDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: const Color(0x1A0B5CAD),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: const Icon(
              Icons.photo_camera_back_outlined,
              color: AppBranding.actionColor,
              size: 28.0,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            AppBranding.localized(
              context,
              zh: '目前沒有可顯示的飼料桶資訊卡',
              en: 'No bucket cards are available',
            ),
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  color: AppBranding.textStrong,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBucketOverviewSection(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final buckets = _bucketEntries;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: AppBranding.panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppBranding.localized(
              context,
              zh: '飼料桶資訊卡',
              en: 'Bucket Cards',
            ),
            style: theme.titleMedium.override(
              color: AppBranding.textStrong,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            AppBranding.localized(
              context,
              zh: '往下滑即可比較每一桶的照片、溫度、濕度、高度與餵食重量；點擊照片可全畫面放大。',
              en: 'Scroll to review each bucket photo together with temperature, humidity, height, and feed weight.',
            ),
            style: theme.bodyMedium.override(
              color: AppBranding.textMuted,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 14.0),
          Expanded(
            child: buckets.isEmpty
                ? _buildBucketOverviewEmptyState(context)
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: buckets.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14.0),
                    itemBuilder: (context, index) {
                      final bucket = buckets[index];

                      return _ControllerBucketSummaryCard(
                        bucketId: bucket.id,
                        opId: bucket.opId,
                        metricsFuture: _metricsFutureForBucket(bucket.id),
                        photoFuture: _imageFutureForBucket(bucket.id),
                        formatImageDate: _formatImageDate,
                        heroTag: 'bucket-photo-${bucket.id}',
                        isRenaming: _renamingBucketId == bucket.id,
                        onRenamePressed: () => _renameBucket(
                          index: index,
                          bucket: bucket,
                        ),
                      );
                    },
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
            zh: '裝置控制',
            en: 'Device Control',
          ),
          onBack: () => context.pop(),
        ),
        body: SafeArea(
          top: true,
          child: AppBranding.buildPageBackground(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: AppBranding.buildInfoBanner(
                    context,
                    title: valueOrDefault<String>(widget.farmName, '-'),
                    subtitle: AppBranding.localized(
                      context,
                      zh: '在同一個畫面查看每一桶的最新照片與感測器數據。',
                      en: 'Review the latest photo and sensor details for each bucket in one place.',
                    ),
                    icon: Icons.precision_manufacturing_rounded,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 18.0),
                    child: _buildBucketOverviewSection(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BucketEntry {
  const _BucketEntry({
    required this.id,
    required this.opId,
  });

  final String id;
  final String opId;
}

class _BucketPowerStatusInfo {
  const _BucketPowerStatusInfo({
    required this.label,
    required this.color,
    required this.detail,
  });

  final String label;
  final Color color;
  final String detail;
}

class _MetricRange {
  const _MetricRange({
    required this.min,
    required this.max,
  });

  final double min;
  final double max;
}

class _ControllerBucketSummaryCard extends StatelessWidget {
  const _ControllerBucketSummaryCard({
    required this.bucketId,
    required this.opId,
    required this.metricsFuture,
    required this.photoFuture,
    required this.formatImageDate,
    required this.heroTag,
    required this.isRenaming,
    required this.onRenamePressed,
  });

  final String bucketId;
  final String opId;
  final Future<ApiCallResponse> metricsFuture;
  final Future<ApiCallResponse> photoFuture;
  final String Function(String?) formatImageDate;
  final String heroTag;
  final bool isRenaming;
  final Future<void> Function() onRenamePressed;

  static const Duration _powerHealthyWindow = Duration(hours: 12);

  String _displayValue(String value, {String fallback = '-'}) {
    if (value.isEmpty || value == 'null') {
      return fallback;
    }
    return value;
  }

  dynamic _firstRow(dynamic jsonBody) {
    if (jsonBody is Map<String, dynamic>) {
      return jsonBody;
    }

    final rows = (getJsonField(
          jsonBody ?? const [],
          r'''$[:]''',
          true,
        ) as List?) ??
        const [];
    return rows.isNotEmpty ? rows.first : null;
  }

  String _rowValue(
    dynamic row,
    String path, {
    String fallback = '-',
  }) {
    return _displayValue(
      getJsonField(
        row ?? const {},
        path,
      ).toString(),
      fallback: fallback,
    );
  }

  String _jsonValue(
    dynamic jsonBody,
    String path, {
    String fallback = '-',
  }) {
    return _rowValue(_firstRow(jsonBody), path, fallback: fallback);
  }

  double? _parseMetricValue(String rawValue) {
    final normalized = rawValue.trim();
    if (normalized.isEmpty || normalized == '-' || normalized == 'null') {
      return null;
    }

    return double.tryParse(normalized);
  }

  _MetricRange? _parseMetricRange(String rawValue) {
    final match = RegExp(
      r'^\s*(-?\d+(?:\.\d+)?)\s*-\s*(-?\d+(?:\.\d+)?)\s*$',
    ).firstMatch(rawValue.trim());

    if (match == null) {
      return null;
    }

    final start = double.tryParse(match.group(1) ?? '');
    final end = double.tryParse(match.group(2) ?? '');
    if (start == null || end == null) {
      return null;
    }

    return _MetricRange(
      min: start <= end ? start : end,
      max: start <= end ? end : start,
    );
  }

  Color _metricValueColor(String value, String rangeValue) {
    final metricValue = _parseMetricValue(value);
    final metricRange = _parseMetricRange(rangeValue);

    if (metricValue == null || metricRange == null) {
      return AppBranding.textStrong;
    }

    if (metricValue < metricRange.min || metricValue > metricRange.max) {
      return AppBranding.dangerColor;
    }

    return AppBranding.successColor;
  }

  DateTime? _parseCompactTimestamp(String rawValue) {
    if (rawValue.length < 14 || !RegExp(r'^\d{14}$').hasMatch(rawValue)) {
      return null;
    }

    try {
      return DateTime(
        int.parse(rawValue.substring(0, 4)),
        int.parse(rawValue.substring(4, 6)),
        int.parse(rawValue.substring(6, 8)),
        int.parse(rawValue.substring(8, 10)),
        int.parse(rawValue.substring(10, 12)),
        int.parse(rawValue.substring(12, 14)),
      );
    } catch (_) {
      return null;
    }
  }

  _BucketPowerStatusInfo _buildStatusInfo(
    BuildContext context, {
    required bool isLoading,
    required String rawUpdateTime,
  }) {
    if (isLoading) {
      return _BucketPowerStatusInfo(
        label: AppBranding.localized(
          context,
          zh: '更新中',
          en: 'Updating',
        ),
        color: AppBranding.warningColor,
        detail: AppBranding.localized(
          context,
          zh: '正在讀取最新更新時間',
          en: 'Reading latest update timestamp',
        ),
      );
    }

    final parsedDate = _parseCompactTimestamp(rawUpdateTime);
    if (parsedDate == null) {
      return _BucketPowerStatusInfo(
        label: AppBranding.localized(
          context,
          zh: '無更新資料',
          en: 'No Data',
        ),
        color: AppBranding.warningColor,
        detail: AppBranding.localized(
          context,
          zh: '尚未收到可判斷狀態的更新時間',
          en: 'No update timestamp is available yet',
        ),
      );
    }

    final age = DateTime.now().difference(parsedDate).abs();
    final isHealthy = age <= _powerHealthyWindow;

    return _BucketPowerStatusInfo(
      label: AppBranding.localized(
        context,
        zh: isHealthy ? '電源正常' : '電源異常',
        en: isHealthy ? 'Power Normal' : 'Power Alert',
      ),
      color: isHealthy ? AppBranding.successColor : AppBranding.dangerColor,
      detail:
          '${AppBranding.localized(context, zh: '資料更新', en: 'Data update')}: ${functions.dateMode(rawUpdateTime, 'date')} ${functions.dateMode(rawUpdateTime, 'time')}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FutureBuilder<ApiCallResponse>(
      future: metricsFuture,
      builder: (context, snapshot) {
        final metricsJson = snapshot.data?.jsonBody;
        final metricsRow = _firstRow(metricsJson);
        final isLoading = snapshot.connectionState != ConnectionState.done;
        final rawUpdateTime = _displayValue(
          _rowValue(
            metricsRow,
            r'''$.update_time''',
            fallback: '',
          ),
          fallback: '',
        );
        final statusInfo = _buildStatusInfo(
          context,
          isLoading: isLoading,
          rawUpdateTime: rawUpdateTime,
        );

        return Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: AppBranding.softSurfaceColor.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: AppBranding.borderColor.withValues(alpha: 0.45),
              width: 1.2,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stackedLayout = constraints.maxWidth < 720.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                opId,
                                style: theme.titleMedium.override(
                                  color: AppBranding.textStrong,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            _RenameBucketButton(
                              isSaving: isRenaming,
                              onPressed: onRenamePressed,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      _SummaryStatusPill(
                        label: statusInfo.label,
                        color: statusInfo.color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    statusInfo.detail,
                    style: theme.bodySmall.override(
                      color: AppBranding.textMuted,
                      letterSpacing: 0.0,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  if (stackedLayout) ...[
                    _ControllerPhotoPreview(
                      photoFuture: photoFuture,
                      formatImageDate: formatImageDate,
                      heroTag: heroTag,
                    ),
                    const SizedBox(height: 12.0),
                    _buildMetricArea(context, metricsJson),
                  ] else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: _ControllerPhotoPreview(
                            photoFuture: photoFuture,
                            formatImageDate: formatImageDate,
                            heroTag: heroTag,
                          ),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          flex: 5,
                          child: _buildMetricArea(context, metricsJson),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMetricArea(BuildContext context, dynamic jsonBody) {
    final temperatureValue = _jsonValue(jsonBody, r'''$.temp''');
    final humidityValue = _jsonValue(jsonBody, r'''$.RH''');
    final temperatureRange = _jsonValue(
      jsonBody,
      r'''$.temp_range''',
      fallback: '',
    );
    final humidityRange = _jsonValue(
      jsonBody,
      r'''$.RH_range''',
      fallback: '',
    );

    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        _SummaryMetricTile(
          label: AppBranding.localized(
            context,
            zh: '溫度',
            en: 'Temperature',
          ),
          unit: '°C',
          value: temperatureValue,
          valueColor: _metricValueColor(temperatureValue, temperatureRange),
        ),
        _SummaryMetricTile(
          label: AppBranding.localized(
            context,
            zh: '濕度',
            en: 'Humidity',
          ),
          unit: '%',
          value: humidityValue,
          valueColor: _metricValueColor(humidityValue, humidityRange),
        ),
        _SummaryMetricTile(
          label: AppBranding.localized(
            context,
            zh: '高度',
            en: 'Height',
          ),
          unit: 'cm',
          value: _jsonValue(jsonBody, r'''$.High'''),
          valueColor: AppBranding.textStrong,
        ),
        _SummaryMetricTile(
          label: AppBranding.localized(
            context,
            zh: '餵食重量',
            en: 'Feed Weight',
          ),
          unit: 'kg',
          value: _jsonValue(jsonBody, r'''$.feed_weight'''),
          valueColor: AppBranding.textStrong,
        ),
      ],
    );
  }
}

class _ControllerPhotoPreview extends StatelessWidget {
  const _ControllerPhotoPreview({
    required this.photoFuture,
    required this.formatImageDate,
    required this.heroTag,
  });

  final Future<ApiCallResponse> photoFuture;
  final String Function(String?) formatImageDate;
  final String heroTag;

  static const String _placeholderAsset =
      'assets/images/Default_Image_depicts_a_large_industrialstyle_white_plastic_ho_1.png';

  Future<void> _openExpandedImage(
    BuildContext context, {
    required Widget image,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FlutterFlowExpandedImageView(
          image: image,
          allowRotation: true,
          tag: heroTag,
          useHeroAnimation: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FutureBuilder<ApiCallResponse>(
      future: photoFuture,
      builder: (context, snapshot) {
        Widget previewImage;
        Widget expandedImage;
        String captureText = AppBranding.localized(
          context,
          zh: '載入照片中',
          en: 'Loading photo',
        );
        final hasLoaded = snapshot.hasData;

        if (!hasLoaded) {
          previewImage = Container(
            color: const Color(0x120B5CAD),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppBranding.actionColor,
              ),
            ),
          );
          expandedImage = Image.asset(
            _placeholderAsset,
            fit: BoxFit.contain,
          );
        } else {
          final imageValue =
              DatebaseSQLCall.image(snapshot.data!.jsonBody).toString();
          final imageDate =
              DatebaseSQLCall.imageDate(snapshot.data!.jsonBody).toString();
          final uploadedFile = functions.base64ToUploadedFile(imageValue);
          captureText = formatImageDate(imageDate);

          if (uploadedFile?.bytes != null && uploadedFile!.bytes!.isNotEmpty) {
            previewImage = Image.memory(
              uploadedFile.bytes!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            );
            expandedImage = Image.memory(
              uploadedFile.bytes!,
              fit: BoxFit.contain,
              gaplessPlayback: true,
            );
          } else {
            previewImage = Image.asset(
              _placeholderAsset,
              fit: BoxFit.cover,
            );
            expandedImage = Image.asset(
              _placeholderAsset,
              fit: BoxFit.contain,
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18.0),
                onTap: hasLoaded
                    ? () => _openExpandedImage(
                          context,
                          image: expandedImage,
                        )
                    : null,
                child: Ink(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 172.0,
                          child: Hero(
                            tag: heroTag,
                            transitionOnUserGestures: true,
                            child: previewImage,
                          ),
                        ),
                      ),
                      if (hasLoaded)
                        Positioned(
                          right: 10.0,
                          bottom: 10.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(999.0),
                            ),
                            child: Text(
                              AppBranding.localized(
                                context,
                                zh: '點擊放大',
                                en: 'Tap to zoom',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(
                  Icons.photo_camera_back_outlined,
                  size: 16.0,
                  color: AppBranding.textMuted,
                ),
                const SizedBox(width: 6.0),
                Expanded(
                  child: Text(
                    captureText,
                    style: theme.bodySmall.override(
                      color: AppBranding.textMuted,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _RenameBucketDialog extends StatefulWidget {
  const _RenameBucketDialog({
    required this.initialName,
  });

  final String initialName;

  @override
  State<_RenameBucketDialog> createState() => _RenameBucketDialogState();
}

class _RenameBucketDialogState extends State<_RenameBucketDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
        side: BorderSide(
          color: AppBranding.borderColor.withValues(alpha: 0.75),
        ),
      ),
      title: Text(
        AppBranding.localized(
          context,
          zh: '重新命名飼料桶',
          en: 'Rename Bucket',
        ),
        style: theme.titleLarge.copyWith(
          color: AppBranding.textStrong,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: AppBranding.localized(
              context,
              zh: '飼料桶名稱',
              en: 'Bucket Name',
            ),
            hintText: AppBranding.localized(
              context,
              zh: '請輸入新的飼料桶名稱',
              en: 'Enter a new bucket name',
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(
                color: AppBranding.borderColor.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(
                color: AppBranding.actionColor,
                width: 1.4,
              ),
            ),
          ),
          validator: (value) {
            final nextValue = (value ?? '').trim();
            if (nextValue.isEmpty) {
              return AppBranding.localized(
                context,
                zh: '名稱不能空白',
                en: 'Name cannot be empty',
              );
            }
            return null;
          },
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
          child: Text(
            AppBranding.localized(
              context,
              zh: '取消',
              en: 'Cancel',
            ),
          ),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: AppBranding.actionColor,
            foregroundColor: Colors.white,
          ),
          child: Text(
            AppBranding.localized(
              context,
              zh: '儲存',
              en: 'Save',
            ),
          ),
        ),
      ],
    );
  }
}

class _RenameBucketButton extends StatelessWidget {
  const _RenameBucketButton({
    required this.isSaving,
    required this.onPressed,
  });

  final bool isSaving;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999.0),
        onTap: isSaving
            ? null
            : () {
                onPressed();
              },
        child: Ink(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            color: AppBranding.actionColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999.0),
          ),
          child: Center(
            child: isSaving
                ? const SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: AppBranding.actionColor,
                    ),
                  )
                : const Icon(
                    Icons.edit_rounded,
                    size: 18.0,
                    color: AppBranding.actionColor,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SummaryStatusPill extends StatelessWidget {
  const _SummaryStatusPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99.0),
      ),
      child: Text(
        label,
        style: FlutterFlowTheme.of(context).bodySmall.override(
              color: color,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _SummaryMetricTile extends StatelessWidget {
  const _SummaryMetricTile({
    required this.label,
    required this.unit,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String unit;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      constraints: const BoxConstraints(minWidth: 126.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: AppBranding.borderColor.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.bodySmall.override(
              color: AppBranding.textMuted,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 34.0,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  text: value,
                  style: theme.headlineSmall.override(
                    color: valueColor,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                  ),
                  children: unit.isEmpty
                      ? const []
                      : [
                          TextSpan(
                            text: ' $unit',
                            style: theme.titleSmall.override(
                              color: AppBranding.textMuted,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
