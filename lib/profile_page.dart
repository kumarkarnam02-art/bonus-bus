import 'package:flutter/material.dart';
import './login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 3),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C853), Color(0xFF64DD17)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Rajesh Kumar",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "+91 9876543210",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Gold Member",
                        style: TextStyle(
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

            // Account Details
            const Text(
              "Account Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildAccountItem(Icons.email, "Email", "rajesh@example.com"),
                  _buildDivider(),
                  _buildAccountItem(Icons.location_on, "Address", "Bangalore, India"),
                  _buildDivider(),
                  _buildAccountItem(Icons.calendar_today, "Member Since", "Jan 2024"),
                  _buildDivider(),
                  _buildAccountItem(Icons.verified, "Verified", "✓ Phone & Email"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Statistics
            const Text(
              "Statistics",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard("Trips", "48", Icons.directions_bus),
                _buildStatCard("Points", "1250", Icons.star),
                _buildStatCard("CO₂ Saved", "56 kg", Icons.eco),
                _buildStatCard("Rating", "4.8", Icons.thumb_up),
              ],
            ),

            const SizedBox(height: 20),

            // Quick Actions
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildActionItem(
                    Icons.edit,
                    "Edit Profile",
                    "Update your information",
                    () {
                      // Edit profile
                    },
                  ),
                  _buildDivider(),
                  _buildActionItem(
                    Icons.history,
                    "Trip History",
                    "View all past trips",
                    () {
                      // Navigate to trip history
                    },
                  ),
                  _buildDivider(),
                  _buildActionItem(
                    Icons.share,
                    "Refer Friends",
                    "Earn ₹100 per referral",
                    () {
                      // Share referral
                    },
                  ),
                  _buildDivider(),
                  _buildActionItem(
                    Icons.help,
                    "Help & Support",
                    "Get assistance",
                    () {
                      // Help & support
                    },
                  ),
                  _buildDivider(),
                  _buildActionItem(
                    Icons.logout,
                    "Logout",
                    "Sign out of account",
                    () {
                      _showLogoutConfirmation(context);
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00C853)),
      title: Text(title),
      subtitle: Text(value),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF00C853), size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color color = const Color(0xFF00C853),
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
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
              Navigator.pop(context); // Close dialog
              // Use Future.microtask to schedule navigation
              Future.microtask(() {
                _performLogout(context);
              });
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

  void _performLogout(BuildContext context) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Use Future.delayed with microtask to avoid build context issues
    Future.delayed(const Duration(milliseconds: 500), () {
      // Close loading indicator
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // Navigate to login page with clear stack
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    });
  }
}