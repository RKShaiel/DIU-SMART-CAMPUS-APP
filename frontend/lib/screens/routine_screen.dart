import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> routine = [];
  bool isLoading = false;

  String selectedDay = "Sunday";

  final List<String> days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];

  Future<void> fetchRoutine(String batch) async {
    if (batch.isEmpty) return;

    setState(() {
      isLoading = true;
      routine = [];
    });

    final snapshot = await FirebaseFirestore.instance
        .collection('routine')
        .where('batch', isEqualTo: batch)
        .get();

    setState(() {
      routine = snapshot.docs.map((e) => e.data()).toList();
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> get filteredRoutine {
    final list =
        routine.where((e) => e['day'] == selectedDay).toList();

    list.sort((a, b) => (a['time'] ?? '').compareTo(b['time'] ?? ''));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF041421),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 31, 111, 95),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE6F1F1)),
        title: const Text(
          "Routine",
          style: TextStyle(color: Color(0xFFE6F1F1)),
        ),
      ),

      body: Column(
        children: [

          // 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Color(0xFFE6F1F1)),
              decoration: InputDecoration(
                hintText: "Enter Batch (63_I)",
                hintStyle:
                    const TextStyle(color: Color(0xFF9FB3B3)),
                filled: true,
                fillColor: const Color(0xFF0A2A3A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search,
                      color: Color(0xFF1FAF8B)),
                  onPressed: () =>
                      fetchRoutine(_controller.text.trim()),
                ),
              ),
            ),
          ),

          // 📅 DAY SELECTOR
          SizedBox(
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = day == selectedDay;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedDay = day);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1FAF8B)
                          : const Color(0xFF0A2A3A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        day.substring(0, 3),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : const Color(0xFFE6F1F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 📋 ROUTINE LIST
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1FAF8B),
                    ),
                  )
                : filteredRoutine.isEmpty
                    ? const Center(
                        child: Text(
                          "No classes",
                          style:
                              TextStyle(color: Color(0xFF9FB3B3)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredRoutine.length,
                        itemBuilder: (context, index) {
                          final e = filteredRoutine[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                // ⏰ TIME
                                Column(
                                  children: [
                                    Text(
                                      (e['time'] ?? '')
                                          .split('-')[0],
                                      style: const TextStyle(
                                          color: Color(0xFF9FB3B3)),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 100,
                                      color: const Color(0xFF9FB3B3)
                                          .withValues(alpha: 0.3),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 12),

                                // 📦 CARD
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0A2A3A),
                                      borderRadius:
                                          BorderRadius.circular(18),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          e['course'] ?? '',
                                          style: const TextStyle(
                                            color:
                                                Color(0xFFE6F1F1),
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        _row("Course", e['course']),
                                        _row("Section", e['batch']),
                                        _row("Teacher", e['teacher']),
                                        _row("Room", e['room']),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              color: Color(0xFF9FB3B3),
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '',
              style: const TextStyle(
                color: Color(0xFFE6F1F1),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}