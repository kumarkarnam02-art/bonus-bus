import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupBookingPage extends StatefulWidget {
  const GroupBookingPage({super.key});

  @override
  State<GroupBookingPage> createState() => _GroupBookingPageState();
}

class _GroupBookingPageState extends State<GroupBookingPage> {
  String vehicleType = 'Car';
  int passengers = 4;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String pickup = 'Hyderabad';
  String drop = 'Bangalore';
  bool showResults = false;
  String tripType = 'One Way';
  bool needReturnTrip = false;
  DateTime? returnDate;

  final List<String> locations = [
    'Hyderabad',
    'Bangalore',
    'Chennai',
    'Vizag',
    'Mumbai',
    'Delhi',
  ];

  final List<String> tripTypes = ['One Way', 'Round Trip', 'Multi City'];

  /// EV BUSES with pricing
  final List<Map<String, dynamic>> evBuses = [
    {'name': 'EV Mini Bus', 'seats': 20, 'perKmRate': 30, 'baseFare': 1500, 'features': ['AC', 'WiFi', 'Charging Ports']},
    {'name': 'EV City Bus', 'seats': 35, 'perKmRate': 25, 'baseFare': 2000, 'features': ['AC', 'WiFi', 'TV', 'Charging']},
    {'name': 'EV Luxury Bus', 'seats': 50, 'perKmRate': 35, 'baseFare': 3000, 'features': ['Premium AC', 'WiFi', 'TV', 'Snacks', 'Charging']},
  ];

  /// EV CARS with pricing
  final List<Map<String, dynamic>> evCars = [
    {'name': 'EV Hatchback', 'capacity': 4, 'perKmRate': 15, 'baseFare': 800, 'features': ['AC', 'Music']},
    {'name': 'EV Sedan', 'capacity': 5, 'perKmRate': 18, 'baseFare': 1000, 'features': ['AC', 'WiFi', 'Music']},
    {'name': 'EV SUV', 'capacity': 7, 'perKmRate': 22, 'baseFare': 1200, 'features': ['AC', 'WiFi', 'Sunroof', 'Spacious']},
  ];

  // Distance matrix between cities (in km)
  final Map<String, Map<String, int>> distances = {
    'Hyderabad': {'Bangalore': 569, 'Chennai': 627, 'Vizag': 350, 'Mumbai': 710, 'Delhi': 1580},
    'Bangalore': {'Hyderabad': 569, 'Chennai': 345, 'Vizag': 880, 'Mumbai': 983, 'Delhi': 2174},
    'Chennai': {'Hyderabad': 627, 'Bangalore': 345, 'Vizag': 800, 'Mumbai': 1332, 'Delhi': 2189},
    'Vizag': {'Hyderabad': 350, 'Bangalore': 880, 'Chennai': 800, 'Mumbai': 1350, 'Delhi': 1750},
    'Mumbai': {'Hyderabad': 710, 'Bangalore': 983, 'Chennai': 1332, 'Vizag': 1350, 'Delhi': 1420},
    'Delhi': {'Hyderabad': 1580, 'Bangalore': 2174, 'Chennai': 2189, 'Vizag': 1750, 'Mumbai': 1420},
  };

  /// SMART CAR SPLIT LOGIC WITH COST OPTIMIZATION
  List<Map<String, dynamic>> allocateCars(int members) {
    List<Map<String, dynamic>> allocation = [];
    int remaining = members;
    
    // Calculate distance
    int distance = distances[pickup]?[drop] ?? 500; // Default 500km
    
    // Sort cars by capacity (largest first)
    final sortedCars = List<Map<String, dynamic>>.from(evCars)
      ..sort((a, b) => b['capacity'].compareTo(a['capacity']));

    // Try different combinations to minimize cost
    List<Map<String, dynamic>> bestAllocation = [];
    double bestCost = double.infinity;

    // Try each car type as primary
    for (int i = 0; i < sortedCars.length; i++) {
      List<Map<String, dynamic>> currentAllocation = [];
      int tempRemaining = members;
      double currentCost = 0;

      // Use current car type first
      var car = sortedCars[i];
      int count = (tempRemaining / car['capacity']).ceil();
      currentAllocation.add({
        'name': car['name'],
        'capacity': car['capacity'],
        'count': count,
        'perKmRate': car['perKmRate'],
        'baseFare': car['baseFare'],
        'distance': distance,
        'totalFare': count * (car['baseFare'] + (distance * car['perKmRate'])),
        'features': car['features'],
      });
      currentCost += count * (car['baseFare'] + (distance * car['perKmRate']));

      // Check if this is better than current best
      if (currentCost < bestCost) {
        bestCost = currentCost;
        bestAllocation = List.from(currentAllocation);
      }
    }

    // Simple fallback if no allocation found
    if (bestAllocation.isEmpty) {
      final fitCar = evCars.firstWhere(
        (c) => c['capacity'] >= members,
        orElse: () => evCars.last,
      );
      bestAllocation.add({
        'name': fitCar['name'],
        'capacity': fitCar['capacity'],
        'count': 1,
        'perKmRate': fitCar['perKmRate'],
        'baseFare': fitCar['baseFare'],
        'distance': distance,
        'totalFare': fitCar['baseFare'] + (distance * fitCar['perKmRate']),
        'features': fitCar['features'],
      });
    }

    return bestAllocation;
  }

  double calculateBusFare(Map<String, dynamic> bus) {
    int distance = distances[pickup]?[drop] ?? 500;
    double baseFare = bus['baseFare'].toDouble();
    double perKmRate = bus['perKmRate'].toDouble();
    double distanceFare = distance * perKmRate;
    
    // Group discount: 5% discount for 10+ passengers, 10% for 20+
    double discount = 0;
    if (passengers >= 20) {
      discount = 0.10;
    } else if (passengers >= 10) {
      discount = 0.05;
    }
    
    double totalFare = (baseFare + distanceFare) * (1 - discount);
    
    // Round trip discount
    if (tripType == 'Round Trip' && needReturnTrip) {
      totalFare *= 1.8; // 10% discount on return
    }
    
    return totalFare;
  }

  @override
  Widget build(BuildContext context) {
    int distance = distances[pickup]?[drop] ?? 500;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Booking"),
        backgroundColor: const Color(0xFF00C853),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TRIP TYPE
            const Text(
              "Trip Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tripTypes.map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: tripType == type,
                  selectedColor: const Color(0xFF00C853),
                  labelStyle: TextStyle(
                    color: tripType == type ? Colors.white : Colors.black,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      tripType = type;
                      if (type == 'Round Trip') {
                        needReturnTrip = true;
                        returnDate = selectedDate.add(const Duration(days: 1));
                      } else {
                        needReturnTrip = false;
                        returnDate = null;
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// VEHICLE TYPE
            const Text(
              "Select Vehicle Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ToggleButtons(
              isSelected: [vehicleType == 'Car', vehicleType == 'Bus'],
              onPressed: (index) {
                setState(() {
                  vehicleType = index == 0 ? 'Car' : 'Bus';
                  showResults = false;
                });
              },
              borderRadius: BorderRadius.circular(14),
              selectedColor: Colors.white,
              fillColor: const Color(0xFF00C853),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.directions_car),
                      SizedBox(width: 8),
                      Text("EV Cars"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.directions_bus),
                      SizedBox(width: 8),
                      Text("EV Buses"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// PASSENGERS
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
                      "Number of Passengers",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (passengers > 1) {
                              setState(() => passengers--);
                            }
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.remove, size: 20),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              passengers.toString(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00C853),
                              ),
                            ),
                            Text(
                              passengers == 1 ? "Passenger" : "Passengers",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            if (passengers < 50) {
                              setState(() => passengers++);
                            }
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF00C853),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, size: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: passengers / 50,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF00C853),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Max capacity: 50 passengers",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TRAVEL DATE & TIME
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.calendar_today, color: Color(0xFF00C853)),
                      title: const Text("Departure Date"),
                      subtitle: Text(DateFormat('dd MMM yyyy, EEEE').format(selectedDate)),
                      trailing: const Icon(Icons.edit),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          initialDate: selectedDate,
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.schedule, color: Color(0xFF00C853)),
                      title: const Text("Departure Time"),
                      subtitle: Text(selectedTime.format(context)),
                      trailing: const Icon(Icons.edit),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setState(() => selectedTime = picked);
                        }
                      },
                    ),
                    if (needReturnTrip && returnDate != null) ...[
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.calendar_today, color: Colors.orange),
                        title: const Text("Return Date"),
                        subtitle: Text(DateFormat('dd MMM yyyy').format(returnDate!)),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: selectedDate,
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            initialDate: returnDate!,
                          );
                          if (picked != null) {
                            setState(() => returnDate = picked);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LOCATIONS
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: pickup,
                      decoration: const InputDecoration(
                        labelText: "Pickup Location",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on, color: Colors.green),
                      ),
                      items: locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          pickup = value!;
                          showResults = false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: drop,
                      decoration: const InputDecoration(
                        labelText: "Destination",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on, color: Colors.red),
                      ),
                      items: locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          drop = value!;
                          showResults = false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    if (distance > 0)
                      Row(
                        children: [
                          Icon(Icons.arrow_right, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            "Distance: ${distance} km",
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// SEARCH BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => showResults = true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text(
                  "FIND VEHICLES",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// RESULTS
            if (showResults) buildResults(distance),
          ],
        ),
      ),
    );
  }

  /// VEHICLE RESULTS
  Widget buildResults(int distance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available ${vehicleType}s",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Showing vehicles for $passengers passengers from $pickup to $drop ($distance km)",
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),

        if (vehicleType == 'Bus')
          ..._buildBusResults(distance)
        else
          ..._buildCarResults(distance),

        const SizedBox(height: 20),

        // Group Discount Info
        Card(
          color: Colors.green.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.discount, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group Discounts Available",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        passengers >= 10
                            ? "🎉 You qualify for ${passengers >= 20 ? '10%' : '5%'} group discount!"
                            : "Book for 10+ passengers to get 5% discount",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBusResults(int distance) {
    final suitableBuses = evBuses.where((bus) => bus['seats'] >= passengers).toList();
    
    if (suitableBuses.isEmpty) {
      return [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text("No buses available for this many passengers. Try multiple cars instead."),
          ),
        ),
      ];
    }

    return suitableBuses.map((bus) {
      double fare = calculateBusFare(bus);
      double perPersonFare = fare / passengers;
      
      return _buildVehicleCard(
        icon: Icons.directions_bus,
        title: bus['name'],
        subtitle: "${bus['seats']} seats • ${distance} km",
        fare: fare,
        perPersonFare: perPersonFare,
        features: List<String>.from(bus['features']),
        vehicleData: bus,
      );
    }).toList();
  }

  List<Widget> _buildCarResults(int distance) {
    final carAllocation = allocateCars(passengers);
    
    return carAllocation.map((car) {
      double fare = car['totalFare'];
      double perPersonFare = fare / passengers;
      
      return _buildVehicleCard(
        icon: Icons.directions_car,
        title: "${car['count']} × ${car['name']}",
        subtitle: "${car['count'] * car['capacity']} total seats",
        fare: fare,
        perPersonFare: perPersonFare,
        features: List<String>.from(car['features']),
        vehicleData: car,
        isCarAllocation: true,
      );
    }).toList();
  }

  Widget _buildVehicleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double fare,
    required double perPersonFare,
    required List<String> features,
    required Map<String, dynamic> vehicleData,
    bool isCarAllocation = false,
  }) {
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF00C853), size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Features
            Wrap(
              spacing: 8,
              children: features.take(3).map((feature) {
                return Chip(
                  label: Text(feature),
                  backgroundColor: Colors.green.shade50,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade800,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Pricing
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
                        "₹${fare.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00C853),
                        ),
                      ),
                      Text(
                        "₹${perPersonFare.toStringAsFixed(0)} per person",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showBookingDialog(vehicleData, fare);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.book_online, size: 20),
                    label: const Text("BOOK NOW"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(Map<String, dynamic> vehicle, double fare) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Group Booking"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  vehicle['name'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Divider(),
                _buildBookingDetail("Passengers", passengers.toString()),
                _buildBookingDetail("From", pickup),
                _buildBookingDetail("To", drop),
                _buildBookingDetail("Date", DateFormat('dd MMM yyyy').format(selectedDate)),
                _buildBookingDetail("Time", selectedTime.format(context)),
                if (needReturnTrip && returnDate != null)
                  _buildBookingDetail("Return Date", DateFormat('dd MMM yyyy').format(returnDate!)),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Fare:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "₹${fare.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00C853),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${(fare / passengers).toStringAsFixed(0)} per person",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${vehicle['name']} booked successfully for $passengers passengers!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
              ),
              child: const Text("CONFIRM BOOKING"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookingDetail(String label, String value) {
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
}