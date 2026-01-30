import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripDetailsPage extends StatefulWidget {
  const TripDetailsPage({super.key});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  // Trip Data
  List<Map<String, dynamic>> trips = [
    {
      'id': 'TRP001',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'route': 'MG Road → Electronic City',
      'vehicle': 'EV Mini Bus',
      'fare': 45.00,
      'status': 'Completed',
      'driver': 'Rajesh Kumar',
      'rating': 4.5,
    },
    {
      'id': 'TRP002',
      'date': DateTime.now().add(const Duration(hours: 3)),
      'route': 'Koramangala → Whitefield',
      'vehicle': 'EV City Bus',
      'fare': 60.00,
      'status': 'Upcoming',
      'driver': 'Priya Sharma',
      'rating': 4.8,
    },
    {
      'id': 'TRP003',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'route': 'Airport → City Center',
      'vehicle': 'EV SUV',
      'fare': 120.00,
      'status': 'Completed',
      'driver': 'Amit Patel',
      'rating': 4.3,
    },
    {
      'id': 'TRP004',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'route': 'Home → Office',
      'vehicle': 'EV Sedan',
      'fare': 35.00,
      'status': 'Cancelled',
      'driver': 'Suresh Kumar',
      'rating': 4.0,
    },
    {
      'id': 'TRP005',
      'date': DateTime.now().add(const Duration(days: 1)),
      'route': 'Office → Mall',
      'vehicle': 'EV Mini Bus',
      'fare': 30.00,
      'status': 'Upcoming',
      'driver': 'Neha Singh',
      'rating': 4.7,
    },
  ];

  List<Map<String, dynamic>> get filteredTrips {
    if (_selectedFilter == 'All') return trips;
    return trips.where((trip) => trip['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Total Trips",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trips.length.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Total Spent",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "₹${trips.fold(0.0, (sum, trip) => sum + trip['fare']).toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Avg. Rating",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "4.6",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: _selectedFilter == filter,
                      selectedColor: const Color(0xFF00C853),
                      labelStyle: TextStyle(
                        color: _selectedFilter == filter
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = selected ? filter : 'All';
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Trips List
            const Text(
              "My Trips",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (filteredTrips.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.directions_bus,
                        size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      "No trips found",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Book your first trip to see it here",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...filteredTrips.map((trip) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Trip Header
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _getStatusColor(trip['status'])
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.directions_bus,
                                color: _getStatusColor(trip['status']),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trip['route'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM dd, yyyy • hh:mm a')
                                        .format(trip['date']),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    _getStatusColor(trip['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getStatusColor(trip['status'])
                                      .withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                trip['status'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getStatusColor(trip['status']),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Trip Details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Vehicle",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  trip['vehicle'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Driver",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  trip['driver'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fare",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  "₹${trip['fare']}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Action Buttons
                        if (trip['status'] == 'Upcoming')
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    // Cancel trip
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  child: const Text("Cancel"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // View details
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00C853),
                                  ),
                                  child: const Text("View Details"),
                                ),
                              ),
                            ],
                          )
                        else if (trip['status'] == 'Completed')
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // Rate trip
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.amber,
                                    side: const BorderSide(color: Colors.amber),
                                  ),
                                  icon: const Icon(Icons.star, size: 16),
                                  label: Text("Rate (${trip['rating']})"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Book again
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00C853),
                                  ),
                                  child: const Text("Book Again"),
                                ),
                              ),
                            ],
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                // Book again
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF00C853),
                                side:
                                    const BorderSide(color: Color(0xFF00C853)),
                              ),
                              child: const Text("Book Again"),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Upcoming':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}