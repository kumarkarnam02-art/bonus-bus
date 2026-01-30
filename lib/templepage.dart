// TemplePackagesPage.dart
import 'package:flutter/material.dart';

class TemplePackagesPage extends StatefulWidget {
  const TemplePackagesPage({super.key});

  @override
  State<TemplePackagesPage> createState() => _TemplePackagesPageState();
}

class _TemplePackagesPageState extends State<TemplePackagesPage> {
  int _selectedState = 0; // 0: Tamil Nadu, 1: Andhra, 2: Telangana, 3: Kerala
  String _selectedDuration = '2D1N'; // 2D1N, 3D2N, 5D4N, 7D6N
  int _selectedPeople = 2; // Number of people
  List<Map<String, dynamic>> _selectedTemples = [];

  // Temple data by state
  final Map<String, List<Map<String, dynamic>>> _stateTemples = {
    'Tamil Nadu': [
      {
        'name': 'Meenakshi Amman Temple',
        'location': 'Madurai',
        'deity': 'Goddess Meenakshi & Lord Sundareswarar',
        'special': 'One of 275 Paadal Petra Sthalams',
        'facilities': ['AC Rooms', 'Pure Vegetarian Food', 'Guided Tour', 'Prasadam'],
        'image': '🛕',
        'price': 2500,
        'rating': 4.8,
        'mustVisit': true,
      },
      {
        'name': 'Brihadeeswara Temple',
        'location': 'Thanjavur',
        'deity': 'Lord Shiva',
        'special': 'UNESCO World Heritage Site',
        'facilities': ['Heritage Rooms', 'Temple Food', 'Cultural Show', 'Darshan Pass'],
        'image': '🏛️',
        'price': 2200,
        'rating': 4.7,
        'mustVisit': true,
      },
      {
        'name': 'Ramanathaswamy Temple',
        'location': 'Rameswaram',
        'deity': 'Lord Shiva',
        'special': 'Jyotirlinga & Char Dham',
        'facilities': ['Sea View Rooms', 'Satvik Food', 'Holy Dip', 'Pooja Services'],
        'image': '🌊',
        'price': 2800,
        'rating': 4.6,
        'mustVisit': true,
      },
      {
        'name': 'Kapaleeshwarar Temple',
        'location': 'Chennai',
        'deity': 'Lord Shiva',
        'special': 'Dravidian Architecture',
        'facilities': ['City View Rooms', 'Traditional Food', 'Quick Darshan', 'Pooja Kit'],
        'image': '🕌',
        'price': 2000,
        'rating': 4.5,
        'mustVisit': false,
      },
      {
        'name': 'Kanchipuram Temples',
        'location': 'Kanchipuram',
        'deity': 'Varadaraja Perumal & Ekambareswarar',
        'special': 'Temple City - Multiple Temples',
        'facilities': ['Multiple Stay Options', 'Special Prasadam', 'Silk Shopping', 'All Temples Tour'],
        'image': '🏙️',
        'price': 3000,
        'rating': 4.7,
        'mustVisit': true,
      },
    ],
    'Andhra Pradesh': [
      {
        'name': 'Tirumala Venkateswara Temple',
        'location': 'Tirupati',
        'deity': 'Lord Venkateswara',
        'special': 'Richest Temple in World',
        'facilities': ['Tirumala Rooms', 'Laddu Prasadam', 'VIP Darshan', 'Hair Tonsure'],
        'image': '🙏',
        'price': 3500,
        'rating': 4.9,
        'mustVisit': true,
      },
      {
        'name': 'Simhachalam Temple',
        'location': 'Visakhapatnam',
        'deity': 'Lord Narasimha',
        'special': 'Hill Temple with unique deity form',
        'facilities': ['Hill View Rooms', 'Andhra Meals', 'Rope Way', 'Special Darshan'],
        'image': '⛰️',
        'price': 2200,
        'rating': 4.6,
        'mustVisit': false,
      },
      {
        'name': 'Srisailam Temple',
        'location': 'Kurnool',
        'deity': 'Lord Mallikarjuna & Goddess Bhramaramba',
        'special': 'Jyotirlinga & Shakti Peetha',
        'facilities': ['River View Rooms', 'Satvik Food', 'Narmada Bath', 'Pooja Services'],
        'image': '🌅',
        'price': 2800,
        'rating': 4.7,
        'mustVisit': true,
      },
      {
        'name': 'Kanaka Durga Temple',
        'location': 'Vijayawada',
        'deity': 'Goddess Kanaka Durga',
        'special': 'Seated on Indrakeeladri Hill',
        'facilities': ['Hill Top Rooms', 'Traditional Meals', 'River Cruise', 'Evening Aarti'],
        'image': '🌄',
        'price': 2100,
        'rating': 4.5,
        'mustVisit': false,
      },
    ],
    'Telangana': [
      {
        'name': 'Bhadrachalam Temple',
        'location': 'Bhadradri',
        'deity': 'Lord Rama',
        'special': 'Associated with Bhakta Ramadas',
        'facilities': ['River Side Rooms', 'Traditional Food', 'Boat Ride', 'Ramayana Show'],
        'image': '🛶',
        'price': 2300,
        'rating': 4.6,
        'mustVisit': true,
      },
      {
        'name': 'Gnana Saraswati Temple',
        'location': 'Basara',
        'deity': 'Goddess Saraswati',
        'special': 'One of two Saraswati temples in India',
        'facilities': ['Educational Stay', 'Satvik Food', 'Vidyarambham', 'Library Access'],
        'image': '📚',
        'price': 2000,
        'rating': 4.5,
        'mustVisit': false,
      },
      {
        'name': 'Yadagirigutta Temple',
        'location': 'Yadadri',
        'deity': 'Lord Lakshmi Narasimha',
        'special': 'Recently renovated with modern facilities',
        'facilities': ['Modern Rooms', 'Healthy Food', 'Medical Aid', 'Quick Darshan'],
        'image': '🆕',
        'price': 2500,
        'rating': 4.7,
        'mustVisit': true,
      },
      {
        'name': 'Jogulamba Temple',
        'location': 'Alampur',
        'deity': 'Goddess Jogulamba',
        'special': 'Shakti Peetha',
        'facilities': ['Heritage Rooms', 'Traditional Meals', 'Temple Tour', 'Cultural Programs'],
        'image': '🎭',
        'price': 2100,
        'rating': 4.4,
        'mustVisit': false,
      },
    ],
    'Kerala': [
      {
        'name': 'Sabarimala Temple',
        'location': 'Pathanamthitta',
        'deity': 'Lord Ayyappa',
        'special': 'Annual Pilgrimage (Nov-Jan)',
        'facilities': ['Forest Stay', 'Free Food', 'Trek Support', 'Medical Camp'],
        'image': '🌲',
        'price': 3000,
        'rating': 4.8,
        'mustVisit': true,
      },
      {
        'name': 'Guruvayur Temple',
        'location': 'Guruvayur',
        'deity': 'Lord Krishna',
        'special': 'Bhooloka Vaikuntham',
        'facilities': ['Premium Rooms', 'Kerala Sadya', 'Elephant View', 'Pooja Services'],
        'image': '🐘',
        'price': 2700,
        'rating': 4.7,
        'mustVisit': true,
      },
      {
        'name': 'Padmanabhaswamy Temple',
        'location': 'Thiruvananthapuram',
        'deity': 'Lord Padmanabha (Vishnu)',
        'special': 'Richest Temple & Royal Temple',
        'facilities': ['Heritage Rooms', 'Traditional Food', 'Royal Tour', 'Cultural Show'],
        'image': '👑',
        'price': 3200,
        'rating': 4.8,
        'mustVisit': true,
      },
      {
        'name': 'Chottanikkara Temple',
        'location': 'Ernakulam',
        'deity': 'Goddess Rajarajeshwari',
        'special': 'Famous for healing mental ailments',
        'facilities': ['Peaceful Rooms', 'Ayurvedic Food', 'Healing Sessions', 'Pooja'],
        'image': '🕉️',
        'price': 2400,
        'rating': 4.6,
        'mustVisit': false,
      },
      {
        'name': 'Attukal Bhagavathy Temple',
        'location': 'Thiruvananthapuram',
        'deity': 'Goddess Bhagavathy',
        'special': 'Pongala Festival (Largest gathering of women)',
        'facilities': ['City Stay', 'Pongala Kit', 'Festival Guide', 'Traditional Food'],
        'image': '🔥',
        'price': 2600,
        'rating': 4.5,
        'mustVisit': false,
      },
    ],
  };

  // Package types
  final List<Map<String, dynamic>> _packageTypes = [
    {
      'name': 'Budget Pilgrim',
      'icon': '💰',
      'description': 'Basic accommodation & food',
      'facilities': ['Simple AC Room', 'Basic Meals', 'Standard Darshan', 'Local Transport'],
      'multiplier': 1.0,
    },
    {
      'name': 'Comfort Devotee',
      'icon': '🛏️',
      'description': 'Comfort stay with better facilities',
      'facilities': ['Comfort Room', 'Quality Meals', 'Quick Darshan', 'AC Transport'],
      'multiplier': 1.3,
    },
    {
      'name': 'Premium Spiritual',
      'icon': '⭐',
      'description': 'Luxury stay with VIP treatment',
      'facilities': ['Premium Room', 'Gourmet Food', 'VIP Darshan', 'Private Transport'],
      'multiplier': 1.7,
    },
    {
      'name': 'Royal Experience',
      'icon': '👑',
      'description': 'Ultimate luxury & exclusive access',
      'facilities': ['Suite Room', 'Royal Meals', 'Special Pooja', 'Luxury Car'],
      'multiplier': 2.2,
    },
  ];

  int _selectedPackage = 0;

  // Duration options
  final List<String> _durations = ['2D1N', '3D2N', '5D4N', '7D6N'];
  final Map<String, double> _durationMultiplier = {
    '2D1N': 1.0,
    '3D2N': 1.5,
    '5D4N': 2.5,
    '7D6N': 3.5,
  };

  @override
  Widget build(BuildContext context) {
    final currentState = _getCurrentState();
    final temples = _stateTemples[currentState] ?? [];
    final selectedPackage = _packageTypes[_selectedPackage];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Temple Tour Packages",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange.shade800,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              _showSavedPackages();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // State Selection
            const Text(
              "Select State",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  _buildStateOption('Tamil Nadu', 0),
                  _buildStateOption('Andhra Pradesh', 1),
                  _buildStateOption('Telangana', 2),
                  _buildStateOption('Kerala', 3),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Duration Selection
            const Text(
              "Select Duration",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _durations.length,
                itemBuilder: (context, index) {
                  final duration = _durations[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDuration = duration;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: index == _durations.length - 1 ? 0 : 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedDuration == duration
                            ? Colors.deepOrange
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        duration,
                        style: TextStyle(
                          color: _selectedDuration == duration
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Package Type Selection
            const Text(
              "Select Package Type",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _packageTypes.length,
                itemBuilder: (context, index) {
                  final package = _packageTypes[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPackage = index;
                      });
                    },
                    child: Container(
                      width: 200,
                      margin: EdgeInsets.only(right: index == _packageTypes.length - 1 ? 0 : 12),
                      child: Card(
                        color: _selectedPackage == index
                            ? Colors.deepOrange.shade50
                            : Colors.white,
                        elevation: _selectedPackage == index ? 4 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: _selectedPackage == index
                                ? Colors.deepOrange
                                : Colors.grey.shade300,
                            width: _selectedPackage == index ? 2 : 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(package['icon'], style: const TextStyle(fontSize: 20)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      package['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                package['description'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(package['multiplier'] * 100).toInt()}% of base price',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
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

            // People Selection
            const Text(
              "Number of People",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Adults",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_selectedPeople > 1) {
                            setState(() {
                              _selectedPeople--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.grey,
                      ),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(
                          '$_selectedPeople',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_selectedPeople < 10) {
                            setState(() {
                              _selectedPeople++;
                            });
                          }
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Temple Selection
            const Text(
              "Select Temples to Visit",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "${_selectedTemples.length} temples selected",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),

            // Temple List
            ...temples.asMap().entries.map((entry) {
              final index = entry.key;
              final temple = entry.value;
              final isSelected = _selectedTemples.contains(temple);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? Colors.deepOrange : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTemples.remove(temple);
                      } else {
                        _selectedTemples.add(temple);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              temple['image'],
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
                                      temple['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (temple['mustVisit'] as bool)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "Must Visit",
                                        style: TextStyle(
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
                                temple['location'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 12, color: Colors.amber),
                                  const SizedBox(width: 2),
                                  Text(
                                    "${temple['rating']}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "₹${temple['price']} per person",
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
                        Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedTemples.add(temple);
                              } else {
                                _selectedTemples.remove(temple);
                              }
                            });
                          },
                          activeColor: Colors.deepOrange,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // Price Summary
            _buildPriceSummary(),

            const SizedBox(height: 24),

            // Book Now Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _selectedTemples.isNotEmpty ? () {
                  _bookPackage();
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.book_online, color: Colors.white),
                label: const Text(
                  "BOOK TEMPLE PACKAGE NOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

  Widget _buildStateOption(String stateName, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedState = index;
            _selectedTemples.clear();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedState == index
                ? Colors.deepOrange.shade100
                : Colors.transparent,
            border: Border(
              right: index < 3
                  ? BorderSide(color: Colors.grey.shade300)
                  : BorderSide.none,
            ),
          ),
          child: Column(
            children: [
              Text(
                _getStateEmoji(stateName),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                _getShortStateName(stateName),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _selectedState == index
                      ? Colors.deepOrange
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStateEmoji(String stateName) {
    switch (stateName) {
      case 'Tamil Nadu':
        return '🛕';
      case 'Andhra Pradesh':
        return '🙏';
      case 'Telangana':
        return '🏛️';
      case 'Kerala':
        return '🌴';
      default:
        return '🛕';
    }
  }

  String _getShortStateName(String stateName) {
    switch (stateName) {
      case 'Tamil Nadu':
        return 'TN';
      case 'Andhra Pradesh':
        return 'AP';
      case 'Telangana':
        return 'TS';
      case 'Kerala':
        return 'KL';
      default:
        return stateName;
    }
  }

  String _getCurrentState() {
    switch (_selectedState) {
      case 0:
        return 'Tamil Nadu';
      case 1:
        return 'Andhra Pradesh';
      case 2:
        return 'Telangana';
      case 3:
        return 'Kerala';
      default:
        return 'Tamil Nadu';
    }
  }

  Widget _buildPriceSummary() {
    if (_selectedTemples.isEmpty) {
      return Container();
    }

    final basePrice = _calculateBasePrice();
    final packageMultiplier = _packageTypes[_selectedPackage]['multiplier'] as double;
    final durationMultiplier = _durationMultiplier[_selectedDuration] ?? 1.0;
    final totalPrice = basePrice * packageMultiplier * durationMultiplier * _selectedPeople;
    final gst = totalPrice * 0.18;
    final finalPrice = totalPrice + gst;

    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📋 Package Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow("Selected Temples", "${_selectedTemples.length} temples"),
            _buildSummaryRow("Duration", _selectedDuration),
            _buildSummaryRow("Package Type", _packageTypes[_selectedPackage]['name']),
            _buildSummaryRow("Number of People", "$_selectedPeople people"),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _buildPriceRow("Base Price", "₹${basePrice.toInt()}"),
            _buildPriceRow(
                "Package Type (${(packageMultiplier * 100).toInt()}%)",
                "₹${(basePrice * packageMultiplier).toInt()}"),
            _buildPriceRow(
                "Duration (${_selectedDuration})",
                "₹${(basePrice * packageMultiplier * durationMultiplier).toInt()}"),
            _buildPriceRow(
                "For $_selectedPeople people",
                "₹${(basePrice * packageMultiplier * durationMultiplier * _selectedPeople).toInt()}"),
            _buildPriceRow("GST (18%)", "₹${gst.toInt()}"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    "₹${finalPrice.toInt()}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "🎁 Includes: AC Transport, Accommodation, Food (3 times), Darshan arrangements, Guide services",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
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
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
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
    );
  }

  double _calculateBasePrice() {
    double total = 0;
    for (var temple in _selectedTemples) {
      total += temple['price'] as double;
    }
    return total;
  }

  void _bookPackage() {
    final totalPrice = _calculateFinalPrice();
    final packageName = _packageTypes[_selectedPackage]['name'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Temple Package"),
        content: SizedBox(
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.temple_buddhist, size: 60, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  "Your Spiritual Journey Package",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildBookingDetail("Package Type", packageName),
                _buildBookingDetail("State", _getCurrentState()),
                _buildBookingDetail("Duration", _selectedDuration),
                _buildBookingDetail("Temples", "${_selectedTemples.length} temples"),
                _buildBookingDetail("People", "$_selectedPeople people"),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                ..._selectedTemples.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final temple = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text("$index. ${temple['name']} - ${temple['location']}"),
                  );
                }).toList(),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                const Text("Package Includes:"),
                const SizedBox(height: 8),
                ..._packageTypes[_selectedPackage]['facilities'].map<Widget>((facility) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("✓ $facility"),
                  );
                }).toList(),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "₹${totalPrice.toInt()}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              _processBooking(totalPrice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
            ),
            child: const Text("Confirm & Pay"),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  double _calculateFinalPrice() {
    final basePrice = _calculateBasePrice();
    final packageMultiplier = _packageTypes[_selectedPackage]['multiplier'] as double;
    final durationMultiplier = _durationMultiplier[_selectedDuration] ?? 1.0;
    final totalPrice = basePrice * packageMultiplier * durationMultiplier * _selectedPeople;
    final gst = totalPrice * 0.18;
    return totalPrice + gst;
  }

  void _processBooking(double totalPrice) {
    final bookingId = "TEMPLE${DateTime.now().millisecondsSinceEpoch}";
    
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🎉 Booking Confirmed!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text(
              "Your temple tour package has been booked successfully!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Booking ID: $bookingId"),
            const SizedBox(height: 8),
            Text("Amount Paid: ₹${totalPrice.toInt()}"),
            const SizedBox(height: 8),
            const Text("You will receive itinerary details via email & SMS."),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "📞 Contact our pilgrimage support: 1800-XXX-XXXX",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to packages page
              setState(() {
                _selectedTemples.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Package booked successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
            ),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  void _showSavedPackages() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Saved Packages"),
        content: SizedBox(
          height: 300,
          width: double.maxFinite,
          child: Column(
            children: [
              const Icon(Icons.bookmark, size: 60, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                "Save your favorite packages",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Bookmark packages for quick booking later.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // In real app, this would save the current selection
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Package saved to bookmarks!"),
                    ),
                  );
                },
                icon: const Icon(Icons.bookmark_add),
                label: const Text("Save Current Package"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}