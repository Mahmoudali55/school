import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

Future<LottieComposition> _parseLottie(Uint8List bytes) {
  return LottieComposition.fromBytes(bytes);
}

/// Simple cache
class LottieCache {
  static final Map<String, LottieComposition> _cache = {};

  static Future<LottieComposition> load(String assetPath) async {
    if (_cache.containsKey(assetPath)) return _cache[assetPath]!;
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final comp = await compute(_parseLottie, bytes);
    _cache[assetPath] = comp;
    return comp;
  }
}

class LottieIsolate extends StatefulWidget {
  final String assetPath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool repeat;
  final bool animate;
  final VoidCallback? onCompleted;

  const LottieIsolate({
    super.key,
    required this.assetPath,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.repeat = true,
    this.animate = true,
    this.onCompleted,
  });

  @override
  State<LottieIsolate> createState() => _LottieIsolateState();
}

class _LottieIsolateState extends State<LottieIsolate> with SingleTickerProviderStateMixin {
  LottieComposition? _composition;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // نعرض أول فريم مباشرة كصورة (بدون انتظار التحميل)
    Lottie.asset(
      widget.assetPath,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      animate: false, // ❌ بدون أنيميشن
      repeat: false,
    );

    // نحمّل في الخلفية
    LottieCache.load(widget.assetPath).then((comp) {
      if (!mounted) return;
      setState(() => _composition = comp);
      _controller.duration = comp.duration;

      if (widget.animate) {
        if (widget.repeat) {
          _controller.repeat();
        } else {
          _controller.forward();
        }
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !widget.repeat) {
        widget.onCompleted?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_composition == null) {
      // ✅ أول ما يفتح: يعرض فريم ثابت
      return Lottie.asset(
        widget.assetPath,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        animate: false,
        repeat: false,
      );
    }

    // ✅ بعد ما يجهز: يشغل الأنيميشن
    return Lottie(
      composition: _composition!,
      controller: _controller,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      repeat: widget.repeat,
      animate: widget.animate,
    );
  }
}
