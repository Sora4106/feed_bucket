import '/backend/api_requests/api_calls.dart';
import '/components/app_branding.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      safeSetState(() {
        _model.checkboxValue = FFAppState().check;
      });
      safeSetState(() {
        _model.emailAddressTextController?.text = FFAppState().accountNumber;
      });
      safeSetState(() {
        _model.passwordTextController?.text = FFAppState().password;
      });
    });

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

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
                    zh: '確定',
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

  Future<void> _attemptLogin() async {
    var shouldSetState = false;

    _model.account = await DatebaseSQLCall.call(
      mode: 'select',
      key: 'any',
      sqlString: 'password,farmID',
      sqlWhere: 'account_number=${_model.emailAddressTextController.text}',
      sqlFrom: 'user',
    );

    shouldSetState = true;

    if ((_model.account?.succeeded ?? false)) {
      final passwordMatches =
          DatebaseSQLCall.password((_model.account?.jsonBody ?? '')) ==
              _model.passwordTextController.text;

      if (passwordMatches) {
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
        final pairCount = farmIds.length < farmNames.length
            ? farmIds.length
            : farmNames.length;
        final visibleFarmIds = farmIds.take(pairCount).toList();
        final visibleFarmNames = farmNames.take(pairCount).toList();
        final sortOrder = functions.sortIndicesByNaturalOrder(visibleFarmNames);

        FFAppState().farmID = [
          for (final index in sortOrder) visibleFarmIds[index],
        ];
        FFAppState().name = [
          for (final index in sortOrder) visibleFarmNames[index],
        ];
        safeSetState(() {});

        if (FFAppState().check == true) {
          FFAppState().accountNumber = _model.emailAddressTextController.text;
          FFAppState().password = _model.passwordTextController.text;
          safeSetState(() {});
        } else {
          FFAppState().accountNumber = '';
          FFAppState().password = '';
          safeSetState(() {});
          safeSetState(() {
            _model.emailAddressTextController?.clear();
            _model.passwordTextController?.clear();
          });
        }

        if (!mounted) {
          return;
        }

        context.pushNamed(
          MainWidget.routeName,
          extra: <String, dynamic>{
            '__transition_info__': TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: const Duration(milliseconds: 100),
            ),
          },
        );

        if (shouldSetState) {
          safeSetState(() {});
        }
        return;
      }

      await _showLoginAlert(
        title: AppBranding.localized(
          context,
          zh: '登入失敗',
          en: 'Login failed',
        ),
        message: AppBranding.localized(
          context,
          zh: '帳號或密碼錯誤，請重新確認後再試一次。',
          en: 'Incorrect account or password. Please try again.',
        ),
      );

      if (shouldSetState) {
        safeSetState(() {});
      }
      return;
    }

    await _showLoginAlert(
      title: AppBranding.localized(
        context,
        zh: '找不到帳號',
        en: 'Account not found',
      ),
      message: AppBranding.localized(
        context,
        zh: '查無此帳號資料，請確認輸入內容或檢查資料庫連線。',
        en: 'No account data was found. Please verify the account or database connection.',
      ),
    );

    if (shouldSetState) {
      safeSetState(() {});
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
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBranding.buildPageAppBar(
          context,
          title: AppBranding.localized(
            context,
            zh: '登入',
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
                            zh: '工作人員登入',
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
                            zh: '請輸入帳號與密碼後進入監控主畫面。',
                            en: 'Use your account and password to open the monitoring dashboard.',
                          ),
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    color: AppBranding.textMuted,
                                    letterSpacing: 0.0,
                                    lineHeight: 1.5,
                                  ),
                        ),
                        const SizedBox(height: 24.0),
                        TextFormField(
                          controller: _model.emailAddressTextController,
                          focusNode: _model.emailAddressFocusNode,
                          autofocus: true,
                          autofillHints: const [AutofillHints.username],
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: AppBranding.localized(
                              context,
                              zh: '帳號',
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
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
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
                          validator: _model.emailAddressTextControllerValidator
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
                              zh: '密碼',
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
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
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
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                                value: _model.checkboxValue ??= true,
                                onChanged: (newValue) async {
                                  safeSetState(
                                      () => _model.checkboxValue = newValue!);
                                  if (newValue!) {
                                    FFAppState().check = _model.checkboxValue!;
                                    safeSetState(() {});
                                  } else {
                                    FFAppState().check = false;
                                    safeSetState(() {});
                                  }
                                },
                                side: BorderSide(
                                  width: 2.0,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                checkColor: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            Text(
                              AppBranding.localized(
                                context,
                                zh: '記住帳號密碼',
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
                            onPressed: _attemptLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppBranding.actionColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            icon: const Icon(Icons.login_rounded),
                            label: Text(
                              AppBranding.localized(
                                context,
                                zh: '登入系統',
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
    );
  }
}
