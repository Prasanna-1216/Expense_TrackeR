import 'package:expense_tracker/login%20Signup/Screen/dashboard_screen.dart';
import 'package:expense_tracker/login%20Signup/Screen/setting_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildQuickActions(context),
            const SizedBox(height: 20),
            _buildRecentActivities(),
            const SizedBox(height: 20),
            _buildNotifications(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return const Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  AssetImage('assets/profile.jpg'), // Add a profile image
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('johndoe@example.com'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionButton(
          context,
          icon: Icons.add,
          label: 'Add Expense',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          },
        ),
        _buildQuickActionButton(
          context,
          icon: Icons.bar_chart,
          label: 'View Reports',
          onPressed: () {
            // Navigate to Reports screen
          },
        ),
        _buildQuickActionButton(
          context,
          icon: Icons.notifications,
          label: 'Notifications',
          onPressed: () {
            // Navigate to Notifications screen
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40),
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return const Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Bought groceries'),
              subtitle: Text('\$50'),
            ),
            ListTile(
              leading: Icon(Icons.local_gas_station),
              title: Text('Filled gas'),
              subtitle: Text('\$30'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifications() {
    return const Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notification_important),
              title: Text('Weekly report is ready'),
              subtitle: Text('View your weekly expense report'),
            ),
            ListTile(
              leading: Icon(Icons.notification_important),
              title: Text('New update available'),
              subtitle: Text('Update to the latest version'),
            ),
          ],
        ),
      ),
    );
  }
}
