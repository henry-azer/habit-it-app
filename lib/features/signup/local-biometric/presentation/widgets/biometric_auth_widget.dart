// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
//
// class LocalAuthenticationWidget extends StatefulWidget {
//   @override
//   _LocalAuthenticationWidgetState createState() =>
//       _LocalAuthenticationWidgetState();
// }
//
// class _LocalAuthenticationWidgetState extends State<LocalAuthenticationWidget> {
//   final LocalAuthentication _localAuthentication = LocalAuthentication();
//   bool _isAuthenticated = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Local Authentication'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'Authenticate to access the app',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _authenticate,
//               child: Text('Authenticate'),
//             ),
//             SizedBox(height: 20),
//             if (_isAuthenticated)
//               Text(
//                 'Authentication successful!',
//                 style: TextStyle(fontSize: 18, color: Colors.green),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
// }
