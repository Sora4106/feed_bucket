import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class AppBranding {
  const AppBranding._();

  static const String appName = 'Feed Bucket Monitor';
  static const String logoAsset =
      'assets/images/0B9916AC-F8B5-4C75-9AB4-E6F224943383-removebg-preview.webp';

  static const Color appBarColor = Color(0xFF0B5CAD);
  static const Color actionColor = Color(0xFF0B5CAD);
  static const Color successColor = Color(0xFF2E8B57);
  static const Color warningColor = Color(0xFFF3A530);
  static const Color dangerColor = Color(0xFFD64545);
  static const Color pageTop = Color(0xFFF5FAFC);
  static const Color pageBottom = Color(0xFFDCEAF1);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color softSurfaceColor = Color(0xFFF0F6FA);
  static const Color borderColor = Color(0xFF97ABBB);
  static const Color textStrong = Color(0xFF17324D);
  static const Color textMuted = Color(0xFF587084);

  static String localized(
    BuildContext context, {
    required String zh,
    required String en,
  }) {
    return FFLocalizations.of(context).languageCode == 'zh_Hant' ? zh : en;
  }

  static PreferredSizeWidget buildPageAppBar(
    BuildContext context, {
    required String title,
    VoidCallback? onBack,
    bool centerTitle = true,
    List<Widget>? extraActions,
  }) {
    return AppBar(
      backgroundColor: appBarColor,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: onBack == null
          ? null
          : IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 28.0,
              ),
            ),
      title: Text(
        title,
        style: FlutterFlowTheme.of(context).headlineMedium.override(
              color: Colors.white,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: extraActions ??
          [
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: Align(
                alignment: Alignment.center,
                child: buildLogoBadge(context),
              ),
            ),
          ],
      centerTitle: centerTitle,
      elevation: 0.0,
    );
  }

  static Widget buildLogoBadge(
    BuildContext context, {
    double width = 92.0,
    double height = 52.0,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: borderColor.withValues(alpha: 0.6)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10.0,
            color: Color(0x1A000000),
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset(
          logoAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  static BoxDecoration pageBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [pageTop, pageBottom],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  static Widget buildPageBackground({required Widget child}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: pageBackgroundDecoration(),
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
            child: Container(
              width: 240.0,
              height: 240.0,
              decoration: const BoxDecoration(
                color: Color(0x1FF3A530),
                shape: BoxShape.circle,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  static Widget wrapWithEdgeSwipeBack(
    BuildContext context, {
    required Widget child,
    VoidCallback? onBack,
  }) {
    final shouldEnable =
        onBack != null && Theme.of(context).platform == TargetPlatform.iOS;

    if (!shouldEnable) {
      return child;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          left: 0.0,
          top: 0.0,
          bottom: 0.0,
          width: 18.0,
          child: PointerInterceptor(
            child: _EdgeSwipeBackRegion(onBack: onBack),
          ),
        ),
      ],
    );
  }

  static BoxDecoration panelDecoration(
    BuildContext context, {
    Color? color,
    double radius = 20.0,
    bool elevated = true,
  }) {
    return BoxDecoration(
      color: color ?? surfaceColor.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor.withValues(alpha: 0.7)),
      boxShadow: elevated
          ? const [
              BoxShadow(
                blurRadius: 16.0,
                color: Color(0x12000000),
                offset: Offset(0.0, 8.0),
              ),
            ]
          : const [],
    );
  }

  static BoxDecoration softPanelDecoration(
    BuildContext context, {
    double radius = 18.0,
  }) {
    return panelDecoration(
      context,
      color: softSurfaceColor.withValues(alpha: 0.96),
      radius: radius,
    );
  }

  static Widget buildInfoBanner(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? hintMessage,
    IconData icon = Icons.info_outline_rounded,
  }) {
    final titleStyle = FlutterFlowTheme.of(context).titleMedium.override(
          color: textStrong,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w700,
        );
    final hasHintMessage = hintMessage != null && hintMessage.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
      decoration: panelDecoration(context),
      child: Row(
        children: [
          Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: const Color(0x1F0B5CAD),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Icon(
              icon,
              color: actionColor,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitleWithHint(
                  context,
                  title: title,
                  hintMessage: hasHintMessage ? hintMessage : null,
                  style: titleStyle,
                ),
                if (!hasHintMessage && subtitle != null) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          color: textMuted,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildTitleWithHint(
    BuildContext context, {
    required String title,
    String? hintMessage,
    TextStyle? style,
  }) {
    final effectiveStyle = style ??
        FlutterFlowTheme.of(context).titleMedium.override(
              color: textStrong,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w700,
            );

    if (hintMessage == null || hintMessage.trim().isEmpty) {
      return Text(title, style: effectiveStyle);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: effectiveStyle,
          ),
        ),
        const SizedBox(width: 8.0),
        _HintMessageButton(message: hintMessage),
      ],
    );
  }
}

class _HintMessageButton extends StatefulWidget {
  const _HintMessageButton({
    required this.message,
  });

  final String message;

  @override
  State<_HintMessageButton> createState() => _HintMessageButtonState();
}

class _HintMessageButtonState extends State<_HintMessageButton> {
  static _HintMessageButtonState? _activeState;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _dismissTimer;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _showHint() {
    _activeState?._removeOverlay();
    _removeOverlay();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      return;
    }

    final message = widget.message.trim();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxBubbleWidth =
        screenWidth > 64.0 ? screenWidth - 64.0 : screenWidth;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: IgnorePointer(
          ignoring: true,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomRight,
                followerAnchor: Alignment.topRight,
                offset: const Offset(0.0, 10.0),
                child: Material(
                  color: Colors.transparent,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxBubbleWidth.clamp(0.0, 280.0).toDouble(),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xF217324D),
                        borderRadius: BorderRadius.circular(14.0),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 16.0,
                            color: Color(0x22000000),
                            offset: Offset(0.0, 8.0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 10.0,
                        ),
                        child: Text(
                          message,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    lineHeight: 1.45,
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
    );

    overlay.insert(_overlayEntry!);
    _activeState = this;
    _dismissTimer = Timer(_displayDurationFor(message), _removeOverlay);
  }

  void _removeOverlay() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_activeState == this) {
      _activeState = null;
    }
  }

  Duration _displayDurationFor(String message) {
    final characterCount =
        message.replaceAll(RegExp(r'\s+'), '').characters.length;
    final effectiveCount = characterCount <= 0 ? 1 : characterCount;
    return Duration(milliseconds: effectiveCount * 200);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        onPressed: _showHint,
        style: IconButton.styleFrom(
          minimumSize: const Size(34.0, 34.0),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: const Color(0x1A0B5CAD),
          foregroundColor: AppBranding.actionColor,
        ),
        icon: const Icon(
          Icons.search_rounded,
          size: 18.0,
        ),
      ),
    );
  }
}

class _EdgeSwipeBackRegion extends StatefulWidget {
  const _EdgeSwipeBackRegion({
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  State<_EdgeSwipeBackRegion> createState() => _EdgeSwipeBackRegionState();
}

class _EdgeSwipeBackRegionState extends State<_EdgeSwipeBackRegion> {
  static const double _triggerDistance = 56.0;
  static const double _triggerVelocity = 500.0;

  double _dragDistance = 0.0;
  bool _didTrigger = false;

  void _handleDragStart(DragStartDetails details) {
    _dragDistance = 0.0;
    _didTrigger = false;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_didTrigger) {
      return;
    }

    _dragDistance += details.primaryDelta ?? 0.0;
    if (_dragDistance >= _triggerDistance) {
      _didTrigger = true;
      widget.onBack();
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_didTrigger) {
      return;
    }

    final velocity = details.primaryVelocity ?? 0.0;
    if (_dragDistance >= _triggerDistance || velocity >= _triggerVelocity) {
      _didTrigger = true;
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      dragStartBehavior: DragStartBehavior.down,
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: const SizedBox.expand(),
    );
  }
}
