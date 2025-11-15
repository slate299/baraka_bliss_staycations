import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/top_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // create a scaffold key to control the drawer from TopBar
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: TopBar(
        titleText: 'About Us',
        scaffoldKey: scaffoldKey, // enables hamburger menu
        isLoggedIn: false, // no logout icon
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF2E7D32).withOpacity(0.05), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Logo
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo/baraka_logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Company Name
              const Text(
                'Baraka Bliss Staycations',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '🌴 Your Gateway to Comfort 🌴',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF777777),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 32),

              // About Card
              _buildCard(
                icon: Icons.info_outline,
                title: 'Who We Are',
                content:
                    'Baraka Bliss Staycations connects travelers with relaxing, fully furnished apartments across Kenya. We believe every journey should feel like home, offering comfort and affordability wherever you go.',
              ),
              const SizedBox(height: 20),

              // Mission Card
              _buildCard(
                icon: Icons.flag,
                title: 'Our Mission',
                content:
                    'To provide exceptional staycation experiences that blend luxury, comfort, and authentic Kenyan hospitality. We curate each property with care to ensure your stay is memorable.',
              ),
              const SizedBox(height: 20),

              // Values Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Color(0xFF66BB6A),
                        size: 32,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Our Values',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildValueItem(
                        Icons.verified,
                        'Quality',
                        'Every property is carefully vetted',
                      ),
                      _buildValueItem(
                        Icons.handshake,
                        'Trust',
                        'Transparent pricing and honest service',
                      ),
                      _buildValueItem(
                        Icons.support_agent,
                        'Support',
                        '24/7 customer assistance',
                      ),
                      _buildValueItem(
                        Icons.eco,
                        'Sustainability',
                        'Eco-friendly practices',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Contact Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Get in Touch',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      Icons.email,
                      'Email',
                      'info@barakabliss.co.ke',
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(Icons.phone, 'Phone', '+254 700 000 000'),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      Icons.location_on,
                      'Location',
                      'Mombasa, Kenya',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/listings');
                  },
                  icon: const Icon(Icons.home_work),
                  label: const Text('Explore Apartments'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF66BB6A), size: 32),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF66BB6A).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
