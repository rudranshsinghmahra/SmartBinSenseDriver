import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customComplaintCard(
    String title, VoidCallback voidCallback, bool showNumber) {
  return GestureDetector(
    onTap: voidCallback,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.message,
                    color: Color(0xffffae0c),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      title,
                      style: GoogleFonts.nunito(),
                    ),
                  )
                ],
              ),
              showNumber
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffffecb6),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Text(
                            "03",
                            style: GoogleFonts.nunito(),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    ),
  );
}
