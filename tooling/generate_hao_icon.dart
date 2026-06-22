import 'dart:io';

import 'package:image/image.dart' as img;

const _sourceLogoPath =
    'assets/images/0B9916AC-F8B5-4C75-9AB4-E6F224943383-removebg-preview.webp';
const _launcherOutputPath = 'assets/images/app_launcher_icon_blue_hao.png';
const _adaptiveForegroundOutputPath =
    'assets/images/app_launcher_icon_blue_hao_foreground.png';
const _appleTouchOutputPath = 'web/icons/apple-touch-icon.png';

void main() {
  final sourceFile = File(_sourceLogoPath);
  if (!sourceFile.existsSync()) {
    stderr.writeln('Source logo not found: $_sourceLogoPath');
    exitCode = 1;
    return;
  }

  final decoded = img.decodeImage(sourceFile.readAsBytesSync());
  if (decoded == null) {
    stderr.writeln('Unable to decode source logo: $_sourceLogoPath');
    exitCode = 1;
    return;
  }

  _writeComposedIcon(
    outputPath: _launcherOutputPath,
    source: decoded,
    size: 1024,
    background: const _BackgroundStyle.solidWhite(),
    logoWidthRatio: 0.88,
  );
  _writeComposedIcon(
    outputPath: _adaptiveForegroundOutputPath,
    source: decoded,
    size: 1024,
    background: const _BackgroundStyle.transparent(),
    logoWidthRatio: 0.74,
  );
  _writeComposedIcon(
    outputPath: _appleTouchOutputPath,
    source: decoded,
    size: 180,
    background: const _BackgroundStyle.solidWhite(),
    logoWidthRatio: 0.88,
  );

  stdout.writeln('Generated icon assets:');
  stdout.writeln(' - $_launcherOutputPath');
  stdout.writeln(' - $_adaptiveForegroundOutputPath');
  stdout.writeln(' - $_appleTouchOutputPath');
}

void _writeComposedIcon({
  required String outputPath,
  required img.Image source,
  required int size,
  required _BackgroundStyle background,
  required double logoWidthRatio,
}) {
  final canvas = img.Image(width: size, height: size, numChannels: 4);
  if (background.isTransparent) {
    img.fill(canvas, color: img.ColorRgba8(255, 255, 255, 0));
  } else {
    img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
  }

  final targetWidth = (size * logoWidthRatio).round();
  final resized = img.copyResize(source, width: targetWidth);
  final offsetX = ((size - resized.width) / 2).round();
  final offsetY = ((size - resized.height) / 2).round();

  img.compositeImage(
    canvas,
    resized,
    dstX: offsetX,
    dstY: offsetY,
  );

  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsBytesSync(img.encodePng(canvas));
}

class _BackgroundStyle {
  const _BackgroundStyle._({
    required this.isTransparent,
  });

  const _BackgroundStyle.solidWhite() : this._(isTransparent: false);

  const _BackgroundStyle.transparent() : this._(isTransparent: true);

  final bool isTransparent;
}
