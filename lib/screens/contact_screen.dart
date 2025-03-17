import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/responsive_utils.dart';
import '../widgets/nav_bar.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int _currentCarouselIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // List of featured products/services with images
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'image': 'assets/images/slider-1.jpg',
      'title': 'Pooja Items',
      'description': 'Traditional offerings for all ceremonies',
    },
    {
      'image': 'assets/images/slider-2.jpg',
      'title': 'Traditional Lamps',
      'description': 'Brass and copper lamps for worship',
    },
    {
      'image': 'assets/images/slider-3.jpg',
      'title': 'Home Groceries',
      'description': 'Authentic ingredients for your kitchen',
    },
    {
      'image': 'assets/images/slider-4.jpg',
      'title': 'Festival Supplies',
      'description': 'Everything you need for celebrations',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Updated store information from business card
    const String storeName = "S.பழனி ஸ்டோர்"; // S.Palani Store
    const String storeNameEnglish = "S.Palani Store";
    const List<String> phoneNumbers = [
      "0416-2226945",
      "99407 28216",
      "99528 84281",
    ];
    const String storeAddress = "F22/2, நேதாஜி மார்கெட், வேலூர் - 632 004";
    const String storeAddressEnglish =
        "F22/2, Nethaji Market, Vellore - 632 004";
    const String businessDescription =
        "ஹோம கிராசியங்கள் & பூஜை பொருட்கள் கிடைக்குமிடம்";
    const String businessDescriptionEnglish =
        "Home groceries & Pooja items available";

    // Coordinates from the Google Maps link (approximate)
    const double latitude = 12.920295;
    const double longitude = 79.133179;

    return ResponsiveUtils.responsiveScaffold(
      context: context,
      appBar: AppBar(
        toolbarHeight: 80,
        title:
            ResponsiveUtils.isDesktop(context)
                ? WebNavBar(currentRoute: '/contact', showSearchBar: false)
                : const AppTitle(),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with carousel
            _buildCarouselSection(context),

            // Store info card
            _buildStoreInfoCard(
              context,
              storeName,
              storeNameEnglish,
              businessDescription,
              businessDescriptionEnglish,
            ),
            // Contact and map section
            _buildContactSection(
              context,
              phoneNumbers,
              storeAddress,
              storeAddressEnglish,
              latitude,
              longitude,
            ),

            // Bottom padding for FAB
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _launchMaps(latitude, longitude),
        label: Text(
          'Get Directions',
          style: TextStyle(
            fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
          ),
        ),
        icon: Icon(Icons.directions, size: context.responsiveIconSize),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  Widget _buildCarouselSection(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
            ),
            items:
                _carouselItems.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Stack(
                            children: [
                              // Image with fallback
                              Image.asset(
                                item['image'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.orange[100],
                                    child: Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.orange[300],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Gradient overlay
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                              // Title and description
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['description'],
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 12),
          // Carousel indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                _carouselItems.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _carouselController.animateToPage(entry.key),
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepOrange.withOpacity(
                          _currentCarouselIndex == entry.key ? 0.9 : 0.4,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfoCard(
    BuildContext context,
    String storeName,
    String storeNameEnglish,
    String businessDescription,
    String businessDescriptionEnglish,
  ) {
    final bool isEnglishLayout = true; // Toggle based on app language settings

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Store icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange[50],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange[300]!, width: 2),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/ganesha_icon.png',
                  width: 40,
                  height: 40,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.storefront,
                        size: 30,
                        color: Colors.deepOrange[800],
                      ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Store info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnglishLayout ? storeNameEnglish : storeName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEnglishLayout
                        ? businessDescriptionEnglish
                        : businessDescription,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.verified, size: 18, color: Colors.green[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Established 1995',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(
    BuildContext context,
    List<String> phoneNumbers,
    String storeAddress,
    String storeAddressEnglish,
    double latitude,
    double longitude,
  ) {
    final bool isEnglishLayout = true; // Toggle based on app language settings

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),

          // Map
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(latitude, longitude),
                  initialZoom: 16.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: LatLng(latitude, longitude),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Contact details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address
                _buildContactRow(
                  icon: Icons.location_on,
                  title: 'Address',
                  // ignore: dead_code
                  content: isEnglishLayout ? storeAddressEnglish : storeAddress,
                  onTap: () => _launchMaps(latitude, longitude),
                ),

                const Divider(height: 24),

                // Phone numbers
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < phoneNumbers.length; i++)
                      _buildContactRow(
                        icon: i == 0 ? Icons.phone : Icons.smartphone,
                        title: i == 0 ? 'Office' : 'Mobile $i',
                        content: phoneNumbers[i],
                        onTap:
                            () => _launchPhone(
                              phoneNumbers[i]
                                  .replaceAll('-', '')
                                  .replaceAll(' ', ''),
                            ),
                        showDivider: i < phoneNumbers.length - 1,
                      ),
                  ],
                ),

                const Divider(height: 24),

                // Business hours
                _buildContactRow(
                  icon: Icons.access_time,
                  title: 'Business Hours',
                  content:
                      'Mon-Sat: 9:00 AM - 8:00 PM\nSunday: 9:00 AM - 1:00 PM',
                  onTap: () {},
                  isMultiLine: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback onTap,
    bool showDivider = false,
    bool isMultiLine = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              crossAxisAlignment:
                  isMultiLine
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.deepOrange, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        content,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 16),
      ],
    );
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _launchMaps(double latitude, double longitude) async {
    final Uri mapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    if (await canLaunchUrl(mapsUrl)) {
      await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
    }
  }
}
