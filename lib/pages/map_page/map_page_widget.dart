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
  static final Uri _farmMapBaseUri = Uri.https(
    'bdw.npust.edu.tw',
    '/F_S/farm-map-dashboard/index.html',
  );

  late MapPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapPageModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Uri? get _farmMapUri {
    final farmId = widget.farmID?.trim() ?? '';
    if (farmId.isEmpty) {
      return null;
    }

    return _farmMapBaseUri.replace(
      queryParameters: <String, String>{
        'CB': farmId,
      },
    );
  }

  Widget _buildMissingFarmState(BuildContext context) {
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
              zh: '\u76ee\u524d\u6c92\u6709\u53ef\u7528\u7684\u8fb2\u5834\u7de8\u865f',
              en: 'No farm ID is currently available',
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
              zh: '\u8acb\u5148\u56de\u5230\u4e3b\u9801\u9078\u64c7\u8fb2\u5834\uff0c\u518d\u91cd\u65b0\u958b\u555f\u5730\u5716\u9801\u9762\u3002',
              en: 'Please select a farm first, then reopen the map page.',
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

  Widget _buildMapPanel(BuildContext context, Uri farmMapUri) {
    return Container(
      decoration: AppBranding.panelDecoration(
        context,
        radius: 24.0,
      ),
      clipBehavior: Clip.antiAlias,
      child: FlutterFlowWebView(
        content: farmMapUri.toString(),
        html: false,
        bypass: false,
        width: double.infinity,
        height: double.infinity,
        verticalScroll: false,
        horizontalScroll: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final farmMapUri = _farmMapUri;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AppBranding.wrapWithEdgeSwipeBack(
        context,
        onBack: () => context.pop(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBranding.buildPageAppBar(
            context,
            title: AppBranding.localized(
              context,
              zh: '\u8fb2\u5834\u5730\u5716',
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
                          hintMessage: AppBranding.localized(
                            context,
                            zh: '\u6703\u4f9d\u64da\u76ee\u524d\u8fb2\u5834\u8f09\u5165\u4f3a\u670d\u5668\u7248\u5730\u5716\uff0c\u53ef\u6aa2\u8996\u5b9a\u4f4d\u3001\u72c0\u614b\u8207\u8def\u7dda\u8cc7\u8a0a\u3002',
                            en: 'Loads the server-hosted farm map for the selected farm, including location, status, and route details.',
                          ),
                          icon: Icons.map_outlined,
                        ),
                        const SizedBox(height: 16.0),
                        Expanded(
                          child: farmMapUri == null
                              ? _buildMissingFarmState(context)
                              : _buildMapPanel(context, farmMapUri),
                        ),
                      ],
                    ),
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
