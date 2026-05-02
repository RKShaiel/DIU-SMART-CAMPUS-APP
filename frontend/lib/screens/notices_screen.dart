import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notice_details_screen.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> notices = [];

  @override
  void initState() {
    super.initState();
    fetchNotices();
  }

  Future<void> fetchNotices() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notices')
          .orderBy('date', descending: true)
          .get();

      setState(() {
        notices = snapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching notices: $e");
      setState(() => isLoading = false);
    }
  }

  Color categoryColor(String category) {
    switch (category) {
      case 'Academic':
        return const Color(0xFF1FAF8B);
      case 'Exam':
        return const Color(0xFF6FCF97);
      case 'Club':
        return const Color(0xFF2FA084);
      default:
        return const Color(0xFF9FB3B3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF041421), // ✅ DARK BACKGROUND

      appBar: AppBar(
        backgroundColor: const Color(0xFF2FA084), // ✅ as you requested
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE6F1F1)), // back button visible
        title: const Text(
          'Notices',
          style: TextStyle(color: Color(0xFFE6F1F1)),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1FAF8B),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NoticeDetailsScreen(notice: notice),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color(0xFF0A2A3A), // dark card
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            notice['category'] ?? 'General',
                            style: TextStyle(
                              color: categoryColor(
                                  notice['category'] ?? ''),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            notice['title'] ?? 'No Title',
                            style: const TextStyle(
                              color: Color(0xFFE6F1F1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            notice['details'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF9FB3B3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}