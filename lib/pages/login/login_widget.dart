import '/backend/api_requests/api_calls.dart';
import '/components/app_branding.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({
    super.key,
    this.autoLogin = false,
  });

  static String routeName = 'login';
  static String routePath = '/login';

  final bool autoLogin;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _didAttemptAutoLogin = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();
    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      safeSetState(() {
        _model.checkboxValue = FFAppState().check;
        _model.emailAddressTextController?.text = FFAppState().accountNumber;
        _model.passwordTextController?.text = FFAppState().password;
      });

      await _maybeAutoLogin();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _showLoginAlert({
    required String title,
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (alertDialogContext) {
        return WebViewAware(
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text(
                  AppBranding.localized(
                    context,
                    zh: '\u78ba\u5b9a',
                    en: 'OK',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _maybeAutoLogin() async {
    final hasRememberedCredentials = FFAppState().check &&
        FFAppState().accountNumber.trim().isNotEmpty &&
        FFAppState().password.isNotEmpty;

    if (_didAttemptAutoLogin ||
        !widget.autoLogin ||
        !hasRememberedCredentials) {
      return;
    }

    _didAttemptAutoLogin = true;
    await _attemptLogin();
  }

  Future<void> _attemptLogin() async {
    if (_isSubmitting) {
      return;
    }

    safeSetState(() {
      _isSubmitting = true;
    });

    var shouldSetState = false;

    try {
      final accountNumber =
          (_model.emailAddressTextController?.text ?? '').trim();
      final password = _model.passwordTextController?.text ?? '';

      _model.account = await DatebaseSQLCall.call(
        mode: 'select',
        key: 'any',
        sqlString: 'password,farmID',
        sqlWhere: 'account_number=$accountNumber',
        sqlFrom: 'user',
      );
      shouldSetState = true;

      if (!(_model.account?.succeeded ?? false)) {
        await _showLoginAlert(
          title: AppBranding.localized(
            context,
            zh: '\u67e5\u7121\u5e33\u865f',
            en: 'Account not found',
          ),
          message: AppBranding.localized(
            context,
            zh: '\u627e\u4e0d\u5230\u6b64\u5e33\u865f\u8cc7\u6599\uff0c\u8acb\u78ba\u8a8d\u5e33\u865f\u6216\u8cc7\u6599\u5eab\u9023\u7dda\u72c0\u614b\u3002',
            en: 'No account data was found. Please verify the account or database connection.',
          ),
        );
        return;
      }

      final passwordMatches =
          DatebaseSQLCall.password((_model.account?.jsonBody ?? '')) ==
              password;

      if (!passwordMatches) {
        await _showLoginAlert(
          title: AppBranding.localized(
            context,
            zh: '\u767b\u5165\u5931\u6557',
            en: 'Login failed',
          ),
          message: AppBranding.localized(
            context,
            zh: '\u5e33\u865f\u6216\u5bc6\u78bc\u932f\u8aa4\uff0c\u8acb\u91cd\u65b0\u8f38\u5165\u3002',
            en: 'Incorrect account or password. Please try again.',
          ),
        );
        return;
      }

      _model.login = await DatebaseSQLCall.call(
        mode: 'select',
        key: 'more_condition',
        sqlString: 'id,name',
        sqlWhere: DatebaseSQLCall.farmID((_model.account?.jsonBody ?? '')),
        sqlFrom: 'regional_information',
      );
      shouldSetState = true;

      final farmIds =
          DatebaseSQLCall.id((_model.login?.jsonBody ?? ''))?.toList() ??
              const <String>[];
      final farmNames =
          DatebaseSQLCall.name((_model.login?.jsonBody ?? ''))?.toList() ??
              const <String>[];
      final pairCount =
          farmIds.length < farmNames.length ? farmIds.length : farmNames.length;
      final visibleFarmIds = farmIds.take(pairCount).toList();
      final visibleFarmNames = farmNames.take(pairCount).toList();
      final sortOrder = functions.sortIndicesByNaturalOrder(visibleFarmNames);

      FFAppState().farmID = [
        for (final index in sortOrder) visibleFarmIds[index],
      ];
      FFAppState().name = [
        for (final index in sortOrder) visibleFarmNames[index],
      ];

      if (FFAppState().check) {
        FFAppState().accountNumber = accountNumber;
        FFAppState().password = password;
      } else {
        FFAppState().accountNumber = '';
        FFAppState().password = '';
        safeSetState(() {
          _model.emailAddressTextController?.clear();
          _model.passwordTextController?.clear();
        });
      }

      if (!mounted) {
        return;
      }

      context.pushNamed(MainWidget.routeName);
    } finally {
      if (!mounted) {
        _isSubmitting = false;
        return;
      }

      safeSetState(() {
        _isSubmitting = false;
      });

      if (shouldSetState) {
        safeSetState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AppBranding.wrapWithEdgeSwipeBack(
        context,
        onBack: () => context.safePop(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBranding.buildPageAppBar(
            context,
            title: AppBranding.localized(
              context,
              zh: '\u767b\u5165',
              en: 'Sign In',
            ),
            onBack: () => context.safePop(),
          ),
          body: SafeArea(
            top: true,
            child: AppBranding.buildPageBackground(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460.0),
                    child: Container(
                      padding: const EdgeInsets.all(28.0),
                      decoration:
                          AppBranding.panelDecoration(context, radius: 28.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppBranding.buildLogoBadge(
                            context,
                            width: 160.0,
                            height: 96.0,
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            AppBranding.localized(
                              context,
                              zh: '\u4f7f\u7528\u8005\u767b\u5165',
                              en: 'Staff Sign In',
                            ),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  color: AppBranding.textStrong,
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            AppBranding.localized(
                              context,
                              zh: '\u8f38\u5165\u5e33\u865f\u8207\u5bc6\u78bc\u5f8c\u5373\u53ef\u958b\u555f\u76e3\u6e2c\u4e3b\u9801\u3002',
                              en: 'Use your account and password to open the monitoring dashboard.',
                            ),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  color: AppBranding.textMuted,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.5,
                                ),
                          ),
                          const SizedBox(height: 24.0),
                          TextFormField(
                            controller: _model.emailAddressTextController,
                            focusNode: _model.emailAddressFocusNode,
                            autofocus: !widget.autoLogin,
                            autofillHints: const [AutofillHints.username],
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: AppBranding.localized(
                                context,
                                zh: '\u5e33\u865f',
                                en: 'Account',
                              ),
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    color: AppBranding.textMuted,
                                  ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                    ),
                            validator: _model
                                .emailAddressTextControllerValidator
                                .asValidator(context),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _model.passwordTextController,
                            focusNode: _model.passwordFocusNode,
                            autofocus: false,
                            autofillHints: const [AutofillHints.password],
                            obscureText: !_model.passwordVisibility,
                            decoration: InputDecoration(
                              labelText: AppBranding.localized(
                                context,
                                zh: '\u5bc6\u78bc',
                                en: 'Password',
                              ),
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    color: AppBranding.textMuted,
                                  ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              suffixIcon: InkWell(
                                onTap: () async {
                                  safeSetState(() => _model.passwordVisibility =
                                      !_model.passwordVisibility);
                                },
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  _model.passwordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 22.0,
                                ),
                              ),
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                    ),
                            keyboardType: TextInputType.visiblePassword,
                            validator: _model.passwordTextControllerValidator
                                .asValidator(context),
                          ),
                          const SizedBox(height: 18.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Theme(
                                data: ThemeData(
                                  checkboxTheme: CheckboxThemeData(
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  unselectedWidgetColor:
                                      FlutterFlowTheme.of(context).alternate,
                                ),
                                child: Checkbox(
                                  value: _model.checkboxValue ??=
                                      FFAppState().check,
                                  onChanged: (newValue) async {
                                    safeSetState(
                                        () => _model.checkboxValue = newValue!);
                                    FFAppState().check = newValue ?? false;
                                    safeSetState(() {});
                                  },
                                  side: BorderSide(
                                    width: 2.0,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                  activeColor:
                                      FlutterFlowTheme.of(context).primary,
                                  checkColor: FlutterFlowTheme.of(context).info,
                                ),
                              ),
                              Text(
                                AppBranding.localized(
                                  context,
                                  zh: '\u8a18\u4f4f\u5e33\u865f\u5bc6\u78bc',
                                  en: 'Remember account',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      color: AppBranding.textMuted,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22.0),
                          SizedBox(
                            height: 52.0,
                            child: ElevatedButton.icon(
                              onPressed: _isSubmitting ? null : _attemptLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppBranding.actionColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              icon: _isSubmitting
                                  ? const SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.login_rounded),
                              label: Text(
                                AppBranding.localized(
                                  context,
                                  zh: '\u767b\u5165\u7cfb\u7d71',
                                  en: 'Sign In',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
