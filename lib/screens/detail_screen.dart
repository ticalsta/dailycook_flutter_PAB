import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final String ingredients;
  final String steps;

  const DetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.ingredients,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF8F0),

      appBar: AppBar(backgroundColor: Colors.orange, title: Text(title)),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Center(child: Text(emoji, style: const TextStyle(fontSize: 120))),

              const SizedBox(height: 30),

              Text(
                title,

                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                subtitle,

                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
              ),

              const SizedBox(height: 30),

              Text(
                "Bahan-Bahan",

                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(ingredients, style: GoogleFonts.poppins(fontSize: 16)),

              const SizedBox(height: 30),

              Text(
                "Cara Memasak",

                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(steps, style: GoogleFonts.poppins(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
