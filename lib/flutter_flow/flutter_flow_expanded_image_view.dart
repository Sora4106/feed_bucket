import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class FlutterFlowExpandedImageView extends StatefulWidget {
  const FlutterFlowExpandedImageView({
    required this.image,
    this.allowRotation = false,
    this.useHeroAnimation = true,
    this.tag,
    this.preferredOrientationsOnOpen,
    this.restoreOrientationsOnClose,
    this.preferLandscapePresentationOnIOSWeb = false,
  });

  final Widget image;
  final bool allowRotation;
  final bool useHeroAnimation;
  final Object? tag;
  final List<DeviceOrientation>? preferredOrientationsOnOpen;
  final List<DeviceOrientation>? restoreOrientationsOnClose;
  final bool preferLandscapePresentationOnIOSWeb;

  @override
  State<FlutterFlowExpandedImageView> createState() =>
      _FlutterFlowExpandedImageViewState();
}

class _FlutterFlowExpandedImageViewState
    extends State<FlutterFlowExpandedImageView> {
  @override
  void initState() {
    super.initState();
    _setPreferredOrientations(widget.preferredOrientationsOnOpen);
  }

  @override
  void dispose() {
    _setPreferredOrientations(widget.restoreOrientationsOnClose);
    super.dispose();
  }

  void _setPreferredOrientations(List<DeviceOrientation>? orientations) {
    if (orientations == null || orientations.isEmpty) {
      return;
    }
    SystemChrome.setPreferredOrientations(orientations);
  }

  bool _shouldUseIOSWebLandscapeFallback(BuildContext context) {
    return widget.preferLandscapePresentationOnIOSWeb &&
        kIsWeb &&
        defaultTargetPlatform == TargetPlatform.iOS &&
        MediaQuery.orientationOf(context) == Orientation.portrait;
  }

  Widget _buildPhotoViewport(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final useIOSWebLandscapeFallback =
        _shouldUseIOSWebLandscapeFallback(context);

    final photoView = SizedBox(
      width: useIOSWebLandscapeFallback ? screenSize.height : screenSize.width,
      height: useIOSWebLandscapeFallback ? screenSize.width : screenSize.height,
      child: PhotoView.customChild(
        minScale: 1.0,
        maxScale: 3.0,
        enableRotation: widget.allowRotation,
        heroAttributes: widget.useHeroAnimation
            ? PhotoViewHeroAttributes(tag: widget.tag!)
            : null,
        onScaleEnd: (context, details, value) {
          if (value.scale! < 0.3) {
            Navigator.pop(context);
          }
        },
        child: widget.image,
      ),
    );

    if (!useIOSWebLandscapeFallback) {
      return photoView;
    }

    return Center(
      child: RotatedBox(
        quarterTurns: 1,
        child: photoView,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildPhotoViewport(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: IconButton(
                    color: Colors.black,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
