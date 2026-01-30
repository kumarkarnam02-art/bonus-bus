import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './home_page.dart';

class LocationAccessPage extends StatefulWidget {
  const LocationAccessPage({super.key});

  @override
  State<LocationAccessPage> createState() => _LocationAccessPageState();
}

class _LocationAccessPageState extends State<LocationAccessPage> {
  bool loading = false;
  String statusMessage = "Requesting location access...";
  bool showSkipOption = false;

  Future<void> enableLocation() async {
    setState(() {
      loading = true;
      statusMessage = "Checking location services...";
    });

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        loading = false;
        statusMessage = "Location services are disabled";
        showSkipOption = true;
      });
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Location Services Disabled"),
            content: const Text(
              "Please enable location services on your device to get the best experience. "
              "You can continue without location but some features may be limited.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      setState(() {
        statusMessage = "Requesting location permission...";
      });
      
      permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied) {
        setState(() {
          loading = false;
          statusMessage = "Permission denied";
          showSkipOption = true;
        });
        
        if (mounted) {
          showSnack("Location permission is required for full features");
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        loading = false;
        statusMessage = "Permission permanently denied";
        showSkipOption = true;
      });
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Location Permission Required"),
            content: const Text(
              "Location permission has been permanently denied. "
              "Please enable it from app settings for full functionality. "
              "You can continue with limited features.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Continue Anyway"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openAppSettings();
                },
                child: const Text("Open Settings"),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Get current position
    setState(() {
      statusMessage = "Getting your location...";
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        loading = false;
        statusMessage = "Failed to get location";
        showSkipOption = true;
      });
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Location Error"),
            content: Text(
              "Could not get your location: ${e.toString()}. "
              "You can continue with default location.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _continueWithDefaultLocation();
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        );
      }
    }
  }

  void _continueWithDefaultLocation() {
    // Default location (Mumbai coordinates)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          latitude: 19.0760,  // Mumbai latitude
          longitude: 72.8777, // Mumbai longitude
        ),
      ),
    );
  }

  void showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0F2027),
              const Color(0xFF203A43),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skip button
                if (showSkipOption)
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _continueWithDefaultLocation,
                      child: const Text(
                        "Skip for now",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // App Logo/Icon
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00C853).withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF00C853).withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.directions_bus,
                              size: 60,
                              color: Color(0xFF00C853),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Title
                          const Text(
                            "Welcome to EV Move",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 10),
                          
                          Text(
                            "Electric Vehicle Booking App",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          
                          const SizedBox(height: 60),
                          
                          // Location Card
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(26),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 70,
                                    color: Color(0xFF00C853),
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  const Text(
                                    "Location Access Required",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  
                                  Text(
                                    statusMessage,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  
                                  const SizedBox(height: 30),
                                  
                                  // Why we need location
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Why we need location:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        _buildReasonItem("📍 Find nearby EV stations"),
                                        _buildReasonItem("🚌 Locate available buses"),
                                        _buildReasonItem("🗺️ Show accurate routes"),
                                        _buildReasonItem("⏱️ Estimate travel time"),
                                        _buildReasonItem("🔋 Find charging points"),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 30),
                                  
                                  // Loading or Button
                                  if (loading)
                                    Column(
                                      children: [
                                        const CircularProgressIndicator(
                                          color: Color(0xFF00C853),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          statusMessage,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 55,
                                          child: ElevatedButton.icon(
                                            onPressed: enableLocation,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF00C853),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              elevation: 4,
                                            ),
                                            icon: const Icon(Icons.location_on, size: 24),
                                            label: const Text(
                                              "ALLOW LOCATION ACCESS",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 15),
                                        
                                        if (showSkipOption)
                                          TextButton(
                                            onPressed: _continueWithDefaultLocation,
                                            child: const Text(
                                              "Continue without location",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Privacy Note
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Your location data is used only to provide services and is never shared with third parties.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
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
  }

  Widget _buildReasonItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}