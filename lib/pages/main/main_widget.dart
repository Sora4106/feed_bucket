import '/components/app_branding.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';
export 'main_model.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  static String routeName = 'main';
  static String routePath = '/main';

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late MainModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _didInitializeSelection = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeSelection();
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _initializeSelection() {
    if (_didInitializeSelection || FFAppState().farmID.isEmpty) {
      return;
    }

    _didInitializeSelection = true;
    final selectedFarmId = FFAppState().farmID.contains(_model.dropDownValue)
        ? _model.dropDownValue!
        : FFAppState().farmID.first;
    _setSelectedFarmId(selectedFarmId, updateView: false);
    safeSetState(() {});
  }

  void _setSelectedFarmId(
    String farmId, {
    bool updateView = true,
  }) {
    _model.dropDownValueController ??= FormFieldController<String>(farmId);
    _model.dropDownValueController!.value = farmId;
    _model.dropDownValue = farmId;

    if (updateView) {
      safeSetState(() {});
    }
  }

  String? get _selectedFarmId =>
      _model.dropDownValue ?? FFAppState().farmID.firstOrNull;

  String? get _selectedFarmName {
    final farmId = _selectedFarmId;
    if (farmId == null) {
      return null;
    }

    final index = FFAppState().farmID.indexOf(farmId);
    if (index < 0 || index >= FFAppState().name.length) {
      return null;
    }

    return FFAppState().name[index];
  }

  String _pageTitle(BuildContext context) => AppBranding.localized(
        context,
        zh: '農場主頁',
        en: 'Farm Home',
      );

  Future<void> _loadCurrentFarmBuckets() async {
    if (_selectedFarmName == null) {
      return;
    }
    await _model.mainreturn(context);
  }

  Future<void> _openSettings() async {
    await _loadCurrentFarmBuckets();
    if (!mounted) {
      return;
    }

    context.pushNamed(
      SetPageWidget.routeName,
      queryParameters: {
        'opIDlist': serializeParam(
          FFAppState().opID,
          ParamType.String,
          isList: true,
        ),
        'farmName': serializeParam(
          _selectedFarmName,
          ParamType.String,
        ),
        'farmIDlist': serializeParam(
          FFAppState().farmID,
          ParamType.String,
          isList: true,
        ),
        'idList': serializeParam(
          FFAppState().id,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls,
      extra: <String, dynamic>{
        '__transition_info__': const TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
        ),
      },
    );
  }

  Future<void> _openMap() async {
    final farmId = _selectedFarmId;
    final farmName = _selectedFarmName;
    if (farmId == null || farmName == null) {
      return;
    }

    if (farmId.isEmpty || !mounted) {
      return;
    }

    context.pushNamed(
      MapPageWidget.routeName,
      queryParameters: {
        'farmID': serializeParam(
          farmId,
          ParamType.String,
        ),
        'farmName': serializeParam(
          farmName,
          ParamType.String,
        ),
      }.withoutNulls,
      extra: <String, dynamic>{
        '__transition_info__': const TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
        ),
      },
    );
  }

  Future<void> _openController() async {
    await _loadCurrentFarmBuckets();
    if (!mounted) {
      return;
    }

    context.pushNamed(
      ControllerPageWidget.routeName,
      queryParameters: {
        'opIDlist': serializeParam(
          FFAppState().opID,
          ParamType.String,
          isList: true,
        ),
        'farmName': serializeParam(
          _selectedFarmName,
          ParamType.String,
        ),
        'farmIDlist': serializeParam(
          FFAppState().farmID,
          ParamType.String,
          isList: true,
        ),
        'idList': serializeParam(
          FFAppState().id,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls,
      extra: <String, dynamic>{
        '__transition_info__': const TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
        ),
      },
    );
  }

  Future<void> _openHistory() async {
    FFAppState().bb = '';
    FFAppState().ba = '';

    await _loadCurrentFarmBuckets();
    if (!mounted) {
      return;
    }

    context.pushNamed(
      SelectPageWidget.routeName,
      queryParameters: {
        'opIDlist': serializeParam(
          FFAppState().opID,
          ParamType.String,
          isList: true,
        ),
        'farmName': serializeParam(
          _selectedFarmName,
          ParamType.String,
        ),
        'idList': serializeParam(
          FFAppState().id,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls,
      extra: <String, dynamic>{
        '__transition_info__': const TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
        ),
      },
    );
  }

  Widget _buildFarmSelectorCard(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

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
              zh: '場域選擇',
              en: 'Farm Selector',
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
              zh: '請先選擇要操作的場域，再進入下方功能。',
              en: 'Choose the working farm first, then open one of the actions below.',
            ),
            style: theme.bodyMedium.override(
              color: AppBranding.textMuted,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 14.0),
          FlutterFlowDropDown<String>(
            controller: _model.dropDownValueController ??=
                FormFieldController<String>(_selectedFarmId),
            options: FFAppState().farmID,
            optionLabels: FFAppState().name,
            onChanged: (value) {
              if (value != null) {
                _setSelectedFarmId(value);
              }
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
              zh: '請選擇場域',
              en: 'Choose a farm',
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppBranding.textMuted,
              size: 24.0,
            ),
            fillColor: AppBranding.softSurfaceColor,
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
          ),
        ],
      ),
    );
  }

  List<_MainActionItem> _buildActions(BuildContext context) {
    return [
      _MainActionItem(
        title: AppBranding.localized(
          context,
          zh: '系統設定',
          en: 'Settings',
        ),
        subtitle: AppBranding.localized(
          context,
          zh: '設定飼料桶參數',
          en: 'Bucket parameters',
        ),
        icon: Icons.settings_rounded,
        accentColor: const Color(0xFF2E8B57),
        onTap: _openSettings,
      ),
      _MainActionItem(
        title: AppBranding.localized(
          context,
          zh: '農場地圖',
          en: 'Farm Map',
        ),
        subtitle: AppBranding.localized(
          context,
          zh: '查看場域地圖',
          en: 'Map view',
        ),
        icon: Icons.map_outlined,
        accentColor: const Color(0xFFF3A530),
        onTap: _openMap,
      ),
      _MainActionItem(
        title: AppBranding.localized(
          context,
          zh: '裝置控制',
          en: 'Controls',
        ),
        subtitle: AppBranding.localized(
          context,
          zh: '查看資訊卡',
          en: 'Bucket cards',
        ),
        icon: Icons.precision_manufacturing_rounded,
        accentColor: const Color(0xFF0B5CAD),
        onTap: _openController,
      ),
      _MainActionItem(
        title: AppBranding.localized(
          context,
          zh: '查詢歷史',
          en: 'History',
        ),
        subtitle: AppBranding.localized(
          context,
          zh: '圖表與警示',
          en: 'Charts and alerts',
        ),
        icon: Icons.manage_search_rounded,
        accentColor: const Color(0xFFD64545),
        onTap: _openHistory,
      ),
    ];
  }

  Widget _buildActionPanel(BuildContext context) {
    final actions = _buildActions(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 920.0;
        final spacing = 14.0;
        final cardWidth = isWide
            ? (constraints.maxWidth - (spacing * 3)) / 4
            : (constraints.maxWidth - spacing) / 2;
        final cardHeight = isWide ? 182.0 : 198.0;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: actions
              .map(
                (action) => SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _ActionDashboardCard(
                    title: action.title,
                    subtitle: action.subtitle,
                    icon: action.icon,
                    accentColor: action.accentColor,
                    onTap: action.onTap,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildBackgroundLayer() {
    return DecoratedBox(
      decoration: AppBranding.pageBackgroundDecoration(),
      child: Stack(
        children: [
          Positioned(
            top: -120.0,
            right: -80.0,
            child: Container(
              width: 260.0,
              height: 260.0,
              decoration: const BoxDecoration(
                color: Color(0x1F0B5CAD),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -110.0,
            left: -90.0,
            child: IgnorePointer(
              child: Container(
                width: 240.0,
                height: 240.0,
                decoration: const BoxDecoration(
                  color: Color(0x1FF3A530),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    if (!_didInitializeSelection) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _initializeSelection();
        }
      });
    }

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
          onBack: () => context.safePop(),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackgroundLayer(),
            SafeArea(
              top: true,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 24.0),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildFarmSelectorCard(context),
                              const SizedBox(height: 18.0),
                              _buildActionPanel(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainActionItem {
  const _MainActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Future<void> Function() onTap;
}

class _ActionDashboardCard extends StatelessWidget {
  const _ActionDashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 720.0;
    final cardRadius = isCompact ? 20.0 : 22.0;
    final cardPadding = isCompact ? 18.0 : 20.0;
    final iconBadgeSize = isCompact ? 68.0 : 72.0;
    final iconBadgeRadius = isCompact ? 20.0 : 22.0;
    final iconSize = isCompact ? 38.0 : 40.0;
    final dotSize = isCompact ? 12.0 : 13.0;
    final dotInset = isCompact ? 11.0 : 12.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(cardRadius),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardRadius),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                accentColor.withValues(alpha: 0.12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.35),
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 16.0,
                color: Color(0x12000000),
                offset: Offset(0.0, 8.0),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: iconBadgeSize,
                  height: iconBadgeSize,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(iconBadgeRadius),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: dotInset,
                        right: dotInset,
                        child: Container(
                          width: dotSize,
                          height: dotSize,
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(99.0),
                          ),
                        ),
                      ),
                      Icon(
                        icon,
                        color: accentColor,
                        size: iconSize,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: theme.titleMedium.override(
                    color: AppBranding.textStrong,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.bodyMedium.override(
                    color: AppBranding.textMuted,
                    letterSpacing: 0.0,
                    lineHeight: 1.35,
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
