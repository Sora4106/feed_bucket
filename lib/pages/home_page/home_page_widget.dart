import '/components/app_branding.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _goToLogin() {
    final hasRememberedCredentials = FFAppState().check &&
        FFAppState().accountNumber.trim().isNotEmpty &&
        FFAppState().password.isNotEmpty;

    context.pushNamed(
      LoginWidget.routeName,
      extra: <String, dynamic>{
        'autoLogin': hasRememberedCredentials,
      },
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
        body: SafeArea(
          top: true,
          child: AppBranding.buildPageBackground(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28.0),
                        decoration:
                            AppBranding.panelDecoration(context, radius: 28.0),
                        child: Column(
                          children: [
                            AppBranding.buildLogoBadge(
                              context,
                              width: 180.0,
                              height: 108.0,
                            ),
                            const SizedBox(height: 22.0),
                            Text(
                              AppBranding.localized(
                                context,
                                zh: '\u98FC\u6599\u6876\u76E3\u6E2C\u7CFB\u7D71',
                                en: 'Feed Bucket Monitor',
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    color: AppBranding.textStrong,
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              AppBranding.localized(
                                context,
                                zh: '\u5373\u6642\u67E5\u770B\u8FB2\u5834\u72C0\u614B\u3001\u63A7\u5236\u5668\u8CC7\u6599\u3001\u8B66\u793A\u901A\u77E5\u8207\u7CFB\u7D71\u8A2D\u5B9A\u3002',
                                en: 'A field-friendly dashboard for farm status, controller data, alerts, and settings.',
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    color: AppBranding.textMuted,
                                    letterSpacing: 0.0,
                                    lineHeight: 1.5,
                                  ),
                            ),
                            const SizedBox(height: 28.0),
                            SizedBox(
                              width: 260.0,
                              child: ElevatedButton.icon(
                                onPressed: _goToLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppBranding.actionColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 18.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                icon: const Icon(Icons.login_rounded),
                                label: Text(
                                  AppBranding.localized(
                                    context,
                                    zh: '\u9032\u5165\u7CFB\u7D71',
                                    en: 'Open Dashboard',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      Text(
                        'v${FFAppState().versionName}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              color: AppBranding.textMuted,
                              letterSpacing: 0.0,
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
