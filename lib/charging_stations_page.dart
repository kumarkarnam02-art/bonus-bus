// charging_stations_page.dart
import 'package:flutter/material.dart';

class ChargingStationsPage extends StatefulWidget {
  const ChargingStationsPage({super.key});

  @override
  State<ChargingStationsPage> createState() => _ChargingStationsPageState();
}

class _ChargingStationsPageState extends State<ChargingStationsPage> {
  int _selectedCategory = 0; // 0: All, 1: Hotels, 2: Dining, 3: Rooms
  String _selectedSort = 'distance';
  bool _showMapView = false;

  // Complete station data with hotels, rooms, dining, and charging
  final List<Map<String, dynamic>> allStations = [
    {
      'name': 'MG Road Station Complex',
      'type': 'premium',
      'distance': '0.5 km',
      'hotelsAvailable': 3,
      'totalHotels': 5,
      'roomsAvailable': 42,
      'totalRooms': 80,
      'diningTablesAvailable': 25,
      'totalDiningTables': 40,
      'chargingPortsAvailable': 8,
      'totalChargingPorts': 12,
      'rating': 4.5,
      'roomPrice': '₹500/hour',
      'tablePrice': '₹200/hour',
      'chargingPrice': '₹150/hour',
      'facilities': [
        'WiFi',
        'AC',
        'Restaurant',
        'EV Charging',
        'Lounge',
        '24/7 Service'
      ],
      'hotels': [
        {
          'name': 'Green Valley Resort',
          'roomsAvailable': 8,
          'totalRooms': 20,
          'rating': 4.5,
          'price': '₹2,500/night',
          'hourlyPrice': '₹500/hour',
          'amenities': ['WiFi', 'Pool', 'Spa', 'Gym', 'Restaurant'],
          'images': ['🏨', '🛏️', '🏊'],
          'discount': '20% off on 4+ hours'
        },
        {
          'name': 'MG Road Inn',
          'roomsAvailable': 12,
          'totalRooms': 25,
          'rating': 4.2,
          'price': '₹2,000/night',
          'hourlyPrice': '₹400/hour',
          'amenities': ['WiFi', 'Restaurant', 'Laundry', 'Parking'],
          'images': ['🏨', '🍽️', '🚗'],
          'discount': '15% off first booking'
        },
        {
          'name': 'City Center Hotel',
          'roomsAvailable': 22,
          'totalRooms': 35,
          'rating': 4.7,
          'price': '₹3,000/night',
          'hourlyPrice': '₹600/hour',
          'amenities': ['WiFi', 'Pool', 'Bar', 'Conference', 'Spa'],
          'images': ['🏨', '💼', '🍷'],
          'discount': 'Free breakfast included'
        },
      ],
      'restaurants': [
        {
          'name': 'Food Court',
          'tablesAvailable': 15,
          'totalTables': 25,
          'rating': 4.3,
          'price': '₹200/hour',
          'cuisine': 'Multi-cuisine',
          'images': ['🍽️', '🍔', '🍕'],
          'timings': '7:00 AM - 11:00 PM',
          'discount': '10% off for hotel guests'
        },
        {
          'name': 'Fine Dining Restaurant',
          'tablesAvailable': 10,
          'totalTables': 15,
          'rating': 4.8,
          'price': '₹300/hour',
          'cuisine': 'Continental',
          'images': ['🍷', '🥩', '🍰'],
          'timings': '12:00 PM - 11:30 PM',
          'discount': '15% off before 7 PM'
        },
        {
          'name': 'Quick Snack Bar',
          'tablesAvailable': 8,
          'totalTables': 12,
          'rating': 4.0,
          'price': '₹150/hour',
          'cuisine': 'Fast Food',
          'images': ['☕', '🥪', '🍩'],
          'timings': '6:00 AM - 10:00 PM',
          'discount': 'Combo meal ₹299'
        },
      ],
      'chargingStations': [
        {
          'type': 'Fast Charging',
          'portsAvailable': 4,
          'totalPorts': 6,
          'power': '150 kW',
          'time': '30-45 min',
          'price': '₹200/full charge',
          'images': ['⚡', '🔋', '🚗']
        },
        {
          'type': 'Standard Charging',
          'portsAvailable': 4,
          'totalPorts': 6,
          'power': '50 kW',
          'time': '2-3 hours',
          'price': '₹150/full charge',
          'images': ['🔌', '🔋', '⏱️']
        },
      ],
      'operatingHours': '24/7',
      'contact': '+91 98765 43210',
      'address': 'MG Road, Bengaluru 560001',
      'latitude': 12.9716,
      'longitude': 77.5946,
    },
    {
      'name': 'Koramangala Integrated Terminal',
      'type': 'standard',
      'distance': '1.1 km',
      'hotelsAvailable': 2,
      'totalHotels': 4,
      'roomsAvailable': 28,
      'totalRooms': 50,
      'diningTablesAvailable': 18,
      'totalDiningTables': 30,
      'chargingPortsAvailable': 6,
      'totalChargingPorts': 10,
      'rating': 4.2,
      'roomPrice': '₹400/hour',
      'tablePrice': '₹150/hour',
      'chargingPrice': '₹120/hour',
      'facilities': ['WiFi', 'Restaurant', 'Parking', 'EV Charging', 'ATM'],
      'hotels': [
        {
          'name': 'Urban Stay Hotel',
          'roomsAvailable': 3,
          'totalRooms': 15,
          'rating': 4.2,
          'price': '₹1,800/night',
          'hourlyPrice': '₹400/hour',
          'amenities': ['WiFi', 'TV', 'AC', '24/7 Room Service'],
          'images': ['🏢', '📺', '❄️'],
          'discount': '₹500 off on first booking'
        },
        {
          'name': 'Koramangala Suites',
          'roomsAvailable': 25,
          'totalRooms': 35,
          'rating': 4.4,
          'price': '₹2,200/night',
          'hourlyPrice': '₹450/hour',
          'amenities': ['WiFi', 'Kitchenette', 'Laundry', 'Gym'],
          'images': ['🏠', '🍳', '🏋️'],
          'discount': 'Long stay discount available'
        },
      ],
      'restaurants': [
        {
          'name': 'Station Diner',
          'tablesAvailable': 8,
          'totalTables': 15,
          'rating': 4.1,
          'price': '₹150/hour',
          'cuisine': 'North Indian',
          'images': ['🍛', '🍴', '🥘'],
          'timings': '8:00 AM - 11:00 PM',
          'discount': 'Thali ₹199'
        },
        {
          'name': 'Quick Bite Cafe',
          'tablesAvailable': 10,
          'totalTables': 15,
          'rating': 3.9,
          'price': '₹100/hour',
          'cuisine': 'Cafe & Snacks',
          'images': ['☕', '🍰', '🥗'],
          'timings': '6:30 AM - 10:30 PM',
          'discount': 'Buy 1 Get 1 on coffee'
        },
      ],
      'chargingStations': [
        {
          'type': 'Fast Charging',
          'portsAvailable': 2,
          'totalPorts': 4,
          'power': '120 kW',
          'time': '40-60 min',
          'price': '₹180/full charge',
          'images': ['⚡', '🚙', '🔋']
        },
        {
          'type': 'Standard Charging',
          'portsAvailable': 4,
          'totalPorts': 6,
          'power': '50 kW',
          'time': '2-3 hours',
          'price': '₹120/full charge',
          'images': ['🔌', '🔋', '⏳']
        },
      ],
      'operatingHours': '5:00 AM - 1:00 AM',
      'contact': '+91 98765 43211',
      'address': 'Koramangala, Bengaluru 560034',
      'latitude': 12.9756,
      'longitude': 77.5996,
    },
    {
      'name': 'Indiranagar Luxury Terminal',
      'type': 'premium',
      'distance': '1.8 km',
      'hotelsAvailable': 4,
      'totalHotels': 6,
      'roomsAvailable': 65,
      'totalRooms': 100,
      'totalDiningTables': 50,
      'rating': 4.7,
      'roomPrice': '₹600/hour',
      'tablePrice': '₹250/hour',
      'chargingPrice': '₹180/hour',
      'facilities': [
        'WiFi',
        'AC',
        'Restaurant',
        'EV Charging',
        'Lounge',
        '24/7 Service',
        'Spa',
        'Gym',
        'Pool',
        'Bar'
      ],
      'hotels': [
        {
          'name': 'Luxury Plaza Hotel',
          'roomsAvailable': 15,
          'totalRooms': 30,
          'rating': 4.8,
          'price': '₹3,500/night',
          'hourlyPrice': '₹600/hour',
          'amenities': ['WiFi', 'Pool', 'Spa', 'Gym', 'Restaurant', 'Bar'],
          'images': ['🏨', '🛏️', '🏊', '💼'],
          'discount': '25% off on weekends'
        },
        {
          'name': 'Indiranagar Grand',
          'roomsAvailable': 20,
          'totalRooms': 35,
          'rating': 4.6,
          'price': '₹2,800/night',
          'hourlyPrice': '₹550/hour',
          'amenities': ['WiFi', 'Restaurant', 'Laundry', 'Parking', 'Conference'],
          'images': ['🏨', '🍽️', '🚗', '💼'],
          'discount': 'Free breakfast included'
        },
        {
          'name': 'Business Suites',
          'roomsAvailable': 18,
          'totalRooms': 25,
          'rating': 4.5,
          'price': '₹2,500/night',
          'hourlyPrice': '₹500/hour',
          'amenities': ['WiFi', 'Kitchenette', 'Laundry', 'Gym'],
          'images': ['🏠', '🍳', '🏋️'],
          'discount': 'Long stay discount'
        },
        {
          'name': 'Comfort Inn',
          'roomsAvailable': 12,
          'totalRooms': 10,
          'rating': 4.3,
          'price': '₹2,000/night',
          'hourlyPrice': '₹400/hour',
          'amenities': ['WiFi', 'AC', 'TV', '24/7 Service'],
          'images': ['🏨', '📺', '❄️'],
          'discount': '₹300 off first booking'
        },
      ],
      'restaurants': [
        {
          'name': 'Fine Dining Lounge',
          'tablesAvailable': 20,
          'totalTables': 25,
          'rating': 4.8,
          'price': '₹300/hour',
          'cuisine': 'Continental',
          'images': ['🍷', '🥩', '🍰'],
          'timings': '12:00 PM - 11:30 PM',
          'discount': '20% off before 8 PM'
        },
        {
          'name': 'Multi-Cuisine Restaurant',
          'tablesAvailable': 10,
          'totalTables': 15,
          'rating': 4.6,
          'price': '₹250/hour',
          'cuisine': 'Indian & Chinese',
          'images': ['🍛', '🍜', '🥘'],
          'timings': '11:00 AM - 11:00 PM',
          'discount': '15% off for hotel guests'
        },
        {
          'name': 'Cafe Corner',
          'tablesAvailable': 5,
          'totalTables': 10,
          'rating': 4.4,
          'price': '₹150/hour',
          'cuisine': 'Cafe & Snacks',
          'images': ['☕', '🍰', '🥪'],
          'timings': '7:00 AM - 10:00 PM',
          'discount': 'Buy 1 Get 1 coffee'
        },
      ],
      'chargingStations': [
        {
          'type': 'Ultra Fast Charging',
          'portsAvailable': 6,
          'totalPorts': 8,
          'power': '200 kW',
          'time': '20-30 min',
          'price': '₹250/full charge',
          'images': ['⚡', '🔋', '🚗']
        },
        {
          'type': 'Fast Charging',
          'portsAvailable': 4,
          'totalPorts': 6,
          'power': '150 kW',
          'time': '30-45 min',
          'price': '₹200/full charge',
          'images': ['⚡', '🔋', '🚙']
        },
      ],
      'operatingHours': '24/7',
      'contact': '+91 98765 43212',
      'address': 'Indiranagar, Bengaluru 560038',
      'latitude': 12.9676,
      'longitude': 77.5896,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredStations = allStations;

    // Filter by category
    if (_selectedCategory == 1) { // Hotels
      filteredStations = allStations.where((station) => station['hotelsAvailable'] > 0).toList();
    } else if (_selectedCategory == 2) { // Dining
      filteredStations = allStations.where((station) => station['diningTablesAvailable'] > 0).toList();
    } else if (_selectedCategory == 3) { // Rooms
      filteredStations = allStations.where((station) => station['roomsAvailable'] > 0).toList();
    }

    // Sort
    if (_selectedSort == 'rating') {
      filteredStations.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    } else if (_selectedSort == 'distance') {
      filteredStations.sort((a, b) => (a['distance'] as String).compareTo(b['distance'] as String));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charging Stations'),
        backgroundColor: const Color(0xFF00C853),
        actions: [
          IconButton(
            icon: Icon(_showMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _showMapView = !_showMapView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                const Text('Filter: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedCategory == 0,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = 0;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Hotels'),
                  selected: _selectedCategory == 1,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = 1;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Dining'),
                  selected: _selectedCategory == 2,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = 2;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Rooms'),
                  selected: _selectedCategory == 3,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = 3;
                    });
                  },
                ),
              ],
            ),
          ),
          // Sort
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                const Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Distance'),
                  selected: _selectedSort == 'distance',
                  onSelected: (selected) {
                    setState(() {
                      _selectedSort = 'distance';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Rating'),
                  selected: _selectedSort == 'rating',
                  onSelected: (selected) {
                    setState(() {
                      _selectedSort = 'rating';
                    });
                  },
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _showMapView ? _buildMapView(filteredStations) : _buildListView(filteredStations),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> stations) {
    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(station['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Distance: ${station['distance']}'),
                Text('Rating: ${station['rating']}'),
                const SizedBox(height: 8),
                Text('Hotels: ${station['hotelsAvailable']}/${station['totalHotels']}'),
                Text('Rooms: ${station['roomsAvailable']}/${station['totalRooms']}'),
                Text('Dining: ${station['diningTablesAvailable']}/${station['totalDiningTables']}'),
                Text('Charging: ${station['chargingPortsAvailable']}/${station['totalChargingPorts']}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _showStationDetails(station);
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapView(List<Map<String, dynamic>> stations) {
    return const Center(child: Text('Map View - To be implemented'));
  }

  void _showStationDetails(Map<String, dynamic> station) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(station['name']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Address: ${station['address']}'),
              Text('Contact: ${station['contact']}'),
              Text('Operating Hours: ${station['operatingHours']}'),
              const SizedBox(height: 8),
              const Text('Facilities:', style: TextStyle(fontWeight: FontWeight.bold)),
              ... (station['facilities'] as List).map((f) => Text('- $f')),
              const SizedBox(height: 8),
              const Text('Hotels:', style: TextStyle(fontWeight: FontWeight.bold)),
              ... (station['hotels'] as List).map((h) => Text('- ${h['name']}: ${h['roomsAvailable']}/${h['totalRooms']} rooms')),
              const SizedBox(height: 8),
              const Text('Restaurants:', style: TextStyle(fontWeight: FontWeight.bold)),
              ... (station['restaurants'] as List).map((r) => Text('- ${r['name']}: ${r['tablesAvailable']}/${r['totalTables']} tables')),
              const SizedBox(height: 8),
              const Text('Charging Stations:', style: TextStyle(fontWeight: FontWeight.bold)),
              ... (station['chargingStations'] as List).map((c) => Text('- ${c['type']}: ${c['portsAvailable']}/${c['totalPorts']} ports')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
