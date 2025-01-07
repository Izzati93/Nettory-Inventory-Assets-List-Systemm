import 'package:flutter/material.dart';
import 'package:nettory_app/pages/asset.dart';
import 'package:nettory_app/pages/staff.dart';
import 'package:nettory_app/user_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? role;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    String? fetchedRole = await UserService().getUserRole();
    setState(() {
      role = fetchedRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color.fromARGB(255, 43, 162, 253),
      ),
      body: Center(
        child: role == 'admin' 
            ? _buildAdminInterface() 
            : _buildStaffInterface(),
      ),
    );
  }

  // Admin interface - displays both "Assets List" and "Users List"
  Widget _buildAdminInterface() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff281537),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Assets List',
              description: 'View and manage all assets in the system.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Asset()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Users List',
              description: 'View and manage users in the system.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Staff()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Staff interface - only shows "Assets List"
  Widget _buildStaffInterface() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to your Dashboard!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff281537),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Assets List',
              description: 'View the assets assigned to you.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Asset()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a card for each dashboard item
  Widget _buildCard({
    required String title,
    required String description,
    required VoidCallback onPressed,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.business,
                color: Color.fromARGB(255, 43, 162, 253),
                size: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff281537),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 43, 162, 253),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
