import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'snackbar_utils.dart';

class FileUtils {
  /// Downloads and opens a PDF document directly using the system viewer.
  static Future<void> openDocument(String url, String fileName) async {
    try {
      // 1. Get a temporary directory for the file
      final Directory tempDir = await getTemporaryDirectory();
      final String savePath = '${tempDir.path}/$fileName';
      final File file = File(savePath);

      // Delete existing file if it exists to ensure fresh download
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (e) {
          // ignore delete errors
        }
      }

      // 2. Download the file using Dio
      SnackbarUtils.showInfo('Downloading document...');

      final Dio dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          followRedirects: true,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'application/pdf',
          },
        ),
      );

      final response = await dio.download(url, savePath);

      if (response.statusCode == 200) {
        // 3. Open the file directly with an external app
        if (await file.exists()) {
          final result = await OpenFilex.open(savePath);

          if (result.type != ResultType.done) {
            SnackbarUtils.showError('Could not open file: ${result.message}');
          }
        } else {
          SnackbarUtils.showError('File not found after download.');
        }
      } else {
        SnackbarUtils.showError(
          'Server returned error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Download failed';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Network timeout. Check your connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = 'Server error (${e.response?.statusCode}).';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection.';
      }
      SnackbarUtils.showError(errorMessage);
    } catch (e) {
      SnackbarUtils.showError('An unexpected error occurred.');
    }
  }

  /// Simulates a print action by opening the document in the system viewer.
  static Future<void> printDocument(String url, String fileName) async {
    await openDocument(url, fileName);
  }
}
