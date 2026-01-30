import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './recurring_booking_page.dart';
import './group_booking_page.dart';
import './emergency.dart';
import './bus_splitpage.dart';
import './ChargingStationsPage.dart';
import './wallet_page.dart';
import './charging_status_page.dart';
import './off_peak_booking_page.dart';
import './profile_page.dart';
import './trip_details_page.dart';
import './login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './templepage.dart';
import './route.dart';

class HomePage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const HomePage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double batteryPercentage = 78.0;
  double walletBalance = 1245.50;
  int _currentIndex = 1;
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  LatLng? _destinationLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _showBusSplitOptions = false;

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Account',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.directions_bus_outlined),
      activeIcon: Icon(Icons.directions_bus),
      label: 'Trips',
    ),
  ];

  // Station data with hotel rooms and food options
  List<Map<String, dynamic>> nearbyStations = [
    {
      'name': 'MG Road Station',
      'type': 'station_complex',
      'distance': '0.5 km',
      'hotelsAvailable': 3,
      'totalHotels': 5,
      'roomsAvailable': 42,
      'totalRooms': 80,
      'diningTablesAvailable': 25,
      'totalDiningTables': 40,
      'rating': 4.5,
      'roomPrice': '₹500/hour',
      'tablePrice': '₹200/hour',
      'chargingPrice': '₹150/hour',
      'facilities': ['WiFi', 'AC', 'Restaurant', 'EV Charging', 'Lounge'],
      'latitude': 12.9716,
      'longitude': 77.5946,
      'hotels': [
        {
          'name': 'Green Valley Resort',
          'roomsAvailable': 8,
          'totalRooms': 20,
          'rating': 4.5,
          'price': '₹2,500/night',
          'hourlyPrice': '₹500/hour',
        },
        {
          'name': 'MG Road Inn',
          'roomsAvailable': 12,
          'totalRooms': 25,
          'rating': 4.2,
          'price': '₹2,000/night',
          'hourlyPrice': '₹400/hour',
        },
        {
          'name': 'City Center Hotel',
          'roomsAvailable': 22,
          'totalRooms': 35,
          'rating': 4.7,
          'price': '₹3,000/night',
          'hourlyPrice': '₹600/hour',
        },
      ],
      'restaurants': [
        {
          'name': 'Food Court',
          'tablesAvailable': 15,
          'totalTables': 25,
          'rating': 4.3,
          'price': '₹200/hour',
        },
        {
          'name': 'Fine Dining Restaurant',
          'tablesAvailable': 10,
          'totalTables': 15,
          'rating': 4.8,
          'price': '₹300/hour',
        },
      ],
    },
    {
      'name': 'Koramangala Station',
      'type': 'station_complex',
      'distance': '1.1 km',
      'hotelsAvailable': 2,
      'totalHotels': 4,
      'roomsAvailable': 28,
      'totalRooms': 50,
      'diningTablesAvailable': 18,
      'totalDiningTables': 30,
      'rating': 4.2,
      'roomPrice': '₹400/hour',
      'tablePrice': '₹150/hour',
      'chargingPrice': '₹120/hour',
      'facilities': ['WiFi', 'Restaurant', 'Parking', 'EV Charging'],
      'latitude': 12.9756,
      'longitude': 77.5996,
      'hotels': [
        {
          'name': 'Urban Stay Hotel',
          'roomsAvailable': 3,
          'totalRooms': 15,
          'rating': 4.2,
          'price': '₹1,800/night',
          'hourlyPrice': '₹400/hour',
        },
        {
          'name': 'Koramangala Suites',
          'roomsAvailable': 25,
          'totalRooms': 35,
          'rating': 4.4,
          'price': '₹2,200/night',
          'hourlyPrice': '₹450/hour',
        },
      ],
      'restaurants': [
        {
          'name': 'Station Diner',
          'tablesAvailable': 8,
          'totalTables': 15,
          'rating': 4.1,
          'price': '₹150/hour',
        },
        {
          'name': 'Quick Bite Cafe',
          'tablesAvailable': 10,
          'totalTables': 15,
          'rating': 3.9,
          'price': '₹100/hour',
        },
      ],
    },
    {
      'name': 'Indiranagar Station',
      'type': 'station_complex',
      'distance': '1.8 km',
      'hotelsAvailable': 4,
      'totalHotels': 6,
      'roomsAvailable': 65,
      'totalRooms': 100,
      'diningTablesAvailable': 35,
      'totalDiningTables': 50,
      'rating': 4.7,
      'roomPrice': '₹600/hour',
      'tablePrice': '₹250/hour',
      'chargingPrice': '₹180/hour',
      'facilities': ['Spa', 'Gym', 'WiFi', 'Pool', 'EV Charging', 'Bar'],
      'latitude': 12.9676,
      'longitude': 77.5896,
      'hotels': [
        {
          'name': 'Premium Plaza Inn',
          'roomsAvailable': 12,
          'totalRooms': 30,
          'rating': 4.7,
          'price': '₹3,200/night',
          'hourlyPrice': '₹600/hour',
        },
        {
          'name': 'Luxury Suites',
          'roomsAvailable': 25,
          'totalRooms': 35,
          'rating': 4.9,
          'price': '₹4,000/night',
          'hourlyPrice': '₹800/hour',
        },
        {
          'name': 'Business Hotel',
          'roomsAvailable': 18,
          'totalRooms': 25,
          'rating': 4.5,
          'price': '₹2,800/night',
          'hourlyPrice': '₹550/hour',
        },
        {
          'name': 'Comfort Stay',
          'roomsAvailable': 10,
          'totalRooms': 10,
          'rating': 4.3,
          'price': '₹2,000/night',
          'hourlyPrice': '₹400/hour',
        },
      ],
      'restaurants': [
        {
          'name': 'Multi-Cuisine Restaurant',
          'tablesAvailable': 18,
          'totalTables': 25,
          'rating': 4.6,
          'price': '₹250/hour',
        },
        {
          'name': 'Coffee Shop',
          'tablesAvailable': 12,
          'totalTables': 15,
          'rating': 4.4,
          'price': '₹150/hour',
        },
        {
          'name': 'Fine Dining',
          'tablesAvailable': 5,
          'totalTables': 10,
          'rating': 4.8,
          'price': '₹350/hour',
        },
      ],
    },
    {
      'name': 'Electronic City Station',
      'type': 'station_complex',
      'distance': '2.3 km',
      'hotelsAvailable': 2,
      'totalHotels': 3,
      'roomsAvailable': 20,
      'totalRooms': 35,
      'diningTablesAvailable': 15,
      'totalDiningTables': 25,
      'rating': 3.9,
      'roomPrice': '₹300/hour',
      'tablePrice': '₹100/hour',
      'chargingPrice': '₹100/hour',
      'facilities': ['WiFi', 'AC', 'EV Charging'],
      'latitude': 12.9796,
      'longitude': 77.6096,
      'hotels': [
        {
          'name': 'Budget Lodge',
          'roomsAvailable': 5,
          'totalRooms': 12,
          'rating': 3.9,
          'price': '₹1,200/night',
          'hourlyPrice': '₹300/hour',
        },
        {
          'name': 'Tech Park Hotel',
          'roomsAvailable': 15,
          'totalRooms': 23,
          'rating': 4.1,
          'price': '₹2,000/night',
          'hourlyPrice': '₹400/hour',
        },
      ],
      'restaurants': [
        {
          'name': 'Food Court',
          'tablesAvailable': 10,
          'totalTables': 15,
          'rating': 3.8,
          'price': '₹100/hour',
        },
        {
          'name': 'Snack Bar',
          'tablesAvailable': 5,
          'totalTables': 10,
          'rating': 3.7,
          'price': '₹80/hour',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentLocation = LatLng(widget.latitude, widget.longitude);
    _destinationLocation = const LatLng(12.9716, 77.5946);
    _initializeMapData();
  }

  void _initializeMapData() {
    // Clear existing markers and polylines
    _markers.clear();
    _polylines.clear();

    // Current location marker
    if (_currentLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );
    }

    // Destination marker
    if (_destinationLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _destinationLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );
    }

    // Station markers
    for (int i = 0; i < nearbyStations.length; i++) {
      final station = nearbyStations[i];
      _markers.add(
        Marker(
          markerId: MarkerId('station_$i'),
          position: LatLng(
            (station['latitude'] as double),
            (station['longitude'] as double),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          infoWindow: InfoWindow(
            title: station['name'] as String,
            snippet: 'Tap for booking options',
          ),
        ),
      );
    }

    if (_showBusSplitOptions) {
      _addBusSplitMarkers();
    }

    // Add polyline if both locations exist
    if (_currentLocation != null && _destinationLocation != null) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          width: 4,
          points: [_currentLocation!, _destinationLocation!],
        ),
      );
    }
  }

  void _addBusSplitMarkers() {
    final splitPoints = [
      const LatLng(12.9746, 77.5966),
      const LatLng(12.9696, 77.5916),
    ];

    for (int i = 0; i < splitPoints.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('split_$i'),
          position: splitPoints[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(title: 'Split Point ${i + 1}'),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _toggleBusSplitOptions() {
    setState(() {
      _showBusSplitOptions = !_showBusSplitOptions;
      _initializeMapData();
    });
  }

  void _performLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default back behavior
      onPopInvoked: (didPop) async {
        if (!didPop && mounted) {
          // Directly exit the app when back button is pressed
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: _currentIndex == 1 ? _buildHomeAppBar() : _buildDefaultAppBar(),
        body: _getCurrentPage(),
        bottomNavigationBar: _buildBottomNavigationBar(),
        floatingActionButton: _currentIndex == 1 ? _buildFloatingActionButton() : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  AppBar _buildHomeAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "BONUS BUS",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Smart Electric Mobility & Hospitality",
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF00C853),
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Icon(
                Icons.battery_charging_full,
                color: _getBatteryColor(batteryPercentage),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                "${batteryPercentage.toInt()}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // Notifications
          },
        ),
      ],
    );
  }

  AppBar _buildDefaultAppBar() {
    String title = '';
    if (_currentIndex == 0) {
      title = 'My Account';
    } else if (_currentIndex == 2) {
      title = 'My Trips';
    }

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFF00C853),
      elevation: 0,
      actions: [
        if (_currentIndex == 0)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutConfirmation(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings, size: 20),
                      SizedBox(width: 8),
                      Text('Settings'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout Confirmation"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 8,
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _bottomNavItems,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF00C853),
        unselectedItemColor: Colors.grey.shade600,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const ProfilePage();
      case 1:
        return _buildHomeContent();
      case 2:
        return const TripDetailsPage();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top gradient section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF00C853),
                  Color(0xFF64DD17),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_bus,
                              color: Color(0xFF00C853),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Quick EV Booking",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00C853).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "ECO FRIENDLY",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF00C853),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildLocationInput(
                            "📍 Pickup", "Current Location", Icons.my_location),
                        const SizedBox(height: 12),
                        _buildLocationInput(
                            "🎯 Destination", "Enter destination", Icons.location_on),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _openBookingOptionsPage(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C853),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            icon: const Icon(Icons.directions_bus, color: Colors.white),
                            label: const Text(
                              "QUICK BOOK NOW",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // TEMPLE PACKAGES BANNER
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.orange.shade50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TemplePackagesPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade300,
                                  Colors.deepOrange.shade400,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "🛕",
                                style: TextStyle(fontSize: 36),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Temple Tour Packages",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "All-inclusive spiritual journeys with rooms, food & transport",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "4 STATES",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "ALL FACILITIES",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "FROM ₹1999",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 12, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Tamil Nadu • Andhra • Telangana • Kerala",
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
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                          Icons.local_offer, "Savings", "₹245", "This month"),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                          Icons.eco, "CO₂ Saved", "48 kg", "Green points"),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                          Icons.star, "Rating", "4.8", "Driver rating"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet and Battery Card
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WalletPage(balance: walletBalance),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.account_balance_wallet,
                                        color: Colors.green.shade700, size: 20),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Wallet",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "₹${walletBalance.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Tap to manage",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChargingStatusPage(
                                    batteryPercentage: batteryPercentage,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.battery_charging_full,
                                        color: _getBatteryColor(batteryPercentage),
                                        size: 20),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Battery",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: batteryPercentage / 100,
                                        backgroundColor: Colors.grey.shade300,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          _getBatteryColor(batteryPercentage),
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${batteryPercentage.toInt()}%",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _getBatteryColor(batteryPercentage),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Live Trip Tracking
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "📍 Live Trip Tracking",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleBusSplitOptions,
                      icon: Icon(
                        _showBusSplitOptions ? Icons.swap_horiz : Icons.swap_horiz_outlined,
                        color: _showBusSplitOptions ? const Color(0xFF00C853) : Colors.grey,
                      ),
                      tooltip: 'Toggle Bus Split Points',
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Map Container
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: const StaticMapBus(),
                  ),
                ),

                // Bus Split Options Info
                if (_showBusSplitOptions)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Card(
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Bus Split Points are shown in orange markers. Tap on them to see split options.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BusSplitChangePage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              child: const Text("Split Bus"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Current Trip Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Current Trip",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "IN PROGRESS",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "MG Road, Bengaluru",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.flag, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Electronic City, Bengaluru",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTripDetail("ETA", "15 min", Icons.access_time),
                            _buildTripDetail("Distance", "8.2 km", Icons.alt_route),
                            _buildTripDetail("Cost", "₹85", Icons.account_balance_wallet),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Nearby Stations
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "🚉 Nearby Stations with Facilities",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChargingStationsPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          color: Color(0xFF00C853),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Station Facilities Table
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Station Name",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Hotels",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Rooms",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Dining",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Book",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Station Rows
                        ...nearbyStations.map((station) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.train, size: 14, color: Colors.purple),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              station['name'] as String,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, size: 11, color: Colors.grey),
                                          const SizedBox(width: 2),
                                          Text(
                                            station['distance'] as String,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.star, size: 11, color: Colors.amber),
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
                                      const SizedBox(height: 2),
                                      Wrap(
                                        spacing: 4,
                                        runSpacing: 4,
                                        children: (station['facilities'] as List<dynamic>)
                                            .take(3)
                                            .map<Widget>((facility) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              facility.toString(),
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.hotel,
                                              size: 14,
                                              color: station['hotelsAvailable'] as int > 0
                                                  ? Colors.blue
                                                  : Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${station['hotelsAvailable']}/${station['totalHotels']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                              color: station['hotelsAvailable'] as int > 0
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        station['hotelsAvailable'] as int > 0 ? "Hotels" : "No hotels",
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: station['hotelsAvailable'] as int > 0 ? Colors.blue : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.king_bed,
                                              size: 14,
                                              color: station['roomsAvailable'] as int > 0
                                                  ? Colors.green
                                                  : Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${station['roomsAvailable']}/${station['totalRooms']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                              color: station['roomsAvailable'] as int > 0
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        station['roomPrice'] as String,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: station['roomsAvailable'] as int > 0 ? Colors.green : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.restaurant,
                                              size: 14,
                                              color: station['diningTablesAvailable'] as int > 0
                                                  ? Colors.red
                                                  : Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${station['diningTablesAvailable']}/${station['totalDiningTables']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                              color: station['diningTablesAvailable'] as int > 0
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        station['tablePrice'] as String,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: station['diningTablesAvailable'] as int > 0 ? Colors.red : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: station['roomsAvailable'] as int > 0 ||
                                              station['diningTablesAvailable'] as int > 0
                                          ? () {
                                              _showStationBookingOptions(station);
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: station['roomsAvailable'] as int > 0 ||
                                                station['diningTablesAvailable'] as int > 0
                                            ? const Color(0xFF00C853)
                                            : Colors.grey,
                                        minimumSize: const Size(70, 32),
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                      ),
                                      child: const Text(
                                        "Book",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
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
                ),

                const SizedBox(height: 20),

                // Station Cards (Alternative View)
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: nearbyStations.length,
                    itemBuilder: (context, index) {
                      final station = nearbyStations[index];
                      return Container(
                        width: 260,
                        margin: EdgeInsets.only(
                          right: index == nearbyStations.length - 1 ? 0 : 12,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              _showStationBookingOptions(station);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.train,
                                        color: Colors.purple.shade700,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          station['name'] as String,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildStationDetail(Icons.location_on, station['distance'] as String),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildStationDetail(
                                          Icons.hotel,
                                          "${station['hotelsAvailable']}/${station['totalHotels']} hotels",
                                          color: station['hotelsAvailable'] as int > 0 ? Colors.blue : Colors.grey,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildStationDetail(
                                          Icons.king_bed,
                                          "${station['roomsAvailable']}/${station['totalRooms']} rooms",
                                          color: station['roomsAvailable'] as int > 0 ? Colors.green : Colors.grey,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildStationDetail(
                                          Icons.restaurant,
                                          "${station['diningTablesAvailable']}/${station['totalDiningTables']} tables",
                                          color: station['diningTablesAvailable'] as int > 0 ? Colors.red : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  _buildStationDetail(Icons.star, "${station['rating']}"),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00C853).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Book Facilities",
                                        style: TextStyle(
                                          color: Color(0xFF00C853),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // EMERGENCY CARD
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.red.shade50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StaticHomeScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emergency,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Emergency Assistance",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "24/7 emergency support with live tracking",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "SOS",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "LIVE TRACKING",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _openBookingOptionsPage(context);
      },
      backgroundColor: const Color(0xFF00C853),
      elevation: 6,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  void _openBookingOptionsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BookingOptionsPage(),
      ),
    );
  }

  Widget _buildLocationInput(String label, String hint, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF00C853), size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetail(String title, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStationDetail(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color ?? Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: color ?? Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Color _getBatteryColor(double percentage) {
    if (percentage > 50) return Colors.green;
    if (percentage > 20) return Colors.orange;
    return Colors.red;
  }

  void _showStationBookingOptions(Map<String, dynamic> station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.8,
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
              Row(
                children: [
                  Icon(Icons.train, color: Colors.purple.shade700, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      station['name'] as String,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(station['distance'] as String),
                  const SizedBox(width: 12),
                  Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text("${station['rating']}"),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Available Facilities",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    // Hotels Section
                    if (station['hotels'] != null && (station['hotels'] as List<dynamic>).isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "🏨 Hotels at Station",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          ...(station['hotels'] as List<dynamic>).map((hotel) {
                            return _buildFacilityOption(
                              Icons.hotel,
                              hotel['name'] as String,
                              "${hotel['roomsAvailable']}/${hotel['totalRooms']} rooms available",
                              hotel['hourlyPrice'] as String,
                              hotel['roomsAvailable'] as int > 0,
                              () {
                                Navigator.pop(context);
                                _showHotelBookingDialog(hotel, station['name'] as String);
                              },
                              Colors.blue,
                            );
                          }).toList(),
                        ],
                      ),

                    // Dining Section
                    if (station['restaurants'] != null && (station['restaurants'] as List<dynamic>).isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "🍽️ Dining Options",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          ...(station['restaurants'] as List<dynamic>).map((restaurant) {
                            return _buildFacilityOption(
                              Icons.restaurant,
                              restaurant['name'] as String,
                              "${restaurant['tablesAvailable']}/${restaurant['totalTables']} tables available",
                              restaurant['price'] as String,
                              restaurant['tablesAvailable'] as int > 0,
                              () {
                                Navigator.pop(context);
                                _showRestaurantBookingDialog(restaurant, station['name'] as String);
                              },
                              Colors.red,
                            );
                          }).toList(),
                        ],
                      ),

                    // Station Facilities
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "🏆 Station Facilities",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (station['facilities'] as List<dynamic>).map<Widget>((facility) {
                        return Chip(
                          label: Text(
                            facility.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.green.shade50,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFacilityOption(
    IconData icon,
    String title,
    String subtitle,
    String price,
    bool isAvailable,
    VoidCallback onTap,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: isAvailable ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isAvailable ? color : Colors.grey,
            minimumSize: const Size(70, 36),
          ),
          child: const Text(
            "Book",
            style: TextStyle(color: Colors.white),
          ),
        ),
        onTap: isAvailable ? onTap : null,
      ),
    );
  }

  void _showHotelBookingDialog(Map<String, dynamic> hotel, String stationName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Book ${hotel['name']} at $stationName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hourly Price: ${hotel['hourlyPrice']}"),
            const SizedBox(height: 8),
            Text("Nightly Price: ${hotel['price']}"),
            const SizedBox(height: 8),
            Text("Available Rooms: ${hotel['roomsAvailable']}/${hotel['totalRooms']}"),
            const SizedBox(height: 8),
            Text("Rating: ${hotel['rating']}"),
            const SizedBox(height: 16),
            const Text("Select booking duration:"),
            // Add duration selection UI here
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
              // Handle hotel booking
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text("Book Room"),
          ),
        ],
      ),
    );
  }

  void _showRestaurantBookingDialog(Map<String, dynamic> restaurant, String stationName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Book Table at ${restaurant['name']} - $stationName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: ${restaurant['price']}"),
            const SizedBox(height: 8),
            Text("Available Tables: ${restaurant['tablesAvailable']}/${restaurant['totalTables']}"),
            const SizedBox(height: 8),
            Text("Rating: ${restaurant['rating']}"),
            const SizedBox(height: 16),
            const Text("Select dining time:"),
            // Add time selection UI here
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
              // Handle table booking
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Book Table"),
          ),
        ],
      ),
    );
  }
}

// Booking Options Page
class BookingOptionsPage extends StatelessWidget {
  const BookingOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Your Trip",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF00C853),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Normal Booking Form
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Normal Trip Booking",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLocationField("📍 Pickup", "Current Location"),
                    const SizedBox(height: 12),
                    _buildLocationField("🎯 Destination", "Enter destination"),
                    const SizedBox(height: 12),
                    _buildDateTimeField(),
                    const SizedBox(height: 12),
                    _buildPassengerField(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RealTimeBookingPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.directions_bus, color: Colors.white),
                        label: const Text(
                          "CONFIRM BOOKING",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Other Booking Options
            const Text(
              "Other Booking Options",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Recurring Booking Card
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.repeat, color: Colors.blue),
                ),
                title: const Text(
                  "Recurring Booking",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Daily/Weekly commute schedule"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecurringBookingPage(),
                    ),
                  );
                },
              ),
            ),

            // Group Booking Card
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.group, color: Colors.purple),
                ),
                title: const Text(
                  "Group Booking",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Travel with friends & family"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GroupBookingPage(),
                    ),
                  );
                },
              ),
            ),

            // Off-Peak Booking Card
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.offline_bolt, color: Colors.orange),
                ),
                title: const Text(
                  "Off-Peak Booking",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Save with discounted fares"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OffPeakBookingPage(),
                    ),
                  );
                },
              ),
            ),

            // Bus Split Booking Card
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.swap_horiz, color: Colors.teal),
                ),
                title: const Text(
                  "Bus Split Booking",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Split your journey between buses"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BusSplitChangePage(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Back to Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField(String label, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(
            label.contains("Pickup") ? Icons.my_location : Icons.location_on,
            color: Colors.grey.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildDateTimeField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "📅 Date & Time",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Now",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildPassengerField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.person, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "👥 Passengers",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "1 Passenger",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
        ],
      ),
    );
  }
}

// RealTimeBookingPage
class RealTimeBookingPage extends StatelessWidget {
  const RealTimeBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real Time Booking"),
        backgroundColor: const Color(0xFF00C853),
      ),
      body: const Center(
        child: Text("Real Time Booking Page"),
      ),
    );
  }
}