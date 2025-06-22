import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../home_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  final List<DownloadItem> _downloads = [];

  void addDownload(String fileName, String fileType) {
    setState(() {
      _downloads.add(
        DownloadItem(
          fileName: fileName,
          fileType: fileType,
          dateTime: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor =
        isDarkMode ? const Color(0xFF9D84E3) : const Color(0xFF4A2D8B);
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF3F0F7);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Downloads',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _downloads.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download_done,
                    size: 64,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No downloads yet',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _downloads.length,
              itemBuilder: (context, index) {
                final download = _downloads[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      download.fileType == 'PDF'
                          ? Icons.picture_as_pdf
                          : Icons.image,
                      color: primaryColor,
                    ),
                    title: Text(
                      download.fileName,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Downloaded on ${download.formattedDate}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.download_done,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        // Implement re-download functionality
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DownloadItem {
  final String fileName;
  final String fileType;
  final DateTime dateTime;

  DownloadItem({
    required this.fileName,
    required this.fileType,
    required this.dateTime,
  });

  String get formattedDate {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
