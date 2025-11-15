import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold key for controlling the drawer from TopBar
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      appBar: TopBar(
        titleText: 'Baraka Bliss Staycations',
        scaffoldKey: scaffoldKey,
        isLoggedIn: false, // no logout icon on HomeScreen
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(
              0xFF2C3539,
            ).withOpacity(0.03), // Subtle primary color tint
            Colors.grey[50]!,
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Enhanced Logo Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2C3539).withOpacity(0.1),
                        blurRadius: 25,
                        spreadRadius: 3,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF2C3539).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/logo/baraka_logo.png',
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Decorative circle behind logo
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF2C3539).withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Welcome Text with improved typography
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Baraka Bliss\nStaycations',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C3539),
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Tagline with decorative elements
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3539).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF2C3539).withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('🌴', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 12),
                      Text(
                        'Your Perfect Getaway Awaits',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2C3539),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('🌴', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Enhanced Description Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: const Color(0xFF2C3539).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        Text(
                          'Discover luxurious apartments and serene getaways across Kenya. Experience the perfect blend of comfort, style, and authentic hospitality in every stay.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF2C3539).withOpacity(0.8),
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Enhanced Features Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C3539).withOpacity(0.02),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF2C3539).withOpacity(0.05),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildFeature(
                                Icons.verified_user,
                                'Verified',
                                'Quality',
                              ),
                              _buildFeature(
                                Icons.auto_awesome,
                                'Premium',
                                'Comfort',
                              ),
                              _buildFeature(
                                Icons.support_agent,
                                '24/7',
                                'Support',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Enhanced CTA Buttons
                Column(
                  children: [
                    // Primary Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/listings');
                      },
                      icon: const Icon(Icons.search, size: 22),
                      label: const Text(
                        'Explore Apartments',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C3539),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 18,
                        ),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadowColor: const Color(0xFF2C3539).withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Secondary Button
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/about');
                      },
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text('Learn More About Us'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2C3539),
                        side: BorderSide(
                          color: const Color(0xFF2C3539).withOpacity(0.3),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF2C3539).withOpacity(0.1),
                const Color(0xFF2C3539).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2C3539).withOpacity(0.1)),
          ),
          child: Icon(icon, color: const Color(0xFF2C3539), size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2C3539),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF2C3539).withOpacity(0.6),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
