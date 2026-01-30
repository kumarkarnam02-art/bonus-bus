import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelGo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StaticHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StaticHomeScreen extends StatelessWidget {
  // Mock user data
  final String userName = "John Doe";
  final String phoneNumber = "+91 9876543210";
  final String currentLocation = "MG Road, Mumbai";

  // Mock emergency contacts
  final List<Map<String, dynamic>> emergencyContacts = [
    {
      'name': 'Police',
      'number': '100',
      'icon': Icons.local_police,
      'color': Colors.blue,
    },
    {
      'name': 'Ambulance',
      'number': '108',
      'icon': Icons.local_hospital,
      'color': Colors.red,
    },
    {
      'name': 'Fire Brigade',
      'number': '101',
      'icon': Icons.fire_truck,
      'color': Colors.orange,
    },
    {
      'name': 'Women Helpline',
      'number': '1091',
      'icon': Icons.woman,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.person, color: Colors.blue),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text(
              currentLocation,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Emergency SOS Card
              _buildEmergencySOSCard(context),
              
              SizedBox(height: 20),
              
              // Emergency Services
              _buildEmergencyServices(),
              
              SizedBox(height: 20),
              
              // Quick Emergency Options
              _buildQuickEmergencyOptions(context),
              
              SizedBox(height: 20),
              
              // Active Emergencies
              _buildActiveEmergencies(),
              
              SizedBox(height: 20),
              
              // Safety Tips
              _buildSafetyTips(),
            ],
          ),
        ),
      ),
      
      // Emergency SOS Floating Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSOSDialog(context);
        },
        backgroundColor: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emergency, color: Colors.white),
            Text('SOS', style: TextStyle(fontSize: 10, color: Colors.white)),
          ],
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
      ),
    );
  }

  Widget _buildEmergencySOSCard(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade600, Colors.orange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.emergency, size: 30, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'EMERGENCY SOS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              'Press the SOS button in case of emergency',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _showSOSDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emergency),
                  SizedBox(width: 10),
                  Text('ACTIVATE SOS', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5,
          ),
          itemCount: emergencyContacts.length,
          itemBuilder: (context, index) {
            final contact = emergencyContacts[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: contact['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(contact['icon'], color: contact['color']),
                ),
                title: Text(
                  contact['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(contact['number']),
                trailing: Icon(Icons.call, color: Colors.green),
                onTap: () {
                  _showCallDialog(context, contact['name'], contact['number']);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickEmergencyOptions(BuildContext context) {
    final List<Map<String, dynamic>> quickOptions = [
      {
        'title': 'Health Emergency',
        'icon': Icons.local_hospital,
        'color': Colors.red,
        'description': 'Medical assistance needed',
      },
      {
        'title': 'Washroom Emergency',
        'icon': Icons.wc,
        'color': Colors.blue,
        'description': 'Urgent washroom needed',
      },
      {
        'title': 'Location Stop',
        'icon': Icons.location_off,
        'color': Colors.orange,
        'description': 'Need to stop immediately',
      },
      {
        'title': 'Safety Concern',
        'icon': Icons.security,
        'color': Colors.green,
        'description': 'Feeling unsafe',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Emergency Options',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
          ),
          itemCount: quickOptions.length,
          itemBuilder: (context, index) {
            final option = quickOptions[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  _showEmergencyAlert(context, option['title']);
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: option['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(option['icon'], color: option['color'], size: 24),
                      ),
                      SizedBox(height: 10),
                      Text(
                        option['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        option['description'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActiveEmergencies() {
    final List<Map<String, dynamic>> activeEmergencies = [
      {
        'type': 'Health Emergency',
        'location': '0.5 km away',
        'time': '2 min ago',
        'priority': 'High',
        'color': Colors.red,
      },
      {
        'type': 'Accident Reported',
        'location': '1.2 km away',
        'time': '5 min ago',
        'priority': 'Critical',
        'color': Colors.orange,
      },
      {
        'type': 'Washroom Emergency',
        'location': '0.8 km away',
        'time': '1 min ago',
        'priority': 'Medium',
        'color': Colors.blue,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Emergencies Nearby',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.red),
                  SizedBox(width: 5),
                  Text(
                    '${activeEmergencies.length} Active',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Column(
          children: activeEmergencies.map((emergency) {
            return Card(
              margin: EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: emergency['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.warning, color: emergency['color']),
                ),
                title: Text(
                  emergency['type'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${emergency['location']} • ${emergency['time']}'),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: emergency['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    emergency['priority'],
                    style: TextStyle(
                      color: emergency['color'],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSafetyTips() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  'Safety Tips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildSafetyTipItem('Share your ride details with trusted contacts'),
            _buildSafetyTipItem('Verify driver details before boarding'),
            _buildSafetyTipItem('Use SOS button in case of emergency'),
            _buildSafetyTipItem('Sit in the back seat if traveling alone'),
            _buildSafetyTipItem('Keep emergency contacts updated'),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTipItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showSOSDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.emergency, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text('EMERGENCY SOS'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, size: 60, color: Colors.red),
              SizedBox(height: 20),
              Text(
                'Are you sure you want to activate SOS?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'This will send emergency alerts to:',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10),
              _buildRecipientItem('Emergency Contacts'),
              _buildRecipientItem('Nearby Police'),
              _buildRecipientItem('TravelGo Safety Team'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSOSActivatedDialog(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSOSActivatedDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('ACTIVATE SOS'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecipientItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green),
          SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }

  void _showSOSActivatedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('SOS ACTIVATED'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emergency, size: 60, color: Colors.green),
              SizedBox(height: 20),
              Text(
                'Emergency SOS has been activated!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Help is on the way. Stay calm and safe.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alert Details:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('Location: $currentLocation'),
                    Text('Time: ${DateTime.now().toString()}'),
                    Text('Status: Help dispatched'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCallDialog(BuildContext context, String service, String number) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Call $service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.call, size: 50, color: Colors.green),
              SizedBox(height: 20),
              Text(
                'Call $service at',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                number,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showCallSimulation(context, service, number);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.call),
                  SizedBox(width: 5),
                  Text('Call Now'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCallSimulation(BuildContext context, String service, String number) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Calling $service...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.call, size: 60, color: Colors.green),
              SizedBox(height: 20),
              Text(
                'Simulating call to:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                '$service\n$number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text(
                'Connecting...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('End Call'),
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyAlert(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 10),
              Text('$type Alert'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notification_important, size: 60, color: Colors.orange),
              SizedBox(height: 20),
              Text(
                'Send $type alert?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'This will notify nearby users and emergency services.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showAlertSentDialog(context, type);
              },
              child: Text('Send Alert'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertSentDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Alert Sent'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 60, color: Colors.green),
              SizedBox(height: 20),
              Text(
                '$type alert has been sent!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Help is on the way. Stay safe.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}