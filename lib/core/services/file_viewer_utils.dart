import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class FileViewerUtils {
  static Future<void> displayFile(
    BuildContext context,
    String fileContent,
    String fileName,
  ) async {
    if (fileContent.isEmpty) return;

    try {
      final bool isImage = _isImage(fileName);
      final normalized = fileContent.trim();

      if (isImage) {
        if (_isLikelyBase64(_stripBase64Prefix(normalized))) {
          _showImageDialog(context, _stripBase64Prefix(normalized), fileName);
        } else if (_looksLikeUrl(normalized)) {
          _showImageDialog(context, normalized, fileName);
        } else {
          await _openExternalFile(normalized, fileName);
        }
      } else {
        await _openExternalFile(normalized, fileName);
      }
    } catch (e) {
      debugPrint('Error displaying file: $e');
      CommonMethods.showToast(message: "حدث خطأ أثناء عرض الملف", type: ToastType.error);
    }
  }

  static bool _isImage(String fileName) {
    final List<String> imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    final String lowerFileName = fileName.toLowerCase();
    return imageExtensions.any((ext) => lowerFileName.endsWith(ext));
  }

  static void _showImageDialog(BuildContext context, String content, String fileName) {
    final bool isUrl = _looksLikeUrl(content);
    final token = HiveMethods.getToken();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.black87,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Center(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                      fileName,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.download, color: Colors.white),
                        onPressed: () => _openExternalFile(content, fileName),
                      ),
                    ],
                  ),
                  Expanded(
                    child: PhotoView(
                      imageProvider: isUrl
                          ? CachedNetworkImageProvider(
                              content,
                              headers: token != null ? {'Authorization': 'Bearer $token'} : null,
                            ) as ImageProvider
                          : MemoryImage(base64Decode(content)),
                      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                      loadingBuilder: (context, event) => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.error_outline, color: Colors.white, size: 60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _openExternalFile(String fileContent, String fileName) async {
    try {
      final bytes = await _resolveBytes(fileContent);
      if (bytes.isEmpty) {
        CommonMethods.showToast(message: "الملف فارغ أو غير موجود", type: ToastType.error);
        return;
      }
      final dir = await getTemporaryDirectory();
      // Ensure fileName is clean for local storage
      final safeFileName = fileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final file = File('${dir.path}/$safeFileName');
      await file.writeAsBytes(bytes, flush: true);
      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        CommonMethods.showToast(message: "لا يمكن فتح هذا النوع من الملفات", type: ToastType.error);
      }
    } catch (e) {
      debugPrint('Error opening external file: $e');
      CommonMethods.showToast(message: "حدث خطأ أثناء فتح الملف خارجيًا", type: ToastType.error);
    }
  }

  static Future<Uint8List> _resolveBytes(String content) async {
    final normalized = _stripBase64Prefix(content.trim());
    if (_isLikelyBase64(normalized)) {
      return base64Decode(normalized);
    }

    if (_looksLikeUrl(content)) {
      try {
        final dio = Dio();
        final token = HiveMethods.getToken();
        final response = await dio.get<dynamic>(
          content,
          options: Options(
            responseType: ResponseType.bytes,
            headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          ),
        );
        
        final bytes = Uint8List.fromList(response.data as List<int>);
        
        // Sometimes APIs return base64 string inside the response even if requested as bytes
        try {
          final possibleBase64 = utf8.decode(bytes).trim();
          final stripped = _stripBase64Prefix(possibleBase64);
          if (_isLikelyBase64(stripped)) {
            return base64Decode(stripped);
          }
        } catch (_) {
          // Not a UTF8 string or not base64, return original bytes
        }
        
        return bytes;
      } catch (e) {
        debugPrint('Error resolving bytes from URL: $e');
        return Uint8List(0);
      }
    }

    return Uint8List.fromList(utf8.encode(content));
  }

  static bool _looksLikeUrl(String input) {
    final uri = Uri.tryParse(input);
    return uri != null && (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
  }

  static String _stripBase64Prefix(String input) {
    if (input.contains('base64,')) {
      return input.split('base64,').last;
    }
    return input;
  }

  static bool _isLikelyBase64(String value) {
    final sanitized = value.trim();
    if (sanitized.isEmpty) return false;
    // Base64 regex - basic validation
    final base64RegExp = RegExp(r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');
    return base64RegExp.hasMatch(sanitized);
  }
}
