import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecurringBookingPage extends StatefulWidget {
  const RecurringBookingPage({super.key});

  @override
  State<RecurringBookingPage> createState() => _RecurringBookingPageState();
}

class _RecurringBookingPageState extends State<RecurringBookingPage> {
  String vehicleType = "EV Bus";
  String frequency = "Daily";
  int durationWeeks = 4; // Duration in weeks
  TimeOfDay pickupTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay dropTime = const TimeOfDay(hour: 17, minute: 0);
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  String pickupLocation = "";
  String dropLocation = "";
  bool roundTrip = false;
  bool autoRenew = true;
  double discount = 0.0;

  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  List<String> selectedDays = ["Mon", "Tue", "Wed", "Thu", "Fri"];
  List<int> monthlyDates = List.generate(31, (index) => index + 1);
  List<int> selectedMonthlyDates = [1, 15];

  // Sample locations
  final List<String> locations = [
    "Home - Gachibowli",
    "Office - Hitech City",
    "College - OU Campus",
    "Station - Secunderabad",
    "Airport - RGIA",
    "Mall - Inorbit",
  ];

  // Vehicle options with pricing
  final Map<String, Map<String, dynamic>> vehicles = {
    "EV Bus": {
      "icon": Icons.directions_bus,
      "capacity": 40,
      "perTripRate": 1200,
      "color": Colors.green,
      "features": ["AC", "WiFi", "Charging Ports", "Comfort Seats"]
    },
    "EV Car": {
      "icon": Icons.directions_car,
      "capacity": 4,
      "perTripRate": 800,
      "color": Colors.blue,
      "features": ["AC", "Music", "Fast Charging"]
    },
    "EV SUV": {
      "icon": Icons.directions_car,
      "capacity": 6,
      "perTripRate": 1000,
      "color": Colors.orange,
      "features": ["AC", "WiFi", "Spacious", "Premium"]
    },
    "EV Minibus": {
      "icon": Icons.directions_bus,
      "capacity": 20,
      "perTripRate": 1800,
      "color": Colors.purple,
      "features": ["AC", "TV", "Charging", "Comfort"]
    },
  };

  // Frequency options
  final Map<String, dynamic> frequencyOptions = {
    "Daily": {"discount": 0.10, "description": "Every day"},
    "Weekly": {"discount": 0.15, "description": "Selected days per week"},
    "Monthly": {"discount": 0.20, "description": "Selected dates each month"},
    "Weekdays": {"discount": 0.12, "description": "Monday to Friday"},
    "Weekends": {"discount": 0.08, "description": "Saturday & Sunday"},
  };

  Future<void> pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: startDate,
    );
    if (date != null) {
      setState(() {
        startDate = date;
        if (endDate != null && endDate!.isBefore(date)) {
          endDate = date.add(Duration(days: durationWeeks * 7));
        }
      });
    }
  }

  Future<void> pickEndDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      initialDate: endDate ?? startDate.add(Duration(days: durationWeeks * 7)),
    );
    if (date != null) {
      setState(() => endDate = date);
    }
  }

  Future<void> pickTime(bool isPickup) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isPickup ? pickupTime : dropTime,
    );
    if (time != null) {
      setState(() {
        if (isPickup) {
          pickupTime = time;
        } else {
          dropTime = time;
        }
      });
    }
  }

  // Calculate total trips
  int calculateTotalTrips() {
    switch (frequency) {
      case "Daily":
        final days = endDate?.difference(startDate).inDays ?? (durationWeeks * 7);
        return days;
      case "Weekly":
        final weeks = ((endDate?.difference(startDate).inDays ?? (durationWeeks * 7)) / 7).ceil();
        return weeks * selectedDays.length;
      case "Monthly":
        final months = ((endDate?.difference(startDate).inDays ?? (durationWeeks * 7)) / 30).ceil();
        return months * selectedMonthlyDates.length;
      case "Weekdays":
        return _calculateWeekdayTrips();
      case "Weekends":
        return _calculateWeekendTrips();
      default:
        return 0;
    }
  }

  int _calculateWeekdayTrips() {
    int trips = 0;
    DateTime current = startDate;
    final end = endDate ?? startDate.add(Duration(days: durationWeeks * 7));
    
    while (current.isBefore(end)) {
      if (current.weekday >= 1 && current.weekday <= 5) {
        trips++;
      }
      current = current.add(const Duration(days: 1));
    }
    return trips;
  }

  int _calculateWeekendTrips() {
    int trips = 0;
    DateTime current = startDate;
    final end = endDate ?? startDate.add(Duration(days: durationWeeks * 7));
    
    while (current.isBefore(end)) {
      if (current.weekday == 6 || current.weekday == 7) {
        trips++;
      }
      current = current.add(const Duration(days: 1));
    }
    return trips;
  }

  // Calculate total price
  double calculateTotalPrice() {
    final vehicle = vehicles[vehicleType]!;
    double basePrice = vehicle["perTripRate"].toDouble();
    int totalTrips = calculateTotalTrips();
    double frequencyDiscount = frequencyOptions[frequency]!["discount"];
    
    double total = basePrice * totalTrips;
    double discounted = total * (1 - frequencyDiscount);
    
    // Additional discount for round trip
    if (roundTrip) {
      discounted *= 0.9; // 10% discount for round trip
    }
    
    // Auto-renew discount
    if (autoRenew) {
      discounted *= 0.95; // 5% discount for auto-renew
    }
    
    return discounted;
  }

  @override
  void initState() {
    super.initState();
    endDate = startDate.add(Duration(days: durationWeeks * 7));
    discount = frequencyOptions[frequency]!["discount"];
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = vehicles[vehicleType]!;
    final totalTrips = calculateTotalTrips();
    final totalPrice = calculateTotalPrice();
    final perTripPrice = vehicles[vehicleType]!["perTripRate"].toDouble();
    final discountPercentage = (discount * 100).toInt();
    final roundTripDiscount = roundTrip ? 10 : 0;
    final autoRenewDiscount = autoRenew ? 5 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recurring Booking"),
        backgroundColor: const Color(0xFF00C853),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// VEHICLE TYPE SELECTION
            const Text(
              "Select Vehicle Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: vehicles.entries.map((entry) {
                final isSelected = vehicleType == entry.key;
                final data = entry.value;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(data["icon"], size: 18, color: isSelected ? Colors.white : data["color"]),
                      const SizedBox(width: 6),
                      Text(entry.key),
                    ],
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF00C853),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  avatar: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                  onSelected: (_) => setState(() => vehicleType = entry.key),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// VEHICLE INFO CARD
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: vehicle["color"].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(vehicle["icon"], size: 30, color: vehicle["color"]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicleType,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${vehicle["capacity"]} seats • ₹${vehicle["perTripRate"]}/trip",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            children: List<Widget>.from(vehicle["features"].map((feature) {
                              return Chip(
                                label: Text(feature),
                                labelStyle: const TextStyle(fontSize: 10),
                                backgroundColor: Colors.grey.shade100,
                              );
                            })),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// FREQUENCY SELECTION
            const Text(
              "Booking Frequency",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: frequencyOptions.entries.map((entry) {
                final isSelected = frequency == entry.key;
                return ChoiceChip(
                  label: Text(entry.key),
                  selected: isSelected,
                  selectedColor: const Color(0xFF00C853),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  avatar: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                  onSelected: (_) => setState(() {
                    frequency = entry.key;
                    discount = entry.value["discount"];
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              frequencyOptions[frequency]!["description"],
              style: TextStyle(color: Colors.green.shade700, fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 20),

            /// FREQUENCY-SPECIFIC OPTIONS
            if (frequency == "Weekly") ...[
              const Text(
                "Select Days",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: days.map((day) {
                  final isSelected = selectedDays.contains(day);
                  return FilterChip(
                    label: Text(day),
                    selected: isSelected,
                    selectedColor: Colors.green.shade100,
                    checkmarkColor: Colors.green,
                    onSelected: (_) {
                      setState(() {
                        if (isSelected) {
                          selectedDays.remove(day);
                        } else {
                          selectedDays.add(day);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],

            if (frequency == "Monthly") ...[
              const Text(
                "Select Dates (Monthly)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: monthlyDates.map((date) {
                  final isSelected = selectedMonthlyDates.contains(date);
                  return FilterChip(
                    label: Text(date.toString()),
                    selected: isSelected,
                    selectedColor: Colors.green.shade100,
                    checkmarkColor: Colors.green,
                    onSelected: (_) {
                      setState(() {
                        if (isSelected) {
                          selectedMonthlyDates.remove(date);
                        } else {
                          selectedMonthlyDates.add(date);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 20),

            /// DATE RANGE
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
                      leading: const Icon(Icons.calendar_today, color: Colors.green),
                      title: const Text("Start Date"),
                      subtitle: Text(DateFormat('dd MMM yyyy, EEEE').format(startDate)),
                      trailing: const Icon(Icons.edit),
                      onTap: pickStartDate,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.calendar_month, color: Colors.orange),
                      title: const Text("End Date"),
                      subtitle: Text(
                        endDate != null
                            ? DateFormat('dd MMM yyyy, EEEE').format(endDate!)
                            : "${durationWeeks} weeks from start",
                      ),
                      trailing: const Icon(Icons.edit),
                      onTap: pickEndDate,
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Text("Duration: "),
                          Expanded(
                            child: Slider(
                              value: durationWeeks.toDouble(),
                              min: 1,
                              max: 52,
                              divisions: 51,
                              label: "$durationWeeks weeks",
                              onChanged: (value) {
                                setState(() {
                                  durationWeeks = value.toInt();
                                  endDate = startDate.add(Duration(days: durationWeeks * 7));
                                });
                              },
                            ),
                          ),
                          Text("$durationWeeks weeks"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TIME SELECTION
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
                      leading: const Icon(Icons.access_time, color: Colors.green),
                      title: const Text("Pickup Time"),
                      subtitle: Text(pickupTime.format(context)),
                      trailing: const Icon(Icons.edit),
                      onTap: () => pickTime(true),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.flag, color: Colors.red),
                      title: const Text("Drop Time"),
                      subtitle: Text(dropTime.format(context)),
                      trailing: const Icon(Icons.edit),
                      onTap: () => pickTime(false),
                    ),
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
                        setState(() => pickupLocation = value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Drop Location",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flag, color: Colors.red),
                      ),
                      items: locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => dropLocation = value!);
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: roundTrip,
                          onChanged: (value) => setState(() => roundTrip = value!),
                        ),
                        const Text("Round Trip"),
                        const Spacer(),
                        Checkbox(
                          value: autoRenew,
                          onChanged: (value) => setState(() => autoRenew = value!),
                        ),
                        const Text("Auto Renew"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// PRICE SUMMARY
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Price Summary",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPriceRow("Base Price", "₹${(perTripPrice * totalTrips).toStringAsFixed(0)}"),
                    _buildPriceRow("Frequency Discount ($frequency)", "-${discountPercentage}%"),
                    if (roundTrip)
                      _buildPriceRow("Round Trip Discount", "-${roundTripDiscount}%"),
                    if (autoRenew)
                      _buildPriceRow("Auto Renew Discount", "-${autoRenewDiscount}%"),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Price",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "₹${totalPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00C853),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "For $totalTrips trips • ₹${(totalPrice / totalTrips).toStringAsFixed(0)} per trip",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showConfirmationDialog(totalTrips, totalPrice);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  "CONFIRM RECURRING BOOKING",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showConfirmationDialog(int totalTrips, double totalPrice) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("Confirm Recurring Booking"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Your recurring booking has been set up:"),
                const SizedBox(height: 16),
                _buildDialogRow("Vehicle", vehicleType),
                _buildDialogRow("Frequency", frequency),
                _buildDialogRow("Total Trips", totalTrips.toString()),
                _buildDialogRow("Start Date", DateFormat('dd MMM yyyy').format(startDate)),
                _buildDialogRow("Pickup Time", pickupTime.format(context)),
                if (pickupLocation.isNotEmpty)
                  _buildDialogRow("From", pickupLocation),
                if (dropLocation.isNotEmpty)
                  _buildDialogRow("To", dropLocation),
                if (roundTrip) _buildDialogRow("Round Trip", "Yes"),
                if (autoRenew) _buildDialogRow("Auto Renew", "Enabled"),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Amount:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "₹${totalPrice.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00C853),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Amount will be charged monthly in advance.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
                    content: Text(
                      "✅ Recurring booking confirmed! $totalTrips trips scheduled.",
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
              ),
              child: const Text("CONFIRM & PAY"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogRow(String label, String value) {
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