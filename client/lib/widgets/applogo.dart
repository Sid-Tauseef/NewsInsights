import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CommonLogo extends StatelessWidget {
  const CommonLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Improved title styling with a container for shadow effect
        Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent, // Background color
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 10,
                offset: Offset(0, 4), // Horizontal and vertical offset
                spreadRadius: 2, // Spread radius
              ),
            ],
          ),
          padding: const EdgeInsets.all(16), // Padding inside the container
          child: "News Insights".text.xl4.bold.white.make(),
        ),

        // Improved agenda styling
        const SizedBox(height: 10), // Space between title and agenda
        "Read news which are Verified and Reliable"
            .text
            .light
            .yellow100 // Softer tone for better contrast
            .size(18)
            .lineHeight(1.5) // Improved line height for readability
            .make()
            .centered(), // Center align the agenda
      ],
    );
  }
}
