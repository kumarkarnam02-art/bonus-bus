import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RouteBookingWithVehicleType extends StatefulWidget {
  const RouteBookingWithVehicleType({super.key});

  @override
  State<RouteBookingWithVehicleType> createState() =>
      _RouteBookingWithVehicleTypeState();
}

class _RouteBookingWithVehicleTypeState
    extends State<RouteBookingWithVehicleType> {
  /// -------------------- PICKUP / DROP --------------------
  final List<String> locations = ['CityA', 'CityB', 'CityC', 'CityD'];
  String? fromLocation;
  String? toLocation;

  /// -------------------- VEHICLE TYPE --------------------
  final List<String> vehicleTypes = ['Bus', 'Car'];
  String? selectedVehicleType;

  /// -------------------- DATE & TIME --------------------
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  /// -------------------- PASSENGERS --------------------
  int passengers = 2;

  /// -------------------- VEHICLES --------------------
  final List<Map<String, dynamic>> allVehicles = [
    {
      'type': 'Bus',
      'name': 'EV Mini Bus',
      'capacity': 20,
      'baseFare': 120,
      'routes': ['CityA-CityB', 'CityA-CityC', 'CityB-CityC']
    },
    {
      'type': 'Bus',
      'name': 'EV City Bus',
      'capacity': 35,
      'baseFare': 100,
      'routes': ['CityA-CityB', 'CityB-CityC']
    },
    {
      'type': 'Car',
      'name': 'EV Sedan',
      'capacity': 5,
      'baseFare': 180,
      'routes': ['CityA-CityB', 'CityB-CityC', 'CityC-CityD']
    },
    {
      'type': 'Car',
      'name': 'EV SUV',
      'capacity': 7,
      'baseFare': 220,
      'routes': ['CityA-CityC', 'CityB-CityD']
    },
  ];

  bool showVehicles = false;

  /// -------------------- OFF-PEAK RULES --------------------
  final List<OffPeakRule> offPeakRules = [
    OffPeakRule(startHour: 22, endHour: 6, discount: 0.30, enabled: true),
    OffPeakRule(startHour: 11, endHour: 16, discount: 0.25, enabled: true),
  ];

  /// -------------------- OFF-PEAK HELPERS --------------------
  OffPeakRule? detectOffPeak(TimeOfDay time) {
    for (var rule in offPeakRules) {
      if (!rule.enabled) continue;
      if (rule.startHour < rule.endHour) {
        if (time.hour >= rule.startHour && time.hour < rule.endHour) {
          return rule;
        }
      } else {
        if (time.hour >= rule.startHour || time.hour < rule.endHour) {
          return rule;
        }
      }
    }
    return null;
  }

  TimeOfDay nearestOffPeak(TimeOfDay current) {
    for (var rule in offPeakRules) {
      if (current.hour < rule.startHour) {
        return TimeOfDay(hour: rule.startHour, minute: 0);
      }
    }
    return const TimeOfDay(hour: 0, minute: 0); // next day early
  }

  double calculateFare(int baseFare, OffPeakRule? rule) {
    if (rule == null) return baseFare.toDouble();
    return baseFare * (1 - rule.discount);
  }

  /// -------------------- VEHICLE FILTER --------------------
  List<Map<String, dynamic>> filterVehicles() {
    if (fromLocation == null || toLocation == null || selectedVehicleType == null) return [];

    final fromToKey = '$fromLocation-$toLocation';
    final offPeakRule = detectOffPeak(selectedTime);

    List<Map<String, dynamic>> available = [];

    for (var v in allVehicles) {
      if (v['type'] != selectedVehicleType) continue;
      if (!v['routes'].contains(fromToKey)) continue;

      if (v['type'] == 'Bus') {
        if (v['capacity'] >= passengers) {
          final fare = calculateFare(v['baseFare'], offPeakRule) * passengers;
          available.add({...v, 'fare': fare, 'offPeakRule': offPeakRule});
        }
      } else if (v['type'] == 'Car') {
        int carsNeeded = (passengers / v['capacity']).ceil();
        final fare =
            calculateFare(v['baseFare'], offPeakRule) * v['capacity'] * carsNeeded;
        available.add({
          ...v,
          'fare': fare,
          'carsNeeded': carsNeeded,
          'offPeakRule': offPeakRule,
        });
      }
    }

    return available;
  }

  @override
  Widget build(BuildContext context) {
    final OffPeakRule? activeRule = detectOffPeak(selectedTime);
    final bool isOffPeak = activeRule != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Booking"),
        backgroundColor: const Color(0xFF00C853),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -------------------- VEHICLE TYPE SELECT
            DropdownButtonFormField<String>(
              value: selectedVehicleType,
              hint: const Text("Select Vehicle Type"),
              items: vehicleTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedVehicleType = v),
            ),

            const SizedBox(height: 10),

            /// -------------------- FROM
            DropdownButtonFormField<String>(
              value: fromLocation,
              hint: const Text("Select Pickup"),
              items: locations
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => fromLocation = v),
            ),

            const SizedBox(height: 10),

            /// -------------------- TO
            DropdownButtonFormField<String>(
              value: toLocation,
              hint: const Text("Select Drop"),
              items: locations
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => toLocation = v),
            ),

            const SizedBox(height: 10),

            /// -------------------- DATE
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDate: selectedDate,
                );
                if (d != null) setState(() => selectedDate = d);
              },
            ),

            /// -------------------- TIME
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(selectedTime.format(context)),
              onTap: () async {
                final t =
                    await showTimePicker(context: context, initialTime: selectedTime);
                if (t != null) setState(() => selectedTime = t);
              },
            ),

            /// -------------------- OFF-PEAK SUGGESTION
            if (!isOffPeak && fromLocation != null && toLocation != null)
              _buildSuggestionBanner(),

            const SizedBox(height: 10),

            /// -------------------- PASSENGERS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Passengers", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (passengers > 1) setState(() => passengers--);
                        }),
                    Text(passengers.toString(), style: const TextStyle(fontSize: 18)),
                    IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => passengers++)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// -------------------- SHOW VEHICLES
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  minimumSize: const Size(double.infinity, 50)),
              onPressed: () => setState(() => showVehicles = true),
              child: const Text("Show Available Vehicles"),
            ),

            const SizedBox(height: 16),

            if (showVehicles) _buildVehicleList(),
          ],
        ),
      ),
    );
  }

  /// -------------------- OFF-PEAK SUGGESTION
  Widget _buildSuggestionBanner() {
    final suggestedTime = nearestOffPeak(selectedTime);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("⏰ Peak Time Detected",
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
              "Switch to ${suggestedTime.format(context)} to pay less and get faster vehicles"),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => setState(() => selectedTime = suggestedTime),
            child: const Text("Switch to Off-Peak"),
          ),
        ],
      ),
    );
  }

  /// -------------------- VEHICLE LIST
  Widget _buildVehicleList() {
    final available = filterVehicles();
    if (available.isEmpty) return const Text("No vehicles available");

    return Column(
      children: available.map((v) {
        final offPeakRule = v['offPeakRule'] as OffPeakRule?;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Icon(
              v['type'] == 'Bus' ? Icons.directions_bus : Icons.directions_car,
              color: const Color(0xFF00C853),
            ),
            title: Text(v['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v['type'] == 'Car'
                    ? "Seats: ${v['capacity']} • Cars Needed: ${v['carsNeeded'] ?? 1}"
                    : "Seats: ${v['capacity']}"),
                Text(
                  "Fare: ₹${v['fare'].toInt()}" +
                      (offPeakRule != null ? " (Off-Peak Applied)" : ""),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: offPeakRule != null ? Colors.green : Colors.black),
                ),
              ],
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853)),
              onPressed: () {},
              child: const Text("Book"),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// -------------------- OFF-PEAK RULE MODEL --------------------
class OffPeakRule {
  final int startHour;
  final int endHour;
  final double discount;
  final bool enabled;

  OffPeakRule({
    required this.startHour,
    required this.endHour,
    required this.discount,
    required this.enabled,
  });
}
