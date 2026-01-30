// ChargingStationsPage.dart
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
      'diningTablesAvailable': 35,
      'totalDiningTables': 50,
      'chargingPortsAvailable': 10,
      'totalChargingPorts': 15,
      'rating': 4.7,
      'roomPrice': '₹600/hour',
      'tablePrice': '₹250/hour',
      'chargingPrice': '₹180/hour',
      'facilities': [
        'Spa',
        'Gym',
        'WiFi',
        'Pool',
        'EV Charging',
        'Bar',
        'Business Center'
      ],
      'hotels': [
        {
          'name': 'Premium Plaza Inn',
          'roomsAvailable': 12,
          'totalRooms': 30,
          'rating': 4.7,
          'price': '₹3,200/night',
          'hourlyPrice': '₹600/hour',
          'amenities': ['Spa', 'Gym', 'Pool', 'Bar', 'Conference Hall'],
          'images': ['🏩', '💆', '🏊'],
          'discount': '₹1000 off on suite booking'
        },
        {
          'name': 'Luxury Suites',
          'roomsAvailable': 25,
          'totalRooms': 35,
          'rating': 4.9,
          'price': '₹4,000/night',
          'hourlyPrice': '₹800/hour',
          'amenities': ['Butler Service', 'Jacuzzi', 'Mini Bar', 'Balcony'],
          'images': ['👑', '🛁', '🍾'],
          'discount': 'Complimentary spa treatment'
        },
        {
          'name': 'Business Hotel',
          'roomsAvailable': 18,
          'totalRooms': 25,
          'rating': 4.5,
          'price': '₹2,800/night',
          'hourlyPrice': '₹550/hour',
          'amenities': ['WiFi', 'Work Desk', 'Printer', 'Meeting Room'],
          'images': ['💼', '💻', '📊'],
          'discount': '20% off for corporate'
        },
        {
          'name': 'Comfort Stay',
          'roomsAvailable': 10,
          'totalRooms': 10,
          'rating': 4.3,
          'price': '₹2,000/night',
          'hourlyPrice': '₹400/hour',
          'amenities': ['WiFi', 'TV', 'AC', 'Room Service'],
          'images': ['🛌', '📺', '🍽️'],
          'discount': 'Early bird discount 10%'
        },
      ],
      'restaurants': [
        {
          'name': 'Multi-Cuisine Restaurant',
          'tablesAvailable': 18,
          'totalTables': 25,
          'rating': 4.6,
          'price': '₹250/hour',
          'cuisine': 'International',
          'images': ['🌍', '🍣', '🍝'],
          'timings': '11:00 AM - 11:30 PM',
          'discount': 'Lunch buffet ₹499'
        },
        {
          'name': 'Coffee Shop',
          'tablesAvailable': 12,
          'totalTables': 15,
          'rating': 4.4,
          'price': '₹150/hour',
          'cuisine': 'Cafe & Bakery',
          'images': ['☕', '🥐', '🍰'],
          'timings': '6:00 AM - 11:00 PM',
          'discount': 'Free refills on coffee'
        },
        {
          'name': 'Fine Dining',
          'tablesAvailable': 5,
          'totalTables': 10,
          'rating': 4.8,
          'price': '₹350/hour',
          'cuisine': 'French',
          'images': ['🍷', '🥂', '🍽️'],
          'timings': '7:00 PM - 11:30 PM',
          'discount': 'Wine pairing menu available'
        },
      ],
      'chargingStations': [
        {
          'type': 'Super Fast Charging',
          'portsAvailable': 4,
          'totalPorts': 6,
          'power': '250 kW',
          'time': '15-25 min',
          'price': '₹250/full charge',
          'images': ['⚡⚡', '🚗', '⚡']
        },
        {
          'type': 'Fast Charging',
          'portsAvailable': 3,
          'totalPorts': 5,
          'power': '150 kW',
          'time': '30-45 min',
          'price': '₹200/full charge',
          'images': ['⚡', '🔋', '⏱️']
        },
        {
          'type': 'Standard Charging',
          'portsAvailable': 3,
          'totalPorts': 4,
          'power': '50 kW',
          'time': '2-3 hours',
          'price': '₹150/full charge',
          'images': ['🔌', '🔋', '🕒']
        },
      ],
      'operatingHours': '24/7',
      'contact': '+91 98765 43212',
      'address': 'Indiranagar, Bengaluru 560038',
      'latitude': 12.9676,
      'longitude': 77.5896,
    },
    {
      'name': 'Electronic City Transit Hub',
      'type': 'standard',
      'distance': '2.3 km',
      'hotelsAvailable': 2,
      'totalHotels': 3,
      'roomsAvailable': 20,
      'totalRooms': 35,
      'diningTablesAvailable': 15,
      'totalDiningTables': 25,
      'chargingPortsAvailable': 4,
      'totalChargingPorts': 8,
      'rating': 3.9,
      'roomPrice': '₹300/hour',
      'tablePrice': '₹100/hour',
      'chargingPrice': '₹100/hour',
      'facilities': ['WiFi', 'AC', 'EV Charging', 'Waiting Lounge'],
      'hotels': [
        {
          'name': 'Budget Lodge',
          'roomsAvailable': 5,
          'totalRooms': 12,
          'rating': 3.9,
          'price': '₹1,200/night',
          'hourlyPrice': '₹300/hour',
          'amenities': ['WiFi', 'AC', 'TV', 'Attached Bath'],
          'images': ['🏠', '🛁', '📺'],
          'discount': '₹200 off for students'
        },
        {
          'name': 'Tech Park Hotel',
          'roomsAvailable': 15,
          'totalRooms': 23,
          'rating': 4.1,
          'price': '₹2,000/night',
          'hourlyPrice': '₹400/hour',
          'amenities': ['WiFi', 'Work Desk', 'Parking', 'Laundry'],
          'images': ['🏨', '💻', '🚗'],
          'discount': 'Corporate rates available'
        },
      ],
      'restaurants': [
        {
          'name': 'Food Court',
          'tablesAvailable': 10,
          'totalTables': 15,
          'rating': 3.8,
          'price': '₹100/hour',
          'cuisine': 'Multi-cuisine',
          'images': ['🍜', '🍚', '🍛'],
          'timings': '8:00 AM - 10:30 PM',
          'discount': 'Combo meal ₹149'
        },
        {
          'name': 'Snack Bar',
          'tablesAvailable': 5,
          'totalTables': 10,
          'rating': 3.7,
          'price': '₹80/hour',
          'cuisine': 'Snacks & Beverages',
          'images': ['🥪', '🍩', '🥤'],
          'timings': '7:00 AM - 10:00 PM',
          'discount': 'Buy 2 get 1 free'
        },
      ],
      'chargingStations': [
        {
          'type': 'Standard Charging',
          'portsAvailable': 4,
          'totalPorts': 8,
          'power': '50 kW',
          'time': '2-3 hours',
          'price': '₹100/full charge',
          'images': ['🔌', '🔋', '🕐']
        },
      ],
      'operatingHours': '6:00 AM - 12:00 AM',
      'contact': '+91 98765 43213',
      'address': 'Electronic City, Bengaluru 560100',
      'latitude': 12.9796,
      'longitude': 77.6096,
    },
    {
      'name': 'Jayanagar Premium Terminal',
      'type': 'premium',
      'distance': '3.2 km',
      'hotelsAvailable': 3,
      'totalHotels': 4,
      'roomsAvailable': 45,
      'totalRooms': 70,
      'diningTablesAvailable': 30,
      'totalDiningTables': 45,
      'chargingPortsAvailable': 8,
      'totalChargingPorts': 12,
      'rating': 4.6,
      'roomPrice': '₹550/hour',
      'tablePrice': '₹220/hour',
      'chargingPrice': '₹160/hour',
      'facilities': [
        'WiFi',
        'AC',
        'Restaurant',
        'EV Charging',
        'Lounge',
        'Kids Zone'
      ],
      'hotels': [
        {
          'name': 'Heritage Hotel',
          'roomsAvailable': 20,
          'totalRooms': 35,
          'rating': 4.6,
          'price': '₹2,800/night',
          'hourlyPrice': '₹550/hour',
          'amenities': ['WiFi', 'Pool', 'Garden', 'Restaurant', 'Spa'],
          'images': ['🏛️', '🌳', '🏊'],
          'discount': 'Heritage tour included'
        },
        {
          'name': 'Modern Suites',
          'roomsAvailable': 15,
          'totalRooms': 25,
          'rating': 4.5,
          'price': '₹2,500/night',
          'hourlyPrice': '₹500/hour',
          'amenities': ['Smart TV', 'Kitchenette', 'WiFi', 'Gym'],
          'images': ['🏢', '📱', '🏋️'],
          'discount': 'Monthly packages available'
        },
      ],
      'restaurants': [
        {
          'name': 'Traditional Restaurant',
          'tablesAvailable': 20,
          'totalTables': 30,
          'rating': 4.5,
          'price': '₹220/hour',
          'cuisine': 'South Indian',
          'images': ['🍛', '🥥', '🌶️'],
          'timings': '7:00 AM - 11:00 PM',
          'discount': 'Family meal ₹999'
        },
        {
          'name': 'Modern Cafe',
          'tablesAvailable': 10,
          'totalTables': 15,
          'rating': 4.3,
          'price': '₹180/hour',
          'cuisine': 'Continental',
          'images': ['☕', '🥗', '🍰'],
          'timings': '8:00 AM - 11:00 PM',
          'discount': 'Happy hour 4-7 PM'
        },
      ],
      'chargingStations': [
        {
          'type': 'Fast Charging',
          'portsAvailable': 4,
          'totalPorts': 6,
          'power': '150 kW',
          'time': '30-45 min',
          'price': '₹160/full charge',
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
      'operatingHours': '24/7',
      'contact': '+91 98765 43214',
      'address': 'Jayanagar, Bengaluru 560041',
      'latitude': 12.9656,
      'longitude': 77.5796,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredStations = _filterStations();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Charging Stations & Facilities",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF00C853),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showMapView ? Icons.list : Icons.map,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showMapView = !_showMapView;
              });
            },
            tooltip: _showMapView ? 'List View' : 'Map View',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryTab('🚉 All Facilities', 0),
                  _buildCategoryTab('🏨 Hotels', 1),
                  _buildCategoryTab('🍽️ Dining', 2),
                  _buildCategoryTab('🛏️ Rooms', 3),
                  _buildCategoryTab('⚡ Charging', 4),
                ],
              ),
            ),
          ),

          // Stats Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.grey.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '${filteredStations.length}',
                  'Stations',
                  Colors.blue,
                ),
                _buildStatItem(
                  '${_getTotalAvailableRooms(filteredStations)}',
                  'Rooms',
                  Colors.green,
                ),
                _buildStatItem(
                  '${_getTotalAvailableTables(filteredStations)}',
                  'Tables',
                  Colors.red,
                ),
                _buildStatItem(
                  '${_getTotalAvailableChargingPorts(filteredStations)}',
                  'Ports',
                  Colors.orange,
                ),
              ],
            ),
          ),

          Expanded(
            child: _showMapView
                ? _buildMapView(filteredStations)
                : _buildListView(filteredStations),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedCategory == index
              ? const Color(0xFF00C853)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedCategory == index ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> stations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return _buildStationCard(station);
      },
    );
  }

  Widget _buildStationCard(Map<String, dynamic> station) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showStationDetails(station);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: station['type'] == 'premium'
                          ? Colors.amber.shade100
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        station['type'] == 'premium' ? '⭐' : '🚉',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                station['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (station['type'] == 'premium')
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'PREMIUM',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              station['distance'],
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.star, size: 12, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              "${station['rating']}",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Facilities Quick View
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFacilityChip(
                      Icons.hotel,
                      '${station['hotelsAvailable']} Hotels',
                      station['hotelsAvailable'] > 0
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    _buildFacilityChip(
                      Icons.king_bed,
                      '${station['roomsAvailable']} Rooms',
                      station['roomsAvailable'] > 0
                          ? Colors.green
                          : Colors.grey,
                    ),
                    _buildFacilityChip(
                      Icons.restaurant,
                      '${station['diningTablesAvailable']} Tables',
                      station['diningTablesAvailable'] > 0
                          ? Colors.red
                          : Colors.grey,
                    ),
                    _buildFacilityChip(
                      Icons.ev_station,
                      '${station['chargingPortsAvailable']} Ports',
                      station['chargingPortsAvailable'] > 0
                          ? Colors.orange
                          : Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Pricing Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPriceItem('🛏️ Room', station['roomPrice']),
                  _buildPriceItem('🍽️ Table', station['tablePrice']),
                  _buildPriceItem('⚡ Charging', station['chargingPrice']),
                ],
              ),
              const SizedBox(height: 12),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showDirections(station);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.directions, size: 16),
                      label: const Text('Directions'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showBookingOptions(station);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.book_online, size: 16),
                      label: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFacilityChip(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceItem(String label, String price) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          price,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildMapView(List<Map<String, dynamic>> stations) {
    // For now, show a placeholder map view
    // In real app, you would integrate Google Maps here
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Map View Coming Soon',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showMapView = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
            ),
            child: const Text('Switch to List View'),
          ),
        ],
      ),
    );
  }

  void _showStationDetails(Map<String, dynamic> station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
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

                // Station Header
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: station['type'] == 'premium'
                            ? Colors.amber.shade100
                            : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          station['type'] == 'premium' ? '⭐' : '🚉',
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(station['address']),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Station Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDetailItem(
                                '🏨 Hotels', '${station['hotelsAvailable']}'),
                            _buildDetailItem(
                                '🛏️ Rooms', '${station['roomsAvailable']}'),
                            _buildDetailItem('🍽️ Tables',
                                '${station['diningTablesAvailable']}'),
                            _buildDetailItem('⚡ Ports',
                                '${station['chargingPortsAvailable']}'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDetailItem('⏰ Hours', station['operatingHours']),
                            _buildDetailItem('📞 Contact', station['contact']),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Available Hotels Section
                if (station['hotels'] != null &&
                    (station['hotels'] as List).isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🏨 Available Hotels",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(station['hotels'] as List<dynamic>).map((hotel) {
                        return _buildHotelCard(hotel, station['name']);
                      }),
                    ],
                  ),

                const SizedBox(height: 16),

                // Available Restaurants Section
                if (station['restaurants'] != null &&
                    (station['restaurants'] as List).isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🍽️ Dining Options",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(station['restaurants'] as List<dynamic>).map((restaurant) {
                        return _buildRestaurantCard(restaurant, station['name']);
                      }),
                    ],
                  ),

                const SizedBox(height: 16),

                // Charging Stations Section
                if (station['chargingStations'] != null &&
                    (station['chargingStations'] as List).isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "⚡ Charging Stations",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(station['chargingStations'] as List<dynamic>).map((charging) {
                        return _buildChargingStationCard(charging, station['name']);
                      }),
                    ],
                  ),

                const SizedBox(height: 16),

                // Facilities
                const Text(
                  "🏆 Facilities",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (station['facilities'] as List<dynamic>)
                      .map<Widget>((facility) {
                    return Chip(
                      label: Text(
                        facility.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.green.shade50,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel, String stationName) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  hotel['images'] != null && hotel['images'].isNotEmpty
                      ? hotel['images'][0]
                      : '🏨',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.king_bed, size: 12, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        "${hotel['roomsAvailable']}/${hotel['totalRooms']} rooms",
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        "${hotel['rating']}",
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hotel['hourlyPrice'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                  if (hotel['discount'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        hotel['discount'],
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _bookHotelRoom(hotel, stationName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(70, 32),
                  ),
                  child: const Text(
                    "Book",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hotel['price'],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(
      Map<String, dynamic> restaurant, String stationName) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  restaurant['images'] != null && restaurant['images'].isNotEmpty
                      ? restaurant['images'][0]
                      : '🍽️',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.restaurant, size: 12, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        "${restaurant['tablesAvailable']}/${restaurant['totalTables']} tables",
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        "${restaurant['rating']}",
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant['cuisine'] ?? 'Multi-cuisine',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  if (restaurant['timings'] != null)
                    Text(
                      restaurant['timings'],
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                    ),
                  if (restaurant['discount'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        restaurant['discount'],
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _bookRestaurantTable(restaurant, stationName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(70, 32),
                  ),
                  child: const Text(
                    "Book",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  restaurant['price'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChargingStationCard(
      Map<String, dynamic> charging, String stationName) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  charging['images'] != null && charging['images'].isNotEmpty
                      ? charging['images'][0]
                      : '⚡',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    charging['type'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.ev_station, size: 12, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        "${charging['portsAvailable']}/${charging['totalPorts']} ports",
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.bolt, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        charging['power'],
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Charge time: ${charging['time']}",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _bookChargingPort(charging, stationName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(70, 32),
                  ),
                  child: const Text(
                    "Book",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  charging['price'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter & Sort"),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                const Text(
                  "Sort By",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            const SizedBox(height: 8),
                ...['distance', 'rating', 'price_low', 'price_high'].map((sort) {
                  return ListTile(
                    title: Text(_getSortText(sort)),
                    leading: Icon(
                      _selectedSort == sort ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: _selectedSort == sort ? Colors.blue : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedSort = sort;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
                const SizedBox(height: 16),
                const Text(
                  "Filter by Type",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Premium'),
                      selected: _selectedCategory == 0,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? 0 : 0;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    FilterChip(
                      label: const Text('Standard'),
                      selected: _selectedCategory == 1,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? 1 : 0;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedSort = 'distance';
                  _selectedCategory = 0;
                });
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
              ),
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  String _getSortText(String sort) {
    switch (sort) {
      case 'distance':
        return 'Nearest First';
      case 'rating':
        return 'Highest Rated';
      case 'price_low':
        return 'Price: Low to High';
      case 'price_high':
        return 'Price: High to Low';
      default:
        return 'Nearest First';
    }
  }

  List<Map<String, dynamic>> _filterStations() {
    List<Map<String, dynamic>> filtered = List.from(allStations);

    // Filter by category
    if (_selectedCategory == 1) {
      filtered = filtered
          .where((station) => station['hotelsAvailable'] > 0)
          .toList();
    } else if (_selectedCategory == 2) {
      filtered = filtered
          .where((station) => station['diningTablesAvailable'] > 0)
          .toList();
    } else if (_selectedCategory == 3) {
      filtered = filtered
          .where((station) => station['roomsAvailable'] > 0)
          .toList();
    } else if (_selectedCategory == 4) {
      filtered = filtered
          .where((station) => station['chargingPortsAvailable'] > 0)
          .toList();
    }

    // Sort
    filtered.sort((a, b) {
      switch (_selectedSort) {
        case 'distance':
          final distA = double.parse(a['distance'].split(' ')[0]);
          final distB = double.parse(b['distance'].split(' ')[0]);
          return distA.compareTo(distB);
        case 'rating':
          return b['rating'].compareTo(a['rating']);
        case 'price_low':
          final priceA = double.parse(
              a['roomPrice'].replaceAll('₹', '').replaceAll('/hour', ''));
          final priceB = double.parse(
              b['roomPrice'].replaceAll('₹', '').replaceAll('/hour', ''));
          return priceA.compareTo(priceB);
        case 'price_high':
          final priceA = double.parse(
              a['roomPrice'].replaceAll('₹', '').replaceAll('/hour', ''));
          final priceB = double.parse(
              b['roomPrice'].replaceAll('₹', '').replaceAll('/hour', ''));
          return priceB.compareTo(priceA);
        default:
          return 0;
      }
    });

    return filtered;
  }

  int _getTotalAvailableRooms(List<Map<String, dynamic>> stations) {
  int total = 0;
  for (var station in stations) {
    total += station['roomsAvailable'] as int;
  }
  return total;
}

int _getTotalAvailableTables(List<Map<String, dynamic>> stations) {
  int total = 0;
  for (var station in stations) {
    total += station['diningTablesAvailable'] as int;
  }
  return total;
}

int _getTotalAvailableChargingPorts(List<Map<String, dynamic>> stations) {
  int total = 0;
  for (var station in stations) {
    total += station['chargingPortsAvailable'] as int;
  }
  return total;
}

  void _showDirections(Map<String, dynamic> station) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Directions to ${station['name']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address: ${station['address']}"),
            const SizedBox(height: 8),
            Text("Distance: ${station['distance']}"),
            const SizedBox(height: 8),
            Text("Contact: ${station['contact']}"),
            const SizedBox(height: 16),
            const Text("Open in:"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open in Maps
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
            ),
            child: const Text("Open Maps"),
          ),
        ],
      ),
    );
  }

  void _showBookingOptions(Map<String, dynamic> station) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Book at ${"station['name']"}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.hotel, color: Colors.blue),
                title: const Text("Book Hotel Room"),
                subtitle: Text("${station['roomsAvailable']} rooms available"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  if (station['hotels'] != null &&
                      station['hotels'].isNotEmpty) {
                    _bookHotelRoom(station['hotels'][0], station['name']);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.restaurant, color: Colors.red),
                title: const Text("Book Dining Table"),
                subtitle:
                    Text("${station['diningTablesAvailable']} tables available"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  if (station['restaurants'] != null &&
                      station['restaurants'].isNotEmpty) {
                    _bookRestaurantTable(
                        station['restaurants'][0], station['name']);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.ev_station, color: Colors.orange),
                title: const Text("Book Charging Port"),
                subtitle: Text(
                    "${station['chargingPortsAvailable']} ports available"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  if (station['chargingStations'] != null &&
                      station['chargingStations'].isNotEmpty) {
                    _bookChargingPort(
                        station['chargingStations'][0], station['name']);
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _bookHotelRoom(Map<String, dynamic> hotel, String stationName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Book ${hotel['name']}"),
        content: SizedBox(
          height: 400,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Station: $stationName"),
              const SizedBox(height: 12),
              Text("Hourly Rate: ${hotel['hourlyPrice']}"),
              Text("Nightly Rate: ${hotel['price']}"),
              const SizedBox(height: 12),
              const Text("Select check-in time:"),
              const SizedBox(height: 8),
              // Time selection UI would go here
              const SizedBox(height: 12),
              const Text("Select duration:"),
              const SizedBox(height: 8),
              // Duration selection UI would go here
              const SizedBox(height: 12),
              const Text("Number of rooms:"),
              const SizedBox(height: 8),
              // Room count UI would go here
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showBookingConfirmation(
                  "Hotel Room at ${hotel['name']}", hotel['hourlyPrice']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text("Confirm Booking"),
          ),
        ],
      ),
    );
  }

  void _bookRestaurantTable(
      Map<String, dynamic> restaurant, String stationName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Book ${restaurant['name']}"),
        content: SizedBox(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Station: $stationName"),
              const SizedBox(height: 12),
              Text("Rate: ${restaurant['price']}"),
              const SizedBox(height: 12),
              const Text("Select dining time:"),
              const SizedBox(height: 8),
              // Time selection UI would go here
              const SizedBox(height: 12),
              const Text("Number of guests:"),
              const SizedBox(height: 8),
              // Guest count UI would go here
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showBookingConfirmation(
                  "Table at ${restaurant['name']}", restaurant['price']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Confirm Booking"),
          ),
        ],
      ),
    );
  }

  void _bookChargingPort(Map<String, dynamic> charging, String stationName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Book ${charging['type']} Port"),
        content: SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Station: $stationName"),
              const SizedBox(height: 12),
              Text("Power: ${charging['power']}"),
              Text("Time: ${charging['time']}"),
              Text("Price: ${charging['price']}"),
              const SizedBox(height: 12),
              const Text("Select charging start time:"),
              const SizedBox(height: 8),
              // Time selection UI would go here
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showBookingConfirmation(
                  "${charging['type']} Port", charging['price']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text("Confirm Booking"),
          ),
        ],
      ),
    );
  }

  void _showBookingConfirmation(String service, String price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Booking Confirmed!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text("Service: $service"),
            const SizedBox(height: 8),
            Text("Amount: $price"),
            const SizedBox(height: 8),
           // Change from const to normal Text widget
Text("Booking ID: BKG${DateTime.now().millisecondsSinceEpoch}"),
            const SizedBox(height: 8),
            const Text("You will receive confirmation SMS shortly."),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Booking confirmed successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
            ),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }
}