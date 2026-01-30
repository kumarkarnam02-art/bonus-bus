// static_map_bus.dart
import 'package:flutter/material.dart';
import 'dart:async';


class StaticMapBus extends StatefulWidget {
  const StaticMapBus({super.key});

  @override
  State<StaticMapBus> createState() => _StaticMapBusState();
}

class _StaticMapBusState extends State<StaticMapBus> {
  double _busProgress = 0.0;
  Timer? _animationTimer;
  bool _isPlaying = false;

  // Route points for bus movement
  final List<Map<String, dynamic>> _routePoints = [
    {'x': 0.1, 'y': 0.5, 'name': 'Srikakulam'},
    {'x': 0.3, 'y': 0.5, 'name': 'Vizianagaram'},
    {'x': 0.5, 'y': 0.5, 'name': 'Visakhapatnam'},
    {'x': 0.7, 'y': 0.6, 'name': 'Vijayawada'},
    {'x': 0.9, 'y': 0.7, 'name': 'Hyderabad'},
  ];

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _isPlaying = true;
    _animationTimer?.cancel();
    
    _animationTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _busProgress += 0.01;
        if (_busProgress >= 1.0) {
          _busProgress = 1.0;
          timer.cancel();
          _isPlaying = false;
        }
      });
    });
  }

  void _pauseAnimation() {
    _animationTimer?.cancel();
    _isPlaying = false;
  }

  void _resetAnimation() {
    _animationTimer?.cancel();
    setState(() {
      _busProgress = 0.0;
      _isPlaying = false;
    });
  }

  Map<String, dynamic> _getCurrentBusPosition() {
  if (_busProgress == 0.0) return _routePoints.first;
  if (_busProgress >= 1.0) return _routePoints.last;
  
  double segment = _busProgress * (_routePoints.length - 1);
  int index = segment.floor();
  double fraction = segment - index;
  
  if (index >= _routePoints.length - 1) {
    return _routePoints.last;
  }
  
  Map<String, dynamic> start = _routePoints[index];
  Map<String, dynamic> end = _routePoints[index + 1];
  
  // FIXED VERSION - Proper type casting
  double startX = (start['x'] as num).toDouble();
  double startY = (start['y'] as num).toDouble();
  double endX = (end['x'] as num).toDouble();
  double endY = (end['y'] as num).toDouble();
  
  return {
    'x': startX + (endX - startX) * fraction,
    'y': startY + (endY - startY) * fraction,
    'name': 'Between ${start['name']} & ${end['name']}',
  };
}
  @override
  Widget build(BuildContext context) {
    final busPos = _getCurrentBusPosition();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Map with Bus'),
        backgroundColor: Colors.blue.shade800,
      ),
      
      body: Column(
        children: [
          // Map Display
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: Center(
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Map Background
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade50,
                              Colors.green.shade50,
                            ],
                          ),
                        ),
                      ),
                      
                      // Road
                      Positioned(
                        top: 175,
                        left: 50,
                        child: Container(
                          width: 250,
                          height: 6,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      
                      // Route Line
                      Positioned(
                        top: 177,
                        left: 50,
                        child: Container(
                          width: 250,
                          height: 2,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      
                      // Start Point
                      Positioned(
                        top: 170,
                        left: 45,
                        child: Column(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: const Center(
                                child: Text(
                                  'S',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Srikakulam',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // End Point
                      Positioned(
                        top: 240,
                        right: 45,
                        child: Column(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: const Center(
                                child: Text(
                                  'H',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Hyderabad',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Charging Stations
                      Positioned(
                        top: 185,
                        left: 100,
                        child: _chargingStation('1'),
                      ),
                      Positioned(
                        top: 185,
                        left: 150,
                        child: _chargingStation('2'),
                      ),
                      Positioned(
                        top: 185,
                        left: 200,
                        child: _chargingStation('3'),
                      ),
                      Positioned(
                        top: 205,
                        left: 250,
                        child: _chargingStation('4'),
                      ),
                      Positioned(
                        top: 225,
                        left: 280,
                        child: _chargingStation('5'),
                      ),
                      
                      // Bus
                      Positioned(
                        top: (busPos['y'] as double) * 350 - 15,
                        left: (busPos['x'] as double) * 350 - 15,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '🚌',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      
                      // Legend
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _legendItem(Colors.green, 'Start'),
                              _legendItem(Colors.red, 'End'),
                              _legendItem(Colors.blue, 'Bus'),
                              _legendItem(Colors.purple, 'Station'),
                            ],
                          ),
                        ),
                      ),
                      
                      // Current Location
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                busPos['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${(_busProgress * 100).toStringAsFixed(1)}% complete',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Controls Panel
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                LinearProgressIndicator(
                  value: _busProgress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 20),
                
                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _resetAnimation,
                      icon: const Icon(Icons.replay),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    
                    ElevatedButton.icon(
                      onPressed: _isPlaying ? _pauseAnimation : _startAnimation,
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(_isPlaying ? 'Pause' : 'Play'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPlaying ? Colors.orange : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    
                    ElevatedButton.icon(
                      onPressed: () {
                        _showRouteInfo();
                      },
                      icon: const Icon(Icons.info),
                      label: const Text('Info'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Route Info
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Srikakulam → Hyderabad',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Distance: ${(650 * _busProgress).toInt()} / 650 km',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade800,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'EV BUS',
                          style: TextStyle(
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
        ],
      ),
    );
  }

  Widget _chargingStation(String number) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Station $number',
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      )
    );
  }

  void _showRouteInfo() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Route Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Srikakulam to Hyderabad Route',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              _infoRow('Total Distance', '650 km'),
              _infoRow('Estimated Time', '12-14 hours'),
              _infoRow('Route Type', 'NH16 Highway'),
              _infoRow('Charging Stations', '5 stations'),
              
              const SizedBox(height: 20),
              
              const Text(
                'Stations:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              _stationInfo('1', 'Srikakulam-Vizianagaram'),
              _stationInfo('2', 'Vizianagaram-Visakhapatnam'),
              _stationInfo('3', 'Rajahmundry-Eluru'),
              _stationInfo('4', 'Vijayawada-Guntur'),
              _stationInfo('5', 'Tirupati-Chittoor'),
              
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _stationInfo(String number, String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(location)),
        ],
      ),
    );
  }
}