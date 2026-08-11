import 'package:pdf/pdf.dart';
import 'app_date_utils.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  /// Generates and shares/saves a PDF based on the document type and content.
  static Future<void> generateAndShare({
    required String title,
    required String subtitle,
    required List<Map<String, String>> sections,
    bool isAcknowledged = false,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header with Branding
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'AT Plus Jewellers',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.indigo900,
                      ),
                    ),
                    pw.Text(
                      'Official Document',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Date: ${AppDateUtils.formatDate(DateTime.now())}',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      'ID: AT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(thickness: 2, color: PdfColors.grey300),
            pw.SizedBox(height: 20),

            // Title and Status
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              subtitle,
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 20),

            // Status Badge
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: pw.BoxDecoration(
                color: isAcknowledged ? PdfColors.green50 : PdfColors.amber50,
                borderRadius: pw.BorderRadius.circular(4),
                border: pw.Border.all(
                  color: isAcknowledged
                      ? PdfColors.green700
                      : PdfColors.amber700,
                  width: 1,
                ),
              ),
              child: pw.Text(
                isAcknowledged
                    ? 'STATUS: ACKNOWLEDGED'
                    : 'STATUS: PENDING REVIEW',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: isAcknowledged
                      ? PdfColors.green800
                      : PdfColors.amber800,
                ),
              ),
            ),
            pw.SizedBox(height: 30),

            // Content Sections
            ...sections.map((section) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (section['title'] != null && section['title']!.isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Text(
                        section['title']!,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                  pw.Text(
                    section['content'] ?? '',
                    style: const pw.TextStyle(
                      fontSize: 11,
                      lineSpacing: 4,
                      color: PdfColors.grey900,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                ],
              );
            }),

            // Footer
            pw.SizedBox(height: 40),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                'This is a digitally generated document from AT Plus Jewellers mobile application.',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
            ),
          ];
        },
      ),
    );

    // Share the PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: '${title.replaceAll(' ', '_')}.pdf',
    );
  }

  /// Generates and brings up the system print dialog.
  static Future<void> printLayout({
    required String title,
    required String subtitle,
    required List<Map<String, String>> sections,
    bool isAcknowledged = false,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(subtitle),
            pw.SizedBox(height: 20),
            ...sections.map((section) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (section['title'] != null && section['title']!.isNotEmpty)
                    pw.Text(
                      section['title']!,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  pw.Text(section['content'] ?? ''),
                  pw.SizedBox(height: 15),
                ],
              );
            }),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: title,
    );
  }
}
