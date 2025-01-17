import 'package:flutter/material.dart';

class CustomToast {
  static void showCustomToast(BuildContext context, {required String message}) {
    // Create an overlay entry
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.12, // Toast position
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xffDB3022), // Background color
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white, // Text color
                letterSpacing: 1.1,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    // Insert the overlay
    overlay.insert(overlayEntry);

    // Remove the overlay after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// class ToastExampleScreen extends StatelessWidget {

//   const ToastExampleScreen({Key? key}) : super(key: key);

//   void showCustomToast(BuildContext context) {
//     showToastWidget(
//       Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         margin: const EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           color: const Color(0xffDB3022), // Toast background color
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: const Text(
//           "This is a custom toast!",
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: Colors.white, // Text color
//             fontSize: 16,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//       context: context,
//       duration: const Duration(seconds: 2), // Toast duration
//       position: StyledToastPosition.top, // Toast appears at the top
//       animation: StyledToastAnimation.slideFromTopFade, // Slide in from the top
//       reverseAnimation: StyledToastAnimation.slideToTopFade, // Slide out to the top
//       startOffset: const Offset(0.0, -3.0), // Start offscreen (top)
//       endOffset: const Offset(0.0, 0.0), // End at the top position
//       curve: Curves.easeInOut, // Animation curve
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Custom Toast Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showCustomToast(context);
//           },
//           child: const Text("Show Custom Toast"),
//         ),
//       ),
//     );
//   }
// }

