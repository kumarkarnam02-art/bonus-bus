import 'package:flutter/material.dart';

class BusSplitChangePage extends StatefulWidget {
  const BusSplitChangePage({super.key});

  @override
  State<BusSplitChangePage> createState() => _BusSplitChangePageState();
}

class _BusSplitChangePageState extends State<BusSplitChangePage> {
  // Active booking data
  Map<String, dynamic> activeBooking = {
    'bookingId': 'EVB-2024-7890',
    'busNumber': 'EV Bus 101',
    'from': 'Hyderabad',
    'to': 'Bangalore',
    'departureTime': '09:00 AM',
    'arrivalTime': '05:00 PM',
    'currentLocation': 'Near Kurnool',
    'nextStop': 'Anantapur',
    'distanceTraveled': '240 km',
    'distanceRemaining': '329 km',
    'seatNumber': 'A12',
    'farePaid': 1200,
    'bookingDate': '2024-03-15',
  };

  // Split reasons
  List<String> splitReasons = [
    'Change in travel plan',
    'Emergency stop needed',
    'Bus comfort issue',
    'Health emergency',
    'Weather conditions',
    'Personal emergency',
    'Schedule change',
    'Other'
  ];

  String selectedReason = 'Change in travel plan';
  String splitPoint = '';
  String destinationAfterSplit = '';
  bool showAvailableBuses = false;
  bool isSplitting = false;
  double splitCharge = 0.0;

  // Available buses for split
  List<Map<String, dynamic>> availableBuses = [
    {
      'id': 'BUS-202',
      'busNumber': 'EV Bus 202',
      'departureTime': '11:30 AM',
      'arrivalTime': '08:30 PM',
      'availableSeats': 8,
      'splitCharge': 200,
      'route': 'Hyderabad → Bangalore',
      'currentLocation': 'Near Dhone',
      'nextStop': 'Anantapur',
      'eta': '45 mins',
      'amenities': ['AC', 'WiFi', 'Charging'],
    },
    {
      'id': 'BUS-303',
      'busNumber': 'EV Express 303',
      'departureTime': '12:00 PM',
      'arrivalTime': '07:30 PM',
      'availableSeats': 12,
      'splitCharge': 150,
      'route': 'Hyderabad → Bangalore',
      'currentLocation': 'Near Kurnool',
      'nextStop': 'Gooty',
      'eta': '30 mins',
      'amenities': ['AC', 'WiFi', 'TV', 'Snacks'],
    },
    {
      'id': 'BUS-404',
      'busNumber': 'EV Luxury 404',
      'departureTime': '01:00 PM',
      'arrivalTime': '09:00 PM',
      'availableSeats': 5,
      'splitCharge': 300,
      'route': 'Hyderabad → Bangalore',
      'currentLocation': 'Near Hyderabad',
      'nextStop': 'Kurnool',
      'eta': '1.5 hours',
      'amenities': ['Premium AC', 'WiFi', 'TV', 'Meals', 'Massage'],
    },
  ];

  // Split points (intermediate stops) - Initialize in initState
  late List<String> splitPoints;
  
  // Destinations after split
  List<String> destinations = [
    'Continue to Bangalore',
    'Return to Hyderabad',
    'Deviate to Chennai',
    'Deviate to Mumbai',
    'Stop at Intermediate City',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize splitPoints after activeBooking is available
    splitPoints = [
      'Next Stop (${activeBooking['nextStop']})',
      'Anantapur',
      'Dharmavaram',
      'Hindupur',
      'Chikkaballapur',
      'Other Location'
    ];
    
    splitPoint = splitPoints[0];
    destinationAfterSplit = destinations[0];
  }

  // Calculate split charge based on distance remaining
  double calculateSplitCharge(Map<String, dynamic> bus) {
    double baseCharge = bus['splitCharge'].toDouble();
    
    // Additional logic based on split reason
    if (selectedReason.contains('Emergency')) {
      baseCharge *= 0.5; // 50% discount for emergencies
    }
    
    return baseCharge;
  }

  void initiateSplit() {
    setState(() {
      isSplitting = true;
      showAvailableBuses = true;
    });
  }

  void confirmSplitChange(Map<String, dynamic> newBus) {
    double charge = calculateSplitCharge(newBus);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.directions_bus, color: Colors.green),
              SizedBox(width: 10),
              Text("Confirm Bus Change"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Please confirm your bus change details:"),
              const SizedBox(height: 16),
              _buildDetailRow("From Bus", activeBooking['busNumber']),
              _buildDetailRow("To Bus", newBus['busNumber']),
              _buildDetailRow("Split Point", splitPoint),
              _buildDetailRow("New Destination", destinationAfterSplit),
              _buildDetailRow("Reason", selectedReason),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Change Charge:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "₹${charge.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C853),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Original fare: ₹${activeBooking['farePaid']}",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "💰 No refund for traveled distance. Only additional charges apply.",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _completeSplitChange(newBus, charge);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
              ),
              child: const Text("CONFIRM CHANGE"),
            ),
          ],
        );
      },
    );
  }

  void _completeSplitChange(Map<String, dynamic> newBus, double charge) {
    // In real app, this would call an API
    setState(() {
      isSplitting = false;
      showAvailableBuses = false;
    });

    // Update active booking with new bus
    activeBooking['busNumber'] = newBus['busNumber'];
    activeBooking['splitCharge'] = charge;
    activeBooking['splitReason'] = selectedReason;
    activeBooking['splitTime'] = DateTime.now().toString();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "✅ Bus changed to ${newBus['busNumber']}! Charge: ₹${charge.toStringAsFixed(0)}",
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:", style: TextStyle(color: Colors.grey.shade700)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Split & Change"),
        backgroundColor: const Color(0xFF00C853),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ACTIVE BOOKING CARD
            Card(
              elevation: 4,
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
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                          color: const Color(0xFF00C853).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.directions_bus,
                            color: Color(0xFF00C853),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeBooking['busNumber'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${activeBooking['from']} → ${activeBooking['to']}",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: const Text(
                            "Active",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3.5,
                      ),
                      children: [
                        _buildBookingDetail("Seat", activeBooking['seatNumber'], Icons.event_seat),
                        _buildBookingDetail("Departure", activeBooking['departureTime'], Icons.schedule),
                        _buildBookingDetail("Arrival", activeBooking['arrivalTime'], Icons.flag),
                        _buildBookingDetail("Fare", "₹${activeBooking['farePaid']}", Icons.attach_money),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue.shade700, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Current Status",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "📍 ${activeBooking['currentLocation']} • Next: ${activeBooking['nextStop']}",
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "📏 ${activeBooking['distanceTraveled']} traveled • ${activeBooking['distanceRemaining']} remaining",
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// SPLIT REQUEST SECTION
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.swap_horiz, color: Colors.orange),
                        SizedBox(width: 10),
                        Text(
                          "Request Bus Split/Change",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Change your bus during travel with minimum charges",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 20),

                    /// SPLIT REASON
                    const Text(
                      "Reason for Split/Change",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: selectedReason,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Select reason",
                      ),
                      items: splitReasons.map((reason) {
                        return DropdownMenuItem(
                          value: reason,
                          child: Text(reason),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedReason = value!);
                      },
                    ),

                    const SizedBox(height: 16),

                    /// SPLIT POINT
                    const Text(
                      "Where to Split/Change?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: splitPoint,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Select split point",
                      ),
                      items: splitPoints.map((point) {
                        return DropdownMenuItem(
                          value: point,
                          child: Text(point),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => splitPoint = value!);
                      },
                    ),

                    const SizedBox(height: 16),

                    /// NEW DESTINATION
                    const Text(
                      "Destination After Split",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: destinationAfterSplit,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Select destination",
                      ),
                      items: destinations.map((dest) {
                        return DropdownMenuItem(
                          value: dest,
                          child: Text(dest),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => destinationAfterSplit = value!);
                      },
                    ),

                    const SizedBox(height: 20),

                    /// INFO CARD
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.orange.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.orange.shade700, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Split Charges Apply",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Minimum charges: ₹150-300 based on availability\n"
                                  "No refund for traveled distance\n"
                                  "Emergency cases: 50% discount",
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// INITIATE SPLIT BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: initiateSplit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: const Text(
                          "FIND ALTERNATIVE BUSES",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// AVAILABLE BUSES FOR SPLIT
            if (showAvailableBuses) ...[
              const Text(
                "Available Buses for Split",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Select a bus to continue your journey",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ...availableBuses.map((bus) => _buildAvailableBusCard(bus)),
            ],

            /// SPLITTING IN PROGRESS
            if (isSplitting && !showAvailableBuses)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Processing your bus change..."),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            /// SPLIT POLICY
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Split & Change Policy",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPolicyItem("✅ Minimum charges apply (₹150-300)"),
                    _buildPolicyItem("✅ No refund for traveled distance"),
                    _buildPolicyItem("✅ 50% discount for medical emergencies"),
                    _buildPolicyItem("✅ Seat availability subject to change"),
                    _buildPolicyItem("✅ Split at designated stops only"),
                    _buildPolicyItem("✅ 24/7 customer support for changes"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetail(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableBusCard(Map<String, dynamic> bus) {
    double charge = calculateSplitCharge(bus);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_bus, color: Colors.orange, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bus['busNumber'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bus['route'],
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${bus['availableSeats']} seats",
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 6),
                Text("Dep: ${bus['departureTime']}"),
                const SizedBox(width: 16),
                Icon(Icons.flag, size: 16, color: Colors.red.shade700),
                const SizedBox(width: 6),
                Text("Arr: ${bus['arrivalTime']}"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.green.shade700),
                const SizedBox(width: 6),
                Text("Current: ${bus['currentLocation']}"),
                const SizedBox(width: 16),
                Icon(Icons.timer, size: 16, color: Colors.orange.shade700),
                const SizedBox(width: 6),
                Text("ETA: ${bus['eta']}"),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List<Widget>.from(bus['amenities'].map((amenity) {
                return Chip(
                  label: Text(amenity),
                  labelStyle: const TextStyle(fontSize: 10),
                  backgroundColor: Colors.grey.shade100,
                );
              })),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Split Charge",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                      Text(
                        "₹${charge.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00C853),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => confirmSplitChange(bus),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.swap_horiz, size: 18),
                    label: const Text("SELECT BUS"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
        ],
      )
      );
  }
}