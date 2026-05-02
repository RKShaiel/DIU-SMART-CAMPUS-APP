import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final String examDateDoc = "02-05-2026";
  String? selectedBatch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF041421), 

      appBar: AppBar(
        backgroundColor: const Color(0xFF2FA084), 
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE6F1F1)),
        title: const Text(
          "Exam Seat Plan",
          style: TextStyle(color: Color(0xFFE6F1F1)),
        ),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('exam_plans')
            .doc(examDateDoc)
            .get(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1FAF8B),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                "No data found for $examDateDoc",
                style: const TextStyle(color: Color(0xFF9FB3B3)),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final batches = data['batches'] as Map<String, dynamic>;
          final List<String> availableBatches =
              batches.keys.toList()..sort();

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Select Your Batch",
                  style: TextStyle(
                    color: Color(0xFFE6F1F1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A2A3A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                     color: const Color(0xFF9FB3B3).withValues(alpha: 0.2),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedBatch,
                      hint: const Text(
                        "Choose Batch",
                        style: TextStyle(color: Color(0xFF9FB3B3)),
                      ),
                      dropdownColor: const Color(0xFF0A2A3A),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF1FAF8B),
                      ),
                      isExpanded: true,
                      items: availableBatches.map((String batch) {
                        return DropdownMenuItem<String>(
                          value: batch,
                          child: Text(
                            batch,
                            style: const TextStyle(
                              color: Color(0xFFE6F1F1),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBatch = value;
                        });

                        if (value != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamDetailScreen(
                                batchId: value,
                                data: batches[value],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                if (selectedBatch == null)
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 48,
                          color: Color(0xFF9FB3B3),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Please select a batch to view\nroom allocation for $examDateDoc",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF9FB3B3),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExamDetailScreen extends StatelessWidget {
  final String batchId;
  final Map<String, dynamic> data;

  const ExamDetailScreen(
      {super.key, required this.batchId, required this.data});

  @override
  Widget build(BuildContext context) {
    final List rooms = data['rooms'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF041421), // ✅ DARK

      appBar: AppBar(
        backgroundColor: const Color(0xFF2FA084),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE6F1F1)),
        title: Text(
          "Batch $batchId Details",
          style: const TextStyle(color: Color(0xFFE6F1F1)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // TOP CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0A2A3A),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['course_name'] ?? "Course Info",
                    style: const TextStyle(
                      color: Color(0xFFE6F1F1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Code: ${data['course_code'] ?? "N/A"}",
                    style: const TextStyle(color: Color(0xFF9FB3B3)),
                  ),
                  const Divider(color: Color(0xFF9FB3B3), height: 20),
                  Text(
                    "Exam Slot: ${data['slot'] ?? "N/A"}",
                    style: const TextStyle(color: Color(0xFFE6F1F1)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TABLE
            Table(
              border: TableBorder.all(
                color: const Color(0xFF9FB3B3).withOpacity(0.2),
              ),
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A2A3A),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Room",
                        style: TextStyle(
                          color: Color(0xFF1FAF8B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Seats",
                        style: TextStyle(
                          color: Color(0xFF1FAF8B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Section",
                        style: TextStyle(
                          color: Color(0xFF1FAF8B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                ...rooms.map(
                  (room) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "${room['room_no']}",
                          style: const TextStyle(
                            color: Color(0xFFE6F1F1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "${room['seats']}",
                          style: const TextStyle(
                            color: Color(0xFFE6F1F1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "${room['section']}",
                          style: const TextStyle(
                            color: Color(0xFFE6F1F1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}