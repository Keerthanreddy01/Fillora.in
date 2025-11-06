import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final List<ServiceCategory> _categories = [
    ServiceCategory(
      title: 'Document Processing',
      icon: Icons.description,
      color: const Color(0xFF007AFF),
      services: [
        Service('PDF Tools', Icons.picture_as_pdf, 'Convert, merge, split PDFs'),
        Service('Text Extract', Icons.text_fields, 'Extract text from images'),
        Service('OCR Scanner', Icons.document_scanner, 'Convert images to text'),
        Service('Document Converter', Icons.transform, 'Convert between formats'),
      ],
    ),
    ServiceCategory(
      title: 'AI Features',
      icon: Icons.psychology,
      color: const Color(0xFF8B5CF6),
      services: [
        Service('Form Filler', Icons.edit_document, 'Auto-fill forms with AI'),
        Service('Data Extractor', Icons.auto_awesome, 'Extract structured data'),
        Service('Document Summarizer', Icons.summarize, 'Summarize long documents'),
        Service('Translation', Icons.translate, 'Translate documents'),
      ],
    ),
    ServiceCategory(
      title: 'Productivity',
      icon: Icons.speed,
      color: const Color(0xFF10B981),
      services: [
        Service('QR Generator', Icons.qr_code, 'Generate QR codes'),
        Service('Barcode Scanner', Icons.qr_code_scanner, 'Scan barcodes'),
        Service('Template Library', Icons.library_books, 'Pre-made templates'),
        Service('Batch Processing', Icons.layers, 'Process multiple files'),
      ],
    ),
    ServiceCategory(
      title: 'Cloud & Storage',
      icon: Icons.cloud,
      color: const Color(0xFFFF6B6B),
      services: [
        Service('Cloud Sync', Icons.cloud_upload, 'Sync across devices'),
        Service('Backup Manager', Icons.backup, 'Automatic backups'),
        Service('File Sharing', Icons.share, 'Share documents securely'),
        Service('Version Control', Icons.history, 'Track document changes'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'All Services',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: Duration(milliseconds: index * 200),
              child: _buildCategorySection(_categories[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategorySection(ServiceCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  category.color.withOpacity(0.2),
                  category.color.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: category.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${category.services.length}',
                    style: TextStyle(
                      color: category.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Services Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: category.services.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(category.services[index], category.color);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Service service, Color categoryColor) {
    return GestureDetector(
      onTap: () {
        _showServiceDetails(service, categoryColor);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                service.icon,
                color: categoryColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              service.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              service.description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Pro',
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceDetails(Service service, Color color) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                service.icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              service.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Navigate to specific service screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Use Service',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<Service> services;

  ServiceCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.services,
  });
}

class Service {
  final String name;
  final IconData icon;
  final String description;

  Service(this.name, this.icon, this.description);
}