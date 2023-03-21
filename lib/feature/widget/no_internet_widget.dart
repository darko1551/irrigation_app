import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_sharp,
            size: 60,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "No internet connection!",
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
