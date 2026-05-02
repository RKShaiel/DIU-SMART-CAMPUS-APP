import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> notice;

  const NoticeDetailsScreen({super.key, required this.notice});

  Future<void> _launchPDF(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(backgroundColor: const Color(0xFF0F172A)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice['title'] ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(notice['date'] ?? '', style: const TextStyle(color: Colors.white54)),
            const Divider(color: Colors.white24, height: 40),
            Text(
              notice['details'] ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 40),
            
            // PDF Button (only shows if pdfUrl exists in Firebase)
            if (notice['pdfUrl'] != null && notice['pdfUrl'].toString().isNotEmpty)
              InkWell(
                onTap: () => _launchPDF(notice['pdfUrl']),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    border: Border.all(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Text("View Attached PDF", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}