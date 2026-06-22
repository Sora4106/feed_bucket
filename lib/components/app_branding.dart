import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

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
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
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
    IconData icon = Icons.info_outline_rounded,
  }) {
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
                Text(
                  title,
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        color: textStrong,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (subtitle != null) ...[
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
}
