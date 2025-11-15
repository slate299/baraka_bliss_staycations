import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/apartment.dart';
import '../widgets/apartment_card.dart';

class ApartmentListingsScreen extends StatelessWidget {
  const ApartmentListingsScreen({super.key});

  Future<List<Apartment>> fetchApartments() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('apartments')
        .get();
    return snapshot.docs
        .map((doc) => Apartment.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background
      appBar: AppBar(
        title: const Text(
          'Our Apartments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: const Color(0xFF2C3539),
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Apartment>>(
        future: fetchApartments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingState();
          } else if (snapshot.hasError) {
            return _ErrorState(error: snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const _EmptyState();
          }

          final apartments = snapshot.data!;
          return _ApartmentListView(apartments: apartments);
        },
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2C3539).withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              color: const Color(0xFF2C3539),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Finding Your Perfect Stay...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C3539).withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loading our luxury apartments',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF2C3539).withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2C3539).withOpacity(0.1),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: const Color(0xFF2C3539).withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something Went Wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C3539),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We couldn\'t load the apartments. Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xFF2C3539).withOpacity(0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Error: $error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFF2C3539).withOpacity(0.5),
                fontFamily: 'Monospace',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // You might want to add retry logic here
                Navigator.pushReplacementNamed(context, '/listings');
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3539),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2C3539).withOpacity(0.1),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 50,
                color: const Color(0xFF2C3539).withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Apartments Available',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C3539),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We\'re currently preparing more luxury stays for you. Please check back soon for new listings.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xFF2C3539).withOpacity(0.7),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Back to Home'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2C3539),
                side: BorderSide(
                  color: const Color(0xFF2C3539).withOpacity(0.3),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApartmentListView extends StatelessWidget {
  final List<Apartment> apartments;

  const _ApartmentListView({required this.apartments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with count
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2C3539).withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Luxury Stays',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2C3539).withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${apartments.length} apartment${apartments.length != 1 ? 's' : ''} found',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF2C3539).withOpacity(0.6),
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
                  color: const Color(0xFF2C3539).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.apartment_rounded,
                      size: 16,
                      color: const Color(0xFF2C3539).withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${apartments.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C3539),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Apartments list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: apartments.length,
            itemBuilder: (context, index) {
              final apartment = apartments[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ApartmentCard(apartment: apartment),
              );
            },
          ),
        ),
      ],
    );
  }
}
