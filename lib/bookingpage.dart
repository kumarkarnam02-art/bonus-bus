import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RealTimeBookingPage extends StatefulWidget {
  const RealTimeBookingPage({super.key});

  @override
  State<RealTimeBookingPage> createState() => _RealTimeBookingPageState();
}

class _RealTimeBookingPageState extends State<RealTimeBookingPage> {
  /// Locations
  final List<String> cities = ['Visakhapatnam', 'Vijayawada', 'Hyderabad', 'Chennai', 'Bangalore'];
  String? fromCity;
  String? toCity;

  /// Boarding & Dropping Points
  final Map<String, List<String>> boardingPoints = {
    'Visakhapatnam': ['RTC Complex', 'Maddilapalem', 'Gajuwaka'],
    'Vijayawada': ['Benz Circle', 'Bus Stand', 'Auto Nagar'],
    'Hyderabad': ['Miyapur', 'LB Nagar', 'Secunderabad'],
    'Chennai': ['Koyambedu', 'Tambaram', 'Guindy'],
    'Bangalore': ['Majestic', 'Silk Board', 'Whitefield'],
  };

  String? selectedBoarding;
  String? selectedDropping;

  /// Intermediate Stops
  List<String> selectedIntermediate = [];

  /// Date & Time
  DateTime travelDate = DateTime.now();
  TimeOfDay travelTime = TimeOfDay.now();

  bool showResults = false;
  bool showInstantBook = false;

  /// Dummy Vehicles
  final List<Map<String, dynamic>> vehicles = [
    {'name': 'EV Sleeper Bus', 'capacity': 40, 'fare': 1200, 'type': 'bus', 'available': true, 'departure': '10:30 AM', 'arrival': '6:30 PM', 'seats': 12},
    {'name': 'EV Semi-Sleeper Bus', 'capacity': 35, 'fare': 1000, 'type': 'bus', 'available': true, 'departure': '11:00 AM', 'arrival': '7:00 PM', 'seats': 8},
    {'name': 'EV Sedan', 'capacity': 4, 'fare': 1800, 'type': 'car', 'available': true, 'departure': 'Now', 'arrival': '8:00 PM', 'seats': 3},
    {'name': 'EV SUV', 'capacity': 6, 'fare': 2200, 'type': 'car', 'available': true, 'departure': 'Now', 'arrival': '8:30 PM', 'seats': 4},
  ];

  /// Live Running Vehicles (for Instant Book)
  final List<Map<String, dynamic>> liveVehicles = [
    {
      'name': 'EV Bus 101',
      'type': 'bus',
      'route': 'Visakhapatnam → Hyderabad',
      'currentLocation': 'Near Anakapalli',
      'nextStop': 'Rajahmundry',
      'distanceAway': '25 km',
      'eta': '45 mins',
      'availableSeats': 8,
      'fare': 950,
      'departure': '9:00 AM',
      'expectedArrival': '5:00 PM',
      'vehicleNo': 'AP31 AB 1234',
      'driver': 'Rajesh Kumar',
      'driverRating': 4.5,
      'ac': true,
      'wifi': true,
      'chargingPorts': true,
    },
    {
      'name': 'EV Bus 202',
      'type': 'bus',
      'route': 'Vijayawada → Bangalore',
      'currentLocation': 'Near Guntur',
      'nextStop': 'Nellore',
      'distanceAway': '50 km',
      'eta': '1 hour 15 mins',
      'availableSeats': 15,
      'fare': 1100,
      'departure': '8:30 AM',
      'expectedArrival': '6:30 PM',
      'vehicleNo': 'AP16 CD 5678',
      'driver': 'Suresh Reddy',
      'driverRating': 4.7,
      'ac': true,
      'wifi': false,
      'chargingPorts': true,
    },
    {
      'name': 'EV Car 303',
      'type': 'car',
      'route': 'Hyderabad → Chennai',
      'currentLocation': 'Near Suryapet',
      'nextStop': 'Vijayawada',
      'distanceAway': '15 km',
      'eta': '20 mins',
      'availableSeats': 3,
      'fare': 2000,
      'departure': 'Now',
      'expectedArrival': '9:00 PM',
      'vehicleNo': 'TS07 EF 9012',
      'driver': 'Karthik Sharma',
      'driverRating': 4.9,
      'ac': true,
      'wifi': true,
      'chargingPorts': true,
    },
    {
      'name': 'EV Bus 404',
      'type': 'bus',
      'route': 'Chennai → Bangalore',
      'currentLocation': 'Near Vellore',
      'nextStop': 'Krishnagiri',
      'distanceAway': '35 km',
      'eta': '55 mins',
      'availableSeats': 5,
      'fare': 850,
      'departure': '10:00 AM',
      'expectedArrival': '4:00 PM',
      'vehicleNo': 'TN22 GH 3456',
      'driver': 'Mohan Das',
      'driverRating': 4.3,
      'ac': true,
      'wifi': true,
      'chargingPorts': true,
    },
    {
      'name': 'EV Car 505',
      'type': 'car',
      'route': 'Bangalore → Hyderabad',
      'currentLocation': 'Near Kurnool',
      'nextStop': 'Hyderabad City',
      'distanceAway': '80 km',
      'eta': '1 hour 30 mins',
      'availableSeats': 2,
      'fare': 2500,
      'departure': 'Now',
      'expectedArrival': '10:00 PM',
      'vehicleNo': 'KA05 IJ 7890',
      'driver': 'Priya Singh',
      'driverRating': 4.8,
      'ac': true,
      'wifi': true,
      'chargingPorts': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Real-Time Booking"),
          backgroundColor: Colors.green.shade700,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'SCHEDULE BOOKING'),
              Tab(text: 'INSTANT BOOK'),
            ],
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [
            /// TAB 1: SCHEDULE BOOKING
            _buildScheduleBookingTab(),
            
            /// TAB 2: INSTANT BOOK (Live Running Vehicles)
            _buildInstantBookTab(),
          ],
        ),
      ),
    );
  }

  /// TAB 1: SCHEDULE BOOKING
  Widget _buildScheduleBookingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// FROM CITY
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "From City",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            initialValue: fromCity,
            hint: const Text("Select Departure City"),
            items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() {
              fromCity = v;
              selectedBoarding = null;
            }),
          ),

          const SizedBox(height: 15),

          /// TO CITY
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "To City",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            initialValue: toCity,
            hint: const Text("Select Destination City"),
            items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() {
              toCity = v;
              selectedDropping = null;
            }),
          ),

          const SizedBox(height: 20),

          /// BOARDING POINT
          if (fromCity != null)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Boarding Point",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              initialValue: selectedBoarding,
              hint: const Text("Select Boarding Point"),
              items: boardingPoints[fromCity]!
                  .map((bp) => DropdownMenuItem(value: bp, child: Text(bp)))
                  .toList(),
              onChanged: (v) => setState(() => selectedBoarding = v),
            ),

          const SizedBox(height: 15),

          /// DROPPING POINT
          if (toCity != null)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Dropping Point",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              initialValue: selectedDropping,
              hint: const Text("Select Dropping Point"),
              items: boardingPoints[toCity]!
                  .map((dp) => DropdownMenuItem(value: dp, child: Text(dp)))
                  .toList(),
              onChanged: (v) => setState(() => selectedDropping = v),
            ),

          const SizedBox(height: 20),

          /// INTERMEDIATE STOPS
          if (fromCity != null && toCity != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Intermediate Stops (Optional)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: cities
                      .where((c) => c != fromCity && c != toCity)
                      .map((c) => FilterChip(
                            label: Text(c),
                            selected: selectedIntermediate.contains(c),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedIntermediate.add(c);
                                } else {
                                  selectedIntermediate.remove(c);
                                }
                              });
                            },
                          ))
                      .toList(),
                ),
              ],
            ),

          const SizedBox(height: 20),

          /// DATE & TIME
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.green),
                  title: const Text("Travel Date", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat('dd MMM yyyy, EEEE').format(travelDate)),
                  trailing: const Icon(Icons.edit),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDate: travelDate,
                    );
                    if (d != null) setState(() => travelDate = d);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.green),
                  title: const Text("Travel Time", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(travelTime.format(context)),
                  trailing: const Icon(Icons.edit),
                  onTap: () async {
                    final t = await showTimePicker(context: context, initialTime: travelTime);
                    if (t != null) setState(() => travelTime = t);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          /// SEARCH BUTTON
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (fromCity == null ||
                    toCity == null ||
                    selectedBoarding == null ||
                    selectedDropping == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select all required fields"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                setState(() => showResults = true);
              },
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                "SEARCH AVAILABLE VEHICLES",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 25),

          /// RESULTS
          if (showResults) _buildVehicleList(),
        ],
      ),
    );
  }

  /// TAB 2: INSTANT BOOK (Live Running Vehicles)
  Widget _buildInstantBookTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_bus, color: Colors.green.shade700, size: 30),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Book Running Vehicles Instantly",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Board a vehicle that's already on the move. "
                    "Real-time tracking, live availability, and instant confirmation.",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// FILTERS
          Row(
            children: [
              Expanded(
                child: FilterChip(
                  label: const Text('All'),
                  selected: true,
                  onSelected: (_) {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilterChip(
                  avatar: Icon(Icons.directions_bus, size: 18, color: Colors.green.shade700),
                  label: const Text('Buses'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilterChip(
                  avatar: Icon(Icons.directions_car, size: 18, color: Colors.blue),
                  label: const Text('Cars'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// LIVE VEHICLES LIST
          const Text(
            "Live Running Vehicles Near You",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...liveVehicles.map((vehicle) => _buildLiveVehicleCard(vehicle)).toList(),

          const SizedBox(height: 30),

          /// INFO CARD
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue.shade700),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Instant Booking: Board within 1-2 hours. "
                      "Fares are dynamic based on availability.",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SCHEDULED VEHICLE CARD
  Widget _buildVehicleList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available Vehicles",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
        ),
        const SizedBox(height: 10),
        ...vehicles.map((v) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        v['capacity'] > 6 ? Icons.directions_bus : Icons.directions_car,
                        color: Colors.green.shade700,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              v['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Seats available: ${v['seats']}",
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹${v['fare']}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "Dep: ${v['departure']}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showVehicleDetails(v);
                          },
                          child: const Text("View Details"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                          ),
                          onPressed: () {
                            _confirmBooking(v);
                          },
                          child: const Text("BOOK NOW"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  /// LIVE VEHICLE CARD
  Widget _buildLiveVehicleCard(Map<String, dynamic> vehicle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Vehicle Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: vehicle['type'] == 'bus' ? Colors.green.shade100 : Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    vehicle['type'] == 'bus' ? Icons.directions_bus : Icons.directions_car,
                    color: vehicle['type'] == 'bus' ? Colors.green.shade700 : Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vehicle['route'],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
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
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vehicle['driverRating'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Current Status
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Currently near ${vehicle['currentLocation']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 18, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Next stop: ${vehicle['nextStop']} (ETA: ${vehicle['eta']})",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${vehicle['availableSeats']} seats left",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Features
            Wrap(
              spacing: 10,
              children: [
                if (vehicle['ac'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.ac_unit, size: 14, color: Colors.blue.shade700),
                        const SizedBox(width: 4),
                        const Text("AC", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                if (vehicle['wifi'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi, size: 14, color: Colors.green.shade700),
                        const SizedBox(width: 4),
                        const Text("WiFi", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                if (vehicle['chargingPorts'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.charging_station, size: 14, color: Colors.orange.shade700),
                        const SizedBox(width: 4),
                        const Text("Charging", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            /// Fare and Action
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹${vehicle['fare']}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "Per seat • ${vehicle['vehicleNo']}",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _confirmInstantBooking(vehicle);
                  },
                  icon: const Icon(Icons.directions_bus, size: 20),
                  label: const Text(
                    "INSTANT BOOK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// SHOW VEHICLE DETAILS DIALOG
  void _showVehicleDetails(Map<String, dynamic> vehicle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(vehicle['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.people, color: Colors.green),
                title: const Text("Capacity"),
                subtitle: Text("${vehicle['capacity']} passengers"),
              ),
              ListTile(
                leading: const Icon(Icons.attach_money, color: Colors.green),
                title: const Text("Fare"),
                subtitle: Text("₹${vehicle['fare']}"),
              ),
              ListTile(
                leading: const Icon(Icons.event_seat, color: Colors.green),
                title: const Text("Available Seats"),
                subtitle: Text("${vehicle['seats']} seats"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CLOSE"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmBooking(vehicle);
              },
              child: const Text("BOOK NOW"),
            ),
          ],
        );
      },
    );
  }

  /// CONFIRM REGULAR BOOKING
  void _confirmBooking(Map<String, dynamic> vehicle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Booking"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehicle['name'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text("Route: $fromCity → $toCity"),
              Text("Boarding: $selectedBoarding"),
              Text("Date: ${DateFormat('dd MMM yyyy').format(travelDate)}"),
              Text("Time: ${travelTime.format(context)}"),
              const SizedBox(height: 10),
              Text(
                "Fare: ₹${vehicle['fare']}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
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
                Future.delayed(const Duration(milliseconds: 100), () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${vehicle['name']} booked successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                });
              },
              child: const Text("CONFIRM BOOKING"),
            ),
          ],
        );
      },
    );
  }

  /// CONFIRM INSTANT BOOKING
  void _confirmInstantBooking(Map<String, dynamic> vehicle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Instant Booking"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehicle['name'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text("Route: ${vehicle['route']}"),
              Text("Current Location: ${vehicle['currentLocation']}"),
              Text("Next Stop: ${vehicle['nextStop']} (ETA: ${vehicle['eta']})"),
              Text("Driver: ${vehicle['driver']} ⭐ ${vehicle['driverRating']}"),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.directions_bus, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Text("Vehicle: ${vehicle['vehicleNo']}"),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Fare: ₹${vehicle['fare']}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "⚠ Board within ${vehicle['eta']} at ${vehicle['nextStop']}",
                style: TextStyle(color: Colors.orange.shade700),
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
                Future.delayed(const Duration(milliseconds: 100), () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Instant booking confirmed for ${vehicle['name']}! "
                        "Driver will contact you soon.",
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  // Simulate sending booking details
                  _showBookingSummary(vehicle);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              child: const Text("BOOK INSTANTLY"),
            ),
          ],
        );
      },
    );
  }

  /// SHOW BOOKING SUMMARY
  void _showBookingSummary(Map<String, dynamic> vehicle) {
    Future.delayed(const Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text("Booking Confirmed!"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 15),
                const Text("📱 Driver will contact you on your registered mobile number"),
                const SizedBox(height: 10),
                const Text("📍 Meet at the boarding point"),
                const SizedBox(height: 10),
                const Text("⏰ Be ready 15 minutes before estimated arrival"),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Booking Details:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text("Booking ID: EV${DateTime.now().millisecondsSinceEpoch}"),
                      Text("Amount Paid: ₹${vehicle['fare']}"),
                      Text("Status: Confirmed"),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("DONE"),
              ),
            ],
          );
        },
      );
    });
  }
}