import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'cam_model.dart';
export 'cam_model.dart';

class CamWidget extends StatefulWidget {
  const CamWidget({
    super.key,
    this.camlink,
  });

  final String? camlink;

  @override
  State<CamWidget> createState() => _CamWidgetState();
}

class _CamWidgetState extends State<CamWidget> {
  late CamModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CamModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 60000),
        callback: (timer) async {
          safeSetState(() => _model.apiRequestCompleter = null);
          await _model.waitForApiRequestCompleted();
        },
        startImmediately: true,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: (_model.apiRequestCompleter ??= Completer<ApiCallResponse>()
            ..complete(DatebaseSQLCall.call(
              mode: 'select',
              key: 'IPcam_image',
              id: widget.camlink,
            )))
          .future,
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }
        final imageDatebaseSQLResponse = snapshot.data!;

        return InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            await Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: FlutterFlowExpandedImageView(
                  image: Image.memory(
                    functions
                            .base64ToUploadedFile(DatebaseSQLCall.image(
                              imageDatebaseSQLResponse.jsonBody,
                            ).toString())
                            ?.bytes ??
                        Uint8List.fromList([]),
                    fit: BoxFit.contain,
                  ),
                  allowRotation: true,
                  tag: 'imageTag',
                  useHeroAnimation: true,
                ),
              ),
            );
          },
          child: Hero(
            tag: 'imageTag',
            transitionOnUserGestures: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                functions
                        .base64ToUploadedFile(DatebaseSQLCall.image(
                          imageDatebaseSQLResponse.jsonBody,
                        ).toString())
                        ?.bytes ??
                    Uint8List.fromList([]),
                width: 300.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
