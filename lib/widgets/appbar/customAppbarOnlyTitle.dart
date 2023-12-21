import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors.dart';

Widget customAppbarOnlyTitle(String title, BuildContext context) {
  return Container(
    height: 60,
    width: double.infinity,
    decoration: BoxDecoration(
      color: primary.shade600,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Text(
          title,
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
      ],
    ),
  );
}
