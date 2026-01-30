import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// --------------------
/// OFF-PEAK RULE MODEL
/// --------------------
class OffPeakRule {
  final String name;
  final int startHour;
  final int endHour;
  final double discount; // 0.25 = 25%
  final bool enabled;
  final Color color;
  final String description;

  OffPeakRule({
    required this.name,
    required this.startHour,
    required this.endHour,
    required this.discount,
    required this.enabled,
    required this.color,
    required this.description,
  });
}

class OffPeakBookingPage extends StatefulWidget {
  const OffPeakBookingPage({super.key});

  @override
  State<OffPeakBookingPage> createState() => _OffPeakBookingPageState();
}

class _OffPeakBookingPageState extends State<OffPeakBookingPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int passengers = 2;
  bool showVehicles = false;
  String? selectedVehicle;
  String pickupLocation = 'Current Location';
  String dropLocation = 'Enter Destination';

  /// --------------------
  /// VEHICLE DATA
  /// --------------------
  final List<Map<String, dynamic>> vehicles = [
    {
      'type': 'Car', 
      'name': 'EV Sedan', 
      'capacity': 5, 
      'baseFare': 180,
      'image': '🚗',
      'features': ['AC', 'Fast Charging', 'Music System']
    },
    {
      'type': 'Car', 
      'name': 'EV SUV', 
      'capacity': 7, 
      'baseFare': 220,
      'image': '🚙',
      'features': ['AC', 'Luggage Space', 'Premium']
    },
    {
      'type': 'Bus', 
      'name': 'EV Mini Bus', 
      'capacity': 20, 
      'baseFare': 120,
      'image': '🚌',
      'features': ['Group Travel', 'Economical', 'Spacious']
    },
    {
      'type': 'Bus', 
      'name': 'EV City Bus', 
      'capacity': 35, 
      'baseFare': 100,
      'image': '🚎',
      'features': ['Most Economical', 'Environment Friendly', 'Comfortable']
    },
  ];

  /// --------------------
  /// ENHANCED OFF-PEAK RULE ENGINE
  /// --------------------
  final List<OffPeakRule> offPeakRules = [
    OffPeakRule(
      name: 'Night Owl Discount',
      startHour: 22,
      endHour: 6,
      discount: 0.30,
      enabled: true,
      color: Colors.indigo,
      description: 'Late night special discount',
    ),
    OffPeakRule(
      name: 'Midday Saver',
      startHour: 11,
      endHour: 16,
      discount: 0.25,
      enabled: true,
      color: Colors.orange,
      description: 'Avoid lunch hour crowds',
    ),
    OffPeakRule(
      name: 'Weekend Special',
      startHour: 14,
      endHour: 18,
      discount: 0.20,
      enabled: true,
      color: Colors.purple,
      description: 'Saturday & Sunday special',
    ),
  ];

  /// Detect off-peak rule
  OffPeakRule? detectOffPeak(TimeOfDay time) {
    for (final rule in offPeakRules) {
      if (!rule.enabled) continue;

      if (rule.startHour < rule.endHour) {
        if (time.hour >= rule.startHour && time.hour < rule.endHour) {
          return rule;
        }
      } else {
        // Overnight case (22 → 6)
        if (time.hour >= rule.startHour || time.hour < rule.endHour) {
          return rule;
        }
      }
    }
    return null;
  }

  /// Nearest off-peak suggestion
  TimeOfDay nearestOffPeak(TimeOfDay current) {
    for (final rule in offPeakRules) {
      if (current.hour < rule.startHour) {
        return TimeOfDay(hour: rule.startHour, minute: 0);
      }
    }
    return const TimeOfDay(hour: 0, minute: 0); // next day
  }

  /// Fare calculation
  double calculateFare(int baseFare, OffPeakRule? rule) {
    if (rule == null) return baseFare.toDouble();
    return baseFare * (1 - rule.discount);
  }

  /// Format time for display
  String formatTime(int hour) {
    final time = TimeOfDay(hour: hour, minute: 0);
    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    final OffPeakRule? activeRule = detectOffPeak(selectedTime);
    final bool isOffPeak = activeRule != null;
    final double totalSavings = isOffPeak ? 
        vehicles.fold(0, (sum, v) => sum + (v['baseFare'] * activeRule!.discount)) : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Off-Peak Booking"),
        backgroundColor: const Color(0xFF00C853),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showOffPeakInfo();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER WITH SAVINGS
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isOffPeak ? Colors.green.shade100 : Colors.orange.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isOffPeak ? Icons.bolt : Icons.schedule,
                        color: isOffPeak ? Colors.green : Colors.orange,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isOffPeak ? "💰 You're Saving!" : "⏰ Peak Hours",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isOffPeak
                                ? "Save ${(activeRule!.discount * 100).toInt()}% on all rides"
                                : "Switch to off-peak for better deals",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isOffPeak)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Text(
                          "SAVE ${(activeRule.discount * 100).toInt()}%",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LOCATION INPUTS
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.my_location, color: Colors.blue, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pickup Location",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                pickupLocation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on, color: Colors.green, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Drop Location",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Open location search
                                },
                                child: Text(
                                  dropLocation,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.grey,
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
            ),

            const SizedBox(height: 20),

            // DATE & TIME SELECTION
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.blue.shade700),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Date",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final d = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                      initialDate: selectedDate,
                                    );
                                    if (d != null) setState(() => selectedDate = d);
                                  },
                                  child: Text(
                                    DateFormat('EEE, dd MMM yyyy').format(selectedDate),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.orange.shade700),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Time",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final t = await showTimePicker(
                                      context: context,
                                      initialTime: selectedTime,
                                    );
                                    if (t != null) setState(() => selectedTime = t);
                                  },
                                  child: Text(
                                    selectedTime.format(context),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // OFF-PEAK SUGGESTION (PEAK STATE)
                    if (!isOffPeak)
                      _buildSuggestionBanner(activeRule),
                    
                    // OFF-PEAK ACTIVE BANNER
                    if (isOffPeak)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [activeRule.color.withOpacity(0.1), Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: activeRule.color.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.bolt, color: activeRule.color),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activeRule.name,
                                    style: TextStyle(
                                      color: activeRule.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${formatTime(activeRule.startHour)} - ${formatTime(activeRule.endHour)}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: activeRule.color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${(activeRule.discount * 100).toInt()}% OFF",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
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

            // PASSENGERS SELECTION
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Passengers",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: passengers > 1 ? Colors.red.shade100 : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.remove,
                              color: passengers > 1 ? Colors.red : Colors.grey,
                            ),
                          ),
                          onPressed: () {
                            if (passengers > 1) {
                              setState(() => passengers--);
                            }
                          },
                        ),
                        Column(
                          children: [
                            Text(
                              passengers.toString(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              passengers == 1 ? "person" : "people",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                          ),
                          onPressed: () => setState(() => passengers++),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // FIND VEHICLES BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => showVehicles = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.directions_bus, color: Colors.white),
                label: const Text(
                  "FIND AVAILABLE VEHICLES",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // VEHICLE LIST
            if (showVehicles) _buildVehicleList(activeRule),

            // OFF-PEAK SCHEDULE INFO
            if (!showVehicles) _buildOffPeakSchedule(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// --------------------
  /// PEAK → OFF-PEAK NUDGE
  /// --------------------
  Widget _buildSuggestionBanner(OffPeakRule? rule) {
    final suggested = nearestOffPeak(selectedTime);
    final currentHour = selectedTime.hour;
    final hoursToWait = suggested.hour > currentHour 
        ? suggested.hour - currentHour 
        : (24 - currentHour) + suggested.hour;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.orange.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              const Text(
                "Smart Suggestion",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              children: [
                const TextSpan(text: "Book at "),
                TextSpan(
                  text: "${suggested.format(context)} ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                TextSpan(text: "($hoursToWait hr${hoursToWait > 1 ? 's' : ''} later) to get "),
                const TextSpan(
                  text: "up to 30% discount",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const TextSpan(text: " and faster vehicle allocation."),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // View all off-peak slots
                    _showAllOffPeakSlots();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("View All Slots"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => selectedTime = suggested);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Switch Now"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// --------------------
  /// VEHICLE LIST
  /// --------------------
  Widget _buildVehicleList(OffPeakRule? rule) {
    final available = vehicles.where((v) => v['capacity'] >= passengers).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Vehicles",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...available.map((v) {
          final peakFare = v['baseFare'] * passengers;
          final offPeakFare = calculateFare(v['baseFare'], rule) * passengers;
          final savings = peakFare - offPeakFare;
          final isSelected = selectedVehicle == v['name'];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isSelected ? const Color(0xFF00C853) : Colors.transparent,
                width: isSelected ? 2 : 0,
              ),
            ),
            elevation: isSelected ? 4 : 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  selectedVehicle = v['name'];
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Vehicle Icon/Image
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          v['image'],
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Vehicle Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                v['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              if (rule != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "SAVE ${(rule.discount * 100).toInt()}%",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${v['capacity']} seats • ${v['features'].join(' • ')}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (rule == null)
                                Text(
                                  "₹${peakFare.toInt()}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "₹${offPeakFare.toInt()}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      "₹${peakFare.toInt()}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              const Spacer(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00C853),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  _showBookingConfirmation(v, offPeakFare, rule);
                                },
                                child: const Text("Book Now"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  /// --------------------
  /// OFF-PEAK SCHEDULE INFO
  /// --------------------
  Widget _buildOffPeakSchedule() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Off-Peak Schedule",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...offPeakRules.map((rule) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: rule.color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: rule.color.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: rule.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bolt,
                        color: rule.color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rule.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: rule.color,
                            ),
                          ),
                          Text(
                            "${formatTime(rule.startHour)} - ${formatTime(rule.endHour)}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            rule.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: rule.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${(rule.discount * 100).toInt()}% OFF",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// --------------------
  /// DIALOGS & BOTTOM SHEETS
  /// --------------------
  void _showOffPeakInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Off-Peak Booking Benefits"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBenefitItem(Icons.savings, "Lower Fares", "Save 20-30% compared to peak hours"),
              _buildBenefitItem(Icons.bolt, "Faster Allocation", "Get vehicles quickly during off-peak"),
              _buildBenefitItem(Icons.eco, "Green Bonus", "Extra eco-points for off-peak rides"),
              _buildBenefitItem(Icons.star, "Priority Support", "Enhanced customer support"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00C853)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAllOffPeakSlots() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "All Off-Peak Time Slots",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Choose a time slot to get maximum discount:",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: offPeakRules.map((rule) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: rule.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.bolt, color: rule.color),
                        ),
                        title: Text(rule.name),
                        subtitle: Text(
                          "${formatTime(rule.startHour)} - ${formatTime(rule.endHour)}",
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: rule.color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${(rule.discount * 100).toInt()}% OFF",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            selectedTime = TimeOfDay(hour: rule.startHour, minute: 0);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookingConfirmation(Map<String, dynamic> vehicle, double fare, OffPeakRule? rule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Confirm Booking",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      vehicle['image'],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                title: Text(vehicle['name']),
                subtitle: Text("${vehicle['capacity']} seats • ${passengers} passengers"),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              _buildBookingDetail("Date", DateFormat('EEE, dd MMM yyyy').format(selectedDate)),
              _buildBookingDetail("Time", selectedTime.format(context)),
              _buildBookingDetail("Pickup", pickupLocation),
              if (rule != null)
                _buildBookingDetail("Discount", "${(rule.discount * 100).toInt()}% Off-Peak"),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Fare",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "₹${fare.toInt()}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C853),
                    ),
                  ),
                ],
              ),
              if (rule != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "You saved ₹${(vehicle['baseFare'] * passengers * rule.discount).toInt()}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Booking confirmed for ${vehicle['name']}"),
                        backgroundColor: const Color(0xFF00C853),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "CONFIRM & PAY NOW",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}