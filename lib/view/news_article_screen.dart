import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsArticleScreen extends StatefulWidget {
  final String image;
  final String title;
  final String date;
  final String author;
  final String details;
  final String content;
  final String source;

  const NewsArticleScreen({
    Key? key,
    required this.image,
    required this.title,
    required this.date,
    required this.author,
    required this.details,
    required this.content,
    required this.source,
  }) : super(key: key);

  @override
  State<NewsArticleScreen> createState() => _NewsArticleScreenState();
}

class _NewsArticleScreenState extends State<NewsArticleScreen> {
  final DateFormat displayFormat = DateFormat('MMMM dd, yyyy');
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    // Parse the date string using the specified format
    try {
      dateTime = displayFormat.parse(widget.date);
    } catch (e) {
      print("Error parsing date: $e");
      dateTime = DateTime.now(); // Fallback in case of an error
    }
    print(widget.details); // Example of accessing the widget's properties
  }

  @override
  Widget build(BuildContext context) {
    final double Kwidth = MediaQuery.of(context).size.width;
    final double Kheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[600],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Image Section
          Container(
            height: Kheight * 0.45,
            width: Kwidth,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.image,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              ),
            ),
          ),
          // Details Section
          Container(
            margin: EdgeInsets.only(top: Kheight * 0.4),
            padding: const EdgeInsets.all(20),
            height: Kheight * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView(
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: Kheight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.source,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      displayFormat.format(dateTime),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Kheight * 0.03),
                Text(
                  widget.details,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Kheight * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
