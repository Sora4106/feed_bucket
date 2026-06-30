import '/backend/api_requests/api_calls.dart';
import '/components/app_branding.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetPageWidget extends StatefulWidget {
  const SetPageWidget({
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

  static String routeName = 'set_page';
  static String routePath = '/setPage';

  @override
  State<SetPageWidget> createState() => _SetPageWidgetState();
}

class _SetPageWidgetState extends State<SetPageWidget> {
  static const _settingsSqlFields =
      'specification,wupvalue,wdownvalue,read_time,Feed_day,ton,temp_range,RH_range,feed_density';

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _bucketHeightController = TextEditingController();
  final _fullAlertController = TextEditingController();
  final _lowAlertController = TextEditingController();
  final _readTimeController = TextEditingController();
  final _shelfLifeController = TextEditingController();
  final _feedPerSprayController = TextEditingController();
  final _feedDensityController = TextEditingController();
  final _tempMinController = TextEditingController();
  final _tempMaxController = TextEditingController();
  final _humidityMinController = TextEditingController();
  final _humidityMaxController = TextEditingController();

  String? _selectedControllerId;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _syncControllersFromAppState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firstControllerId =
          _controllerIds.isNotEmpty ? _controllerIds.first : null;
      if (firstControllerId != null) {
        _loadControllerSettings(firstControllerId, updateSelection: true);
      }
    });
  }

  @override
  void dispose() {
    _bucketHeightController.dispose();
    _fullAlertController.dispose();
    _lowAlertController.dispose();
    _readTimeController.dispose();
    _shelfLifeController.dispose();
    _feedPerSprayController.dispose();
    _feedDensityController.dispose();
    _tempMinController.dispose();
    _tempMaxController.dispose();
    _humidityMinController.dispose();
    _humidityMaxController.dispose();
    super.dispose();
  }

  List<String> get _controllerIds {
    final ids = widget.idList ?? const <String>[];
    return ids.where((id) => id.trim().isNotEmpty).toList(growable: false);
  }

  List<String> get _controllerLabels {
    final labels = widget.opIDlist ?? const <String>[];
    final limit = labels.length < _controllerIds.length
        ? labels.length
        : _controllerIds.length;
    return labels.take(limit).toList(growable: false);
  }

  String _localized({
    required String zh,
    required String en,
  }) {
    return AppBranding.localized(
      context,
      zh: zh,
      en: en,
    );
  }

  String _controllerLabelForId(String? controllerId) {
    if (controllerId == null || controllerId.isEmpty) {
      return _localized(
        zh: '尚未選擇',
        en: 'Not selected',
      );
    }

    final index = _controllerIds.indexOf(controllerId);
    if (index < 0 || index >= _controllerLabels.length) {
      return controllerId;
    }

    return _controllerLabels[index];
  }

  String _formatWholeNumber(String? value) {
    final parsed = int.tryParse((value ?? '').trim());
    return parsed?.toString() ?? (value ?? '').trim();
  }

  String _formatRangeValue(String range, int index) {
    final parts = range.split('-');
    if (index < 1 || index > parts.length) {
      return '';
    }

    return _formatWholeNumber(parts[index - 1]);
  }

  void _syncControllersFromAppState() {
    _bucketHeightController.text =
        _formatWholeNumber(FFAppState().setdate.feedBucketHeight);
    _fullAlertController.text =
        _formatWholeNumber(FFAppState().setdate.fullBucketAlert);
    _lowAlertController.text =
        _formatWholeNumber(FFAppState().setdate.lowFeedAlert);
    _readTimeController.text =
        _formatWholeNumber(FFAppState().setdate.dataTransmissionInterval);
    _shelfLifeController.text =
        _formatWholeNumber(FFAppState().setdate.shelfLife);
    _feedPerSprayController.text =
        _formatWholeNumber(FFAppState().setdate.feedSprayCount);
    _feedDensityController.text = FFAppState().setdate.feedDensity.trim();
    _tempMinController.text =
        _formatRangeValue(FFAppState().setdate.temperatureRange, 1);
    _tempMaxController.text =
        _formatRangeValue(FFAppState().setdate.temperatureRange, 2);
    _humidityMinController.text =
        _formatRangeValue(FFAppState().setdate.humidityRange, 1);
    _humidityMaxController.text =
        _formatRangeValue(FFAppState().setdate.humidityRange, 2);
  }

  void _syncAppStateFromResponse(ApiCallResponse response) {
    FFAppState().updateSetdateStruct(
      (draft) => draft
        ..feedBucketHeight = DatebaseSQLCall.sp(response.jsonBody ?? '')
        ..fullBucketAlert = DatebaseSQLCall.wUpValue(response.jsonBody ?? '')
        ..lowFeedAlert = DatebaseSQLCall.wDownValue(response.jsonBody ?? '')
        ..dataTransmissionInterval =
            DatebaseSQLCall.readTime(response.jsonBody ?? '')
        ..shelfLife = DatebaseSQLCall.feedDay(response.jsonBody ?? '')
        ..feedSprayCount = DatebaseSQLCall.ton(response.jsonBody ?? '')
        ..temperatureRange = DatebaseSQLCall.tempRange(response.jsonBody ?? '')
        ..humidityRange = DatebaseSQLCall.rHrange(response.jsonBody ?? '')
        ..feedDensity =
            DatebaseSQLCall.feedDensity(response.jsonBody ?? '').toString(),
    );
  }

  void _syncAppStateFromForm() {
    FFAppState().updateSetdateStruct(
      (draft) => draft
        ..feedBucketHeight = _bucketHeightController.text.trim()
        ..fullBucketAlert = _fullAlertController.text.trim()
        ..lowFeedAlert = _lowAlertController.text.trim()
        ..dataTransmissionInterval = _readTimeController.text.trim()
        ..shelfLife = _shelfLifeController.text.trim()
        ..feedSprayCount = _feedPerSprayController.text.trim()
        ..temperatureRange =
            '${_tempMinController.text.trim()}-${_tempMaxController.text.trim()}'
        ..humidityRange =
            '${_humidityMinController.text.trim()}-${_humidityMaxController.text.trim()}'
        ..feedDensity = _feedDensityController.text.trim(),
    );
  }

  Future<ApiCallResponse?> _fetchControllerSettings(String controllerId) {
    return DatebaseSQLCall.call(
      mode: 'select',
      key: 'any',
      sqlString: _settingsSqlFields,
      sqlWhere: 'id=$controllerId',
      sqlFrom: 'controller',
    );
  }

  Future<void> _loadControllerSettings(
    String controllerId, {
    required bool updateSelection,
  }) async {
    setState(() {
      if (updateSelection) {
        _selectedControllerId = controllerId;
      }
      _isLoading = true;
    });

    final response = await _fetchControllerSettings(controllerId);
    if (!mounted) {
      return;
    }

    if (response != null && response.succeeded) {
      _syncAppStateFromResponse(response);
      _syncControllersFromAppState();
    } else {
      _showSnackBar(
        _localized(
          zh: '無法讀取控制器設定',
          en: 'Unable to load controller settings',
        ),
        isError: true,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showResultDialog({
    required String title,
    required String message,
    required bool success,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
            side: BorderSide(
              color: AppBranding.borderColor.withValues(alpha: 0.75),
            ),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 8.0),
          actionsPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          title: Row(
            children: [
              Icon(
                success ? Icons.check_circle_rounded : Icons.error_rounded,
                color: success
                    ? AppBranding.successColor
                    : AppBranding.dangerColor,
                size: 28.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  title,
                  style: theme.titleLarge.copyWith(
                    color: AppBranding.textStrong,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: theme.bodyMedium.copyWith(
              color: AppBranding.textMuted,
              height: 1.5,
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: AppBranding.actionColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 14.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              child: Text(
                _localized(
                  zh: '確定',
                  en: 'OK',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? AppBranding.dangerColor : AppBranding.actionColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String? _requiredWholeNumberValidator(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return _localized(
        zh: '請輸入數值',
        en: 'Please enter a value',
      );
    }
    if (int.tryParse(text) == null) {
      return _localized(
        zh: '請輸入整數',
        en: 'Please enter a whole number',
      );
    }
    return null;
  }

  String? _requiredDecimalValidator(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return _localized(
        zh: '請輸入數值',
        en: 'Please enter a value',
      );
    }
    if (double.tryParse(text) == null) {
      return _localized(
        zh: '請輸入有效數字',
        en: 'Please enter a valid number',
      );
    }
    return null;
  }

  bool _validateRanges() {
    final tempMin = int.tryParse(_tempMinController.text.trim());
    final tempMax = int.tryParse(_tempMaxController.text.trim());
    final humidityMin = int.tryParse(_humidityMinController.text.trim());
    final humidityMax = int.tryParse(_humidityMaxController.text.trim());

    if (tempMin == null ||
        tempMax == null ||
        humidityMin == null ||
        humidityMax == null) {
      return false;
    }

    if (tempMin > tempMax) {
      _showSnackBar(
        _localized(
          zh: '溫度範圍起始值不可大於結束值',
          en: 'Temperature range start cannot exceed end',
        ),
        isError: true,
      );
      return false;
    }

    if (humidityMin > humidityMax) {
      _showSnackBar(
        _localized(
          zh: '濕度範圍起始值不可大於結束值',
          en: 'Humidity range start cannot exceed end',
        ),
        isError: true,
      );
      return false;
    }

    return true;
  }

  String _leftPad(String value, int width) {
    return value.trim().padLeft(width, '0');
  }

  Future<void> _saveSettings() async {
    FocusScope.of(context).unfocus();

    if (_selectedControllerId == null || _selectedControllerId!.isEmpty) {
      _showSnackBar(
        _localized(
          zh: '請先選擇控制器',
          en: 'Please choose a controller first',
        ),
        isError: true,
      );
      return;
    }

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid || !_validateRanges()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final response = await DatebaseSQLCall.call(
      mode: 'update',
      key: 'any',
      sqlString: 'specification=${_leftPad(_bucketHeightController.text, 3)},'
          'wupvalue=${_leftPad(_fullAlertController.text, 3)},'
          'wdownvalue=${_leftPad(_lowAlertController.text, 3)},'
          'read_time=${_leftPad(_readTimeController.text, 3)},'
          'Feed_day=${_leftPad(_shelfLifeController.text, 2)},'
          'ton=${_leftPad(_feedPerSprayController.text, 3)},'
          'temp_range=${_tempMinController.text.trim()}-${_tempMaxController.text.trim()},'
          'RH_range=${_humidityMinController.text.trim()}-${_humidityMaxController.text.trim()},'
          'feed_density=${_feedDensityController.text.trim()}',
      sqlWhere: 'id=$_selectedControllerId',
      sqlSheet: 'controller',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    if (response.succeeded) {
      _syncAppStateFromForm();
      await _showResultDialog(
        title: _localized(
          zh: '儲存完成',
          en: 'Saved',
        ),
        message: _localized(
          zh: '控制器設定已更新。',
          en: 'Controller settings have been updated.',
        ),
        success: true,
      );
      return;
    }

    await _showResultDialog(
      title: _localized(
        zh: '儲存失敗',
        en: 'Save failed',
      ),
      message: _localized(
        zh: '請稍後再試，或確認資料庫連線是否正常。',
        en: 'Please try again later or verify the database connection.',
      ),
      success: false,
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return InputDecoration(
      hintText: hintText,
      hintStyle: theme.bodyMedium.copyWith(
        color: AppBranding.textMuted.withValues(alpha: 0.7),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(
          color: AppBranding.borderColor.withValues(alpha: 0.8),
          width: 1.4,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(
          color: AppBranding.actionColor,
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(
          color: AppBranding.dangerColor,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(
          color: AppBranding.dangerColor,
          width: 2.0,
        ),
      ),
    );
  }

  Widget _buildFarmSummaryCard() {
    return AppBranding.buildInfoBanner(
      context,
      title: (widget.farmName ?? '').trim().isEmpty
          ? '-'
          : widget.farmName!.trim(),
      hintMessage: _localized(
        zh: '調整這個農場目前控制器的系統參數與警示設定。',
        en: 'Adjust controller settings and alert thresholds for this farm.',
      ),
      icon: Icons.settings_rounded,
    );
  }

  Widget _buildCurrentControllerChip(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0x1A0B5CAD),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        '${_localized(zh: '目前控制器', en: 'Controller')}: ${_controllerLabelForId(_selectedControllerId)}',
        style: theme.titleSmall.copyWith(
          color: AppBranding.actionColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildControllerSelectorCard() {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: AppBranding.panelDecoration(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 760.0;
          final selector = DropdownButtonFormField<String>(
            initialValue: _controllerIds.contains(_selectedControllerId)
                ? _selectedControllerId
                : null,
            decoration: _inputDecoration(),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            borderRadius: BorderRadius.circular(18.0),
            dropdownColor: Colors.white,
            style: theme.bodyLarge.copyWith(
              color: AppBranding.textStrong,
              fontWeight: FontWeight.w600,
            ),
            items: [
              for (final id in _controllerIds)
                DropdownMenuItem<String>(
                  value: id,
                  child: Text(_controllerLabelForId(id)),
                ),
            ],
            onChanged: (_isLoading || _isSaving)
                ? null
                : (value) {
                    if (value == null || value == _selectedControllerId) {
                      return;
                    }
                    _loadControllerSettings(value, updateSelection: true);
                  },
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _localized(
                    zh: '選擇控制器',
                    en: 'Choose Controller',
                  ),
                  style: theme.titleLarge.copyWith(
                    color: AppBranding.textStrong,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10.0),
                _buildCurrentControllerChip(theme),
                const SizedBox(height: 14.0),
                selector,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      _localized(
                        zh: '選擇控制器',
                        en: 'Choose Controller',
                      ),
                      style: theme.titleLarge.copyWith(
                        color: AppBranding.textStrong,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _buildCurrentControllerChip(theme),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              SizedBox(
                width: 320.0,
                child: selector,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: AppBranding.panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localized(
              zh: '目前沒有可設定的控制器',
              en: 'No controllers available',
            ),
            style: theme.titleLarge.copyWith(
              color: AppBranding.textStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            _localized(
              zh: '請先回到農場主頁選擇有效場域，或確認該農場是否已有控制器資料。',
              en: 'Please go back and choose a valid farm, or verify that the farm already has controller data.',
            ),
            style: theme.bodyMedium.copyWith(
              color: AppBranding.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldWidth = constraints.maxWidth >= 980.0
            ? (constraints.maxWidth - 16.0) / 2.0
            : constraints.maxWidth;

        return Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: [
            SizedBox(
              width: fieldWidth,
              child: _SettingFieldCard(
                label: _localized(
                  zh: '飼料桶高度',
                  en: 'Bucket Height',
                ),
                unit: 'cm',
                controller: _bucketHeightController,
                validator: _requiredWholeNumberValidator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _SettingFieldCard(
                label: _localized(
                  zh: '滿桶警戒',
                  en: 'Full Bucket Alert',
                ),
                unit: 'cm',
                controller: _fullAlertController,
                validator: _requiredWholeNumberValidator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _SettingFieldCard(
                label: _localized(
                  zh: '低料警戒',
                  en: 'Low Feed Alert',
                ),
                unit: 'cm',
                controller: _lowAlertController,
                validator: _requiredWholeNumberValidator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _SettingFieldCard(
                label: _localized(
                  zh: '資料傳輸間隔',
                  en: 'Transmission Interval',
                ),
                unit: 'min',
                controller: _readTimeController,
                validator: _requiredWholeNumberValidator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _SettingFieldCard(
                label: _localized(
                  zh: '保鮮天數',
                  en: 'Shelf Life',
                ),
                unit: 'day',
                controller: _shelfLifeController,
                validator: _requiredWholeNumberValidator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _SettingFieldCard(
                label: _localized(
                  zh: '單次噴料量',
                  en: 'Feed Per Spray',
                ),
                unit: 'ton',
                controller: _feedPerSprayController,
                validator: _requiredWholeNumberValidator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _SettingFieldCard(
                label: _localized(
                  zh: '飼料密度',
                  en: 'Feed Density',
                ),
                unit: 'kg/L',
                controller: _feedDensityController,
                validator: _requiredDecimalValidator,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _RangeFieldCard(
                label: _localized(
                  zh: '溫度範圍',
                  en: 'Temperature Range',
                ),
                unit: '°C',
                startController: _tempMinController,
                endController: _tempMaxController,
                validator: _requiredWholeNumberValidator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _RangeFieldCard(
                label: _localized(
                  zh: '濕度範圍',
                  en: 'Humidity Range',
                ),
                unit: '%',
                startController: _humidityMinController,
                endController: _humidityMaxController,
                validator: _requiredWholeNumberValidator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasControllers = _controllerIds.isNotEmpty;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBranding.buildPageAppBar(
          context,
          title: _localized(
            zh: '系統設定',
            en: 'System Settings',
          ),
          onBack: () => Navigator.of(context).maybePop(),
        ),
        body: SafeArea(
          top: true,
          child: AppBranding.buildPageBackground(
            child: Column(
              children: [
                if (_isLoading)
                  const LinearProgressIndicator(
                    minHeight: 3.0,
                    color: AppBranding.actionColor,
                    backgroundColor: Color(0x220B5CAD),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1180.0),
                        child: Form(
                          key: _formKey,
                          child: AbsorbPointer(
                            absorbing: _isLoading || _isSaving,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildFarmSummaryCard(),
                                const SizedBox(height: 16.0),
                                if (hasControllers) ...[
                                  _buildControllerSelectorCard(),
                                  const SizedBox(height: 16.0),
                                  _buildSettingsGrid(),
                                ] else
                                  _buildEmptyState(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (hasControllers)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 54.0,
                          child: FilledButton.icon(
                            onPressed: _isSaving ? null : _saveSettings,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppBranding.successColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              textStyle: theme.titleSmall.copyWith(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.save_rounded),
                            label: Text(
                              _isSaving
                                  ? _localized(
                                      zh: '儲存中...',
                                      en: 'Saving...',
                                    )
                                  : _localized(
                                      zh: '儲存設定',
                                      en: 'Save Settings',
                                    ),
                            ),
                          ),
                        ),
                      ),
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

class _SettingFieldCard extends StatelessWidget {
  const _SettingFieldCard({
    required this.label,
    required this.unit,
    required this.controller,
    required this.validator,
    this.keyboardType = TextInputType.number,
    this.inputFormatters = const <TextInputFormatter>[],
  });

  final String label;
  final String unit;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: AppBranding.softPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.titleMedium.copyWith(
              color: AppBranding.textStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(
                        color: AppBranding.borderColor.withValues(alpha: 0.8),
                        width: 1.4,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      borderSide: BorderSide(
                        color: AppBranding.actionColor,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      borderSide: BorderSide(
                        color: AppBranding.dangerColor,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      borderSide: BorderSide(
                        color: AppBranding.dangerColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: theme.bodyLarge.copyWith(
                    color: AppBranding.textStrong,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  validator: validator,
                ),
              ),
              const SizedBox(width: 12.0),
              _UnitBadge(unit: unit),
            ],
          ),
        ],
      ),
    );
  }
}

class _RangeFieldCard extends StatelessWidget {
  const _RangeFieldCard({
    required this.label,
    required this.unit,
    required this.startController,
    required this.endController,
    required this.validator,
    this.inputFormatters = const <TextInputFormatter>[],
  });

  final String label;
  final String unit;
  final TextEditingController startController;
  final TextEditingController endController;
  final String? Function(String?) validator;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    InputDecoration rangeDecoration() {
      return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: AppBranding.borderColor.withValues(alpha: 0.8),
            width: 1.4,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          borderSide: BorderSide(
            color: AppBranding.actionColor,
            width: 2.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          borderSide: BorderSide(
            color: AppBranding.dangerColor,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          borderSide: BorderSide(
            color: AppBranding.dangerColor,
            width: 2.0,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: AppBranding.softPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.titleMedium.copyWith(
              color: AppBranding.textStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: startController,
                  keyboardType: TextInputType.number,
                  inputFormatters: inputFormatters,
                  decoration: rangeDecoration(),
                  style: theme.bodyLarge.copyWith(
                    color: AppBranding.textStrong,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  validator: validator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 14.0,
                ),
                child: Text(
                  '~',
                  style: theme.titleLarge.copyWith(
                    color: AppBranding.textStrong,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: endController,
                  keyboardType: TextInputType.number,
                  inputFormatters: inputFormatters,
                  decoration: rangeDecoration(),
                  style: theme.bodyLarge.copyWith(
                    color: AppBranding.textStrong,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  validator: validator,
                ),
              ),
              const SizedBox(width: 12.0),
              _UnitBadge(unit: unit),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnitBadge extends StatelessWidget {
  const _UnitBadge({
    required this.unit,
  });

  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FA),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: AppBranding.borderColor.withValues(alpha: 0.72),
        ),
      ),
      child: Text(
        unit,
        style: theme.titleSmall.copyWith(
          color: AppBranding.textStrong,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
