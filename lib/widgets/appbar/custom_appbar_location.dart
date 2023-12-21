import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors.dart';

Widget customAppBarLocation(TextEditingController searchTextEditingController) {
  return Container(
    height: 150,
    width: double.infinity,
    decoration: BoxDecoration(
      color: primary.shade600,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 33,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Choose Location",
                            style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                          const Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                      Text(
                        "J-1/358 D.D.A Flats Kalkaji,New Delhi",
                        style: GoogleFonts.nunito(
                            color: Colors.white70, fontSize: 14),
                      )
                    ],
                  )
                ],
              ),
              const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 33,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 44.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchTextEditingController,
                  style: GoogleFonts.nunito(color: Colors.white70),
                  decoration: InputDecoration(
                    fillColor: const Color(0xff80ad72).withOpacity(0.9),
                    filled: true,
                    hintText: "Search",
                    hintStyle: GoogleFonts.nunito(color: Colors.white70),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    prefixIcon: const Icon(
                      Icons.search_outlined,
                      color: Colors.white70,
                    ),
                    suffixIcon: const Icon(
                      Icons.mic_none_outlined,
                      color: Colors.white70,
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: const OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
