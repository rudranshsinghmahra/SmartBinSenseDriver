import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customCardProfile(
    IconData icon, String title, VoidCallback voidCallback) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: voidCallback,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xfffff1cc),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    icon,
                    size: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: GoogleFonts.nunito(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
