import '/backend/api_requests/api_calls.dart';
import '/components/app_branding.dart';
import '/components/date_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/src/utils/webview_aware.dart';
import 'select_page_model.dart';
export 'select_page_model.dart';

class SelectPageWidget extends StatefulWidget {
  const SelectPageWidget({
    super.key,
    this.opIDlist,
    this.farmName,
    this.idList,
  });

  final List<String>? opIDlist;
  final String? farmName;
  final List<String>? idList;

  static String routeName = 'select_page';
  static String routePath = '/selectPage';

  @override
  State<SelectPageWidget> createState() => _SelectPageWidgetState();
}

class _SelectPageWidgetState extends State<SelectPageWidget> {
  late SelectPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedView = 'feed';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectPageModel());

    _initializeBucketSelection();
    _initializeDateControllers();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _initializeBucketSelection() {
    final initialBucketId = widget.idList?.firstOrNull;
    if (initialBucketId == null) {
      return;
    }

    _model.opID = initialBucketId;
    _model.dropDownValue = initialBucketId;
    _model.dropDownValueController ??=
        FormFieldController<String>(initialBucketId);
  }

  void _initializeDateControllers() {
    final initialDate = functions.dateSet('initial', 'date', '1', '1', '1');
    _model.textController1 ??= TextEditingController(
      text: FFAppState().bb.isEmpty ? initialDate : FFAppState().bb,
    );
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(
      text: FFAppState().ba.isEmpty ? initialDate : FFAppState().ba,
    );
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  void _syncDateFields() {
    final fallback = functions.dateSet('initial', 'date', '1', '1', '1');
    _model.textController1?.text =
        FFAppState().bb.isEmpty ? fallback : FFAppState().bb;
    _model.textController2?.text =
        FFAppState().ba.isEmpty ? fallback : FFAppState().ba;
  }

  String _pageTitle(BuildContext context) => AppBranding.localized(
        context,
        zh: '查詢歷史',
        en: 'History',
      );

  String _bucketLabel(BuildContext context) => AppBranding.localized(
        context,
        zh: '飼料桶名稱',
        en: 'Bucket Name',
      );

  String _dateLabel(BuildContext context) => AppBranding.localized(
        context,
        zh: '查詢日期',
        en: 'Date Range',
      );

  String _searchButtonLabel(BuildContext context) => AppBranding.localized(
        context,
        zh: '搜尋資料',
        en: 'Search',
      );

  String _feedViewLabel(BuildContext context) => AppBranding.localized(
        context,
        zh: '剩料圖表',
        en: 'Feed Chart',
      );

  String _alertViewLabel(BuildContext context) => AppBranding.localized(
        context,
        zh: '警示訊息',
        en: 'Alerts',
      );

  Future<void> _pickDate(String range) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        final currentDate = range == 'bb'
            ? (_model.textController1?.text ??
                functions.dateSet('initial', 'date', '1', '1', '1'))
            : (_model.textController2?.text ??
                functions.dateSet('initial', 'date', '1', '1', '1'));

        return Dialog(
          elevation: 0.0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 24.0,
          ),
          backgroundColor: Colors.transparent,
          child: WebViewAware(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(dialogContext).unfocus();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: DateWidget(
                range: range,
                date: currentDate,
              ),
            ),
          ),
        );
      },
    );

    safeSetState(_syncDateFields);
  }

  Future<void> _runSearch() async {
    final selectedId = _model.dropDownValue;
    if (selectedId == null || selectedId.isEmpty) {
      return;
    }

    final defaultDate = functions.dateSet('initial', 'date', '1', '1', '1');
    FFAppState().bb = FFAppState().bb.isEmpty ? defaultDate : FFAppState().bb;
    FFAppState().ba = FFAppState().ba.isEmpty ? defaultDate : FFAppState().ba;
    _syncDateFields();

    _model.selectController = await DatebaseSQLCall.call(
      mode: 'select',
      key: 'any',
      sqlString: 'id,specification,ton',
      sqlWhere: 'id=$selectedId',
      sqlFrom: 'controller',
    );

    final controllerId = getJsonField(
      (_model.selectController?.jsonBody ?? ''),
      r'''$[:].id''',
    ).toString();
    if (controllerId.isEmpty || controllerId == 'null') {
      return;
    }

    _model.selectRecordHigh =
        'SELECT High FROM sensor_record WHERE date BETWEEN \'${functions.dateSet('dateout', 'yyyyMMdd', functions.strsplit(FFAppState().bb, 1), functions.strsplit(FFAppState().bb, 2), functions.strsplit(FFAppState().bb, 3))}000000\' AND \'${functions.dateSet('dateout', 'yyyyMMdd', functions.strsplit(FFAppState().ba, 1), functions.strsplit(FFAppState().ba, 2), functions.strsplit(FFAppState().ba, 3))}235959\' AND `id`=\'$controllerId\'';
    _model.specification = getJsonField(
      (_model.selectController?.jsonBody ?? ''),
      r'''$[:].specification''',
    ).toString();
    _model.ton = getJsonField(
      (_model.selectController?.jsonBody ?? ''),
      r'''$[:].ton''',
    ).toString();
    _model.selectFlag =
        'SELECT date,warning FROM waitflag WHERE date BETWEEN \'${functions.dateSet('dateout', 'yyyyMMdd', functions.strsplit(FFAppState().bb, 1), functions.strsplit(FFAppState().bb, 2), functions.strsplit(FFAppState().bb, 3))}000000\' AND \'${functions.dateSet('dateout', 'yyyyMMdd', functions.strsplit(FFAppState().ba, 1), functions.strsplit(FFAppState().ba, 2), functions.strsplit(FFAppState().ba, 3))}235959\' AND `id`=\'$controllerId\'  ORDER BY date DESC';
    _model.selectChart = functions.selectchart(
      controllerId,
      FFAppState().bb,
      FFAppState().ba,
    );

    safeSetState(() {});

    _model.selectFeedHigh = await DatebaseSQLCall.call(
      mode: 'select',
      key: 'all',
      all: _model.selectRecordHigh,
    );

    _model.selectWaitFlag = await DatebaseSQLCall.call(
      mode: 'select',
      key: 'all',
      all: _model.selectFlag,
    );

    final highValues = (getJsonField(
          (_model.selectFeedHigh?.jsonBody ?? ''),
          r'''$[:].High''',
          true,
        ) as List?) ??
        const [];

    _model.highList = highValues.map((value) => value.toString()).toList();
    _model.feedTime = valueOrDefault<int>(
      functions.feed(
        _model.highList.toList(),
        'time',
        _model.specification,
        _model.ton,
      ),
      0,
    );
    _model.feedTon = valueOrDefault<int>(
      functions.feed(
        _model.highList.toList(),
        'ton',
        _model.specification,
        _model.ton,
      ),
      0,
    );

    safeSetState(() {});
  }

  Widget _buildDropdown(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FlutterFlowDropDown<String>(
      controller: _model.dropDownValueController ??=
          FormFieldController<String>(_model.dropDownValue),
      options: widget.idList ?? const [],
      optionLabels: widget.opIDlist,
      onChanged: (value) {
        safeSetState(() {
          _model.dropDownValue = value;
          _model.opID = value ?? '';
        });
      },
      width: double.infinity,
      height: 56.0,
      textStyle: theme.bodyLarge.override(
        color: AppBranding.textStrong,
        letterSpacing: 0.0,
        fontWeight: FontWeight.w600,
      ),
      hintText: AppBranding.localized(
        context,
        zh: '選擇飼料桶',
        en: 'Choose a bucket',
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppBranding.textMuted,
        size: 24.0,
      ),
      fillColor: Colors.white,
      elevation: 2.0,
      borderColor: AppBranding.borderColor,
      focusBorderColor: AppBranding.actionColor,
      borderWidth: 1.5,
      borderRadius: 18.0,
      margin: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      hidesUnderline: true,
      isOverButton: false,
      isSearchable: false,
      isMultiSelect: false,
    );
  }

  Widget _buildFilterPanel(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: AppBranding.panelDecoration(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useHorizontalDateRow = constraints.maxWidth >= 540.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppBranding.localized(
                  context,
                  zh: '查詢條件',
                  en: 'Filters',
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
                  zh: '先選擇飼料桶與日期範圍，再切換圖表或警示資料。',
                  en: 'Choose a bucket, define the dates, then switch between charts and alerts.',
                ),
                style: theme.bodyMedium.override(
                  color: AppBranding.textMuted,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 18.0),
              _FieldLabel(text: _bucketLabel(context)),
              const SizedBox(height: 8.0),
              _buildDropdown(context),
              const SizedBox(height: 16.0),
              _FieldLabel(text: _dateLabel(context)),
              const SizedBox(height: 8.0),
              if (useHorizontalDateRow)
                Row(
                  children: [
                    Expanded(
                      child: _DatePill(
                        label: AppBranding.localized(
                          context,
                          zh: '開始日期',
                          en: 'Start',
                        ),
                        value: _model.textController1?.text ??
                            functions.dateSet('initial', 'date', '1', '1', '1'),
                        onTap: () => _pickDate('bb'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'to',
                        style: theme.titleSmall.override(
                          color: AppBranding.textMuted,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _DatePill(
                        label: AppBranding.localized(
                          context,
                          zh: '結束日期',
                          en: 'End',
                        ),
                        value: _model.textController2?.text ??
                            functions.dateSet('initial', 'date', '1', '1', '1'),
                        onTap: () => _pickDate('ba'),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _DatePill(
                      label: AppBranding.localized(
                        context,
                        zh: '開始日期',
                        en: 'Start',
                      ),
                      value: _model.textController1?.text ??
                          functions.dateSet('initial', 'date', '1', '1', '1'),
                      onTap: () => _pickDate('bb'),
                    ),
                    const SizedBox(height: 10.0),
                    _DatePill(
                      label: AppBranding.localized(
                        context,
                        zh: '結束日期',
                        en: 'End',
                      ),
                      value: _model.textController2?.text ??
                          functions.dateSet('initial', 'date', '1', '1', '1'),
                      onTap: () => _pickDate('ba'),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _ModeChip(
                    label: _feedViewLabel(context),
                    selected: _selectedView == 'feed',
                    icon: Icons.feed_outlined,
                    onTap: () => safeSetState(() => _selectedView = 'feed'),
                  ),
                  _ModeChip(
                    label: _alertViewLabel(context),
                    selected: _selectedView == 'alerts',
                    icon: Icons.article_outlined,
                    onTap: () => safeSetState(() => _selectedView = 'alerts'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _runSearch,
                    icon: const Icon(Icons.search_rounded),
                    label: Text(_searchButtonLabel(context)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppBranding.dangerColor,
                      foregroundColor: Colors.white,
                      elevation: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: AppBranding.panelDecoration(context),
      child: Column(
        children: [
          Container(
            width: 58.0,
            height: 58.0,
            decoration: BoxDecoration(
              color: const Color(0x1A0B5CAD),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Icon(
              _selectedView == 'feed'
                  ? Icons.query_stats_rounded
                  : Icons.notifications_active_outlined,
              color: AppBranding.actionColor,
              size: 30.0,
            ),
          ),
          const SizedBox(height: 14.0),
          Text(
            AppBranding.localized(
              context,
              zh: '尚未查詢資料',
              en: 'No search results yet',
            ),
            style: theme.titleMedium.override(
              color: AppBranding.textStrong,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6.0),
          Text(
            AppBranding.localized(
              context,
              zh: '請先選擇飼料桶與日期範圍，再載入圖表或警示資料。',
              en: 'Choose a bucket and date range, then search to load charts or alert records.',
            ),
            style: theme.bodyMedium.override(
              color: AppBranding.textMuted,
              letterSpacing: 0.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedResults(BuildContext context) {
    if (_model.selectChart.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: [
            _HistoryMetricCard(
              label: AppBranding.localized(
                context,
                zh: '餵食次數',
                en: 'Feed Count',
              ),
              value: _model.feedTime.toString(),
              icon: Icons.timeline_rounded,
              accentColor: const Color(0xFF17A2B8),
            ),
            _HistoryMetricCard(
              label: AppBranding.localized(
                context,
                zh: '估算餵食量',
                en: 'Estimated Feed',
              ),
              value: _model.feedTon.toString(),
              icon: Icons.scale_rounded,
              accentColor: AppBranding.actionColor,
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: AppBranding.panelDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppBranding.localized(
                  context,
                  zh: '剩料高度圖表',
                  en: 'Feed Level Chart',
                ),
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      color: AppBranding.textStrong,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6.0),
              Text(
                AppBranding.localized(
                  context,
                  zh: '圖表會依照你選擇的日期範圍，從遠端資料服務載入。',
                  en: 'The chart is loaded from the remote data service for the selected date range.',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: AppBranding.textMuted,
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 14.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(18.0),
                child: FlutterFlowWebView(
                  content: _model.selectChart,
                  width: double.infinity,
                  height: 520.0,
                  // WebViewX routes urlBypass through codetabs on web, which
                  // currently breaks this remote chart page.
                  bypass: false,
                  verticalScroll: true,
                  horizontalScroll: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertResults(BuildContext context) {
    final alertItems = (getJsonField(
          (_model.selectWaitFlag?.jsonBody ?? ''),
          r'''$[:]''',
          true,
        ) as List?) ??
        const [];

    if (alertItems.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: AppBranding.panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppBranding.localized(
              context,
              zh: '警示紀錄',
              en: 'Alert Records',
            ),
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  color: AppBranding.textStrong,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6.0),
          Text(
            AppBranding.localized(
              context,
              zh: '資料會依照查詢日期範圍，從新到舊排列。',
              en: 'Records are sorted from newest to oldest within the selected dates.',
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: AppBranding.textMuted,
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 12.0),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: alertItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10.0),
            itemBuilder: (context, index) {
              final alertItem = alertItems[index];
              final rawDate = getJsonField(alertItem, r'''$.date''').toString();
              final warningText =
                  getJsonField(alertItem, r'''$.warning''').toString();

              return Container(
                padding: const EdgeInsets.all(14.0),
                decoration: AppBranding.softPanelDecoration(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: const Color(0x14D64545),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: AppBranding.dangerColor,
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${functions.dateMode(rawDate, 'date')}  ${functions.dateMode(rawDate, 'time')}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  color: AppBranding.textStrong,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            warningText == 'null'
                                ? AppBranding.localized(
                                    context,
                                    zh: '沒有警示內容',
                                    en: 'No warning message',
                                  )
                                : warningText,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  color: AppBranding.textMuted,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.4,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
          title: _pageTitle(context),
          onBack: () => context.pop(),
        ),
        body: AppBranding.buildPageBackground(
          child: SafeArea(
            top: true,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
              children: [
                AppBranding.buildInfoBanner(
                  context,
                  title: valueOrDefault<String>(widget.farmName, '-'),
                  subtitle: AppBranding.localized(
                    context,
                    zh: '查看這個農場的歷史圖表、餵食紀錄與警示資料。',
                    en: 'Review charts, feed history, and alert records for this farm.',
                  ),
                  icon: Icons.manage_search_rounded,
                ),
                const SizedBox(height: 16.0),
                _buildFilterPanel(context),
                const SizedBox(height: 16.0),
                if (_selectedView == 'feed')
                  _buildFeedResults(context)
                else
                  _buildAlertResults(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            color: AppBranding.textStrong,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          decoration: AppBranding.softPanelDecoration(context),
          child: Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: const Color(0x140B5CAD),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppBranding.actionColor,
                  size: 22.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            color: AppBranding.textMuted,
                            letterSpacing: 0.0,
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      value,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            color: AppBranding.textStrong,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppBranding.textMuted,
                size: 22.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : AppBranding.textMuted;
    final background =
        selected ? AppBranding.actionColor : AppBranding.softSurfaceColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: selected
                  ? AppBranding.actionColor
                  : AppBranding.borderColor.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: foreground,
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: foreground,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryMetricCard extends StatelessWidget {
  const _HistoryMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 180.0),
      padding: const EdgeInsets.all(16.0),
      decoration: AppBranding.panelDecoration(context),
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      color: AppBranding.textMuted,
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 4.0),
              Text(
                value,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      color: AppBranding.textStrong,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
