import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({super.key});

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  final Stream<QuerySnapshot> _busStream =
      FirebaseFirestore.instance.collection('bus_schedule').snapshots();

  Color statusColor(String status) {
    switch (status) {
      case 'On Time':
        return const Color(0xFF1FAF8B);
      case 'Delayed':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF9FB3B3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF041421), 

      appBar: AppBar(
        backgroundColor: const Color(0xFF2FA084), 
        elevation: 0,
        title: const Text(
          'Bus Schedule',
          style: TextStyle(color: Color(0xFFE6F1F1)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFE6F1F1)), // back button visible
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: _busStream,
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: Color(0xFFE6F1F1)),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1FAF8B),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No schedules found',
                style: TextStyle(color: Color(0xFF9FB3B3)),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final bus = docs[index].data() as Map<String, dynamic>;

              return Card(
                color: const Color(0xFF0A2A3A), // ✅ dark card
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          const Icon(
                            Icons.directions_bus,
                            color: Color(0xFF1FAF8B),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              bus['route'] ?? 'Unknown Route',
                              style: const TextStyle(
                                color: Color(0xFFE6F1F1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: Color(0xFF9FB3B3)),
                          const SizedBox(width: 8),
                          Text(
                            bus['time'] ?? '--:--',
                            style: const TextStyle(
                                color: Color(0xFF9FB3B3)),
                          ),
                          const SizedBox(width: 20),
                          const Icon(Icons.confirmation_number,
                              size: 16, color: Color(0xFF9FB3B3)),
                          const SizedBox(width: 8),
                          Text(
                            bus['busNo'] ?? 'N/A',
                            style: const TextStyle(
                                color: Color(0xFF9FB3B3)),
                          ),
                        ],
                      ),

                      if (bus['details'] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          bus['details'],
                          style: const TextStyle(
                            color: Color(0xFF9FB3B3),
                            fontSize: 12,
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor(bus['status'] ?? '')
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          bus['status'] ?? 'Unknown',
                          style: TextStyle(
                            color: statusColor(bus['status'] ?? ''),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}