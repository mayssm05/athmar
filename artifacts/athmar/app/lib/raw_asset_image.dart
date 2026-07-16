import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

/// Renders a PNG asset by decoding it in pure Dart and handing raw RGBA
/// pixels to the engine. This bypasses the browser image decoder, which
/// CanvasKit's CPU-only (no-WebGL) fallback fails to draw silently.
class RawAssetImage extends StatefulWidget {
  const RawAssetImage(this.asset,
      {super.key, this.width, this.height, this.fit = BoxFit.contain});

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  State<RawAssetImage> createState() => _RawAssetImageState();
}

class _RawAssetImageState extends State<RawAssetImage> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await rootBundle.load(widget.asset);
    final decoded = img.decodePng(bytes.buffer.asUint8List());
    if (decoded == null) return;
    final rgba = decoded.convert(numChannels: 4).getBytes(order: img.ChannelOrder.rgba);
    // decodeImageFromPixels expects premultiplied alpha; without this,
    // transparent pixels with non-zero RGB render as a white box.
    for (var i = 0; i < rgba.length; i += 4) {
      final a = rgba[i + 3];
      if (a == 255) continue;
      rgba[i] = rgba[i] * a ~/ 255;
      rgba[i + 1] = rgba[i + 1] * a ~/ 255;
      rgba[i + 2] = rgba[i + 2] * a ~/ 255;
    }
    ui.decodeImageFromPixels(rgba, decoded.width, decoded.height,
        ui.PixelFormat.rgba8888, (image) {
      if (mounted) setState(() => _image = image);
    });
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _image == null
          ? null
          : RawImage(image: _image, fit: widget.fit, filterQuality: FilterQuality.medium),
    );
  }
}
