import 'package:flutter/material.dart';

class FloatingPage extends StatelessWidget {
  var backPage;

  FloatingPage({super.key, this.backPage});

  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The page underneath the floating page
        // backPage,
        // The floating page
        Positioned(
          bottom: 0,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Container(
            color: Colors.white.withOpacity(0.8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Floating Page',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
