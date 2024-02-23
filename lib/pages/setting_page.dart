// import 'package:flutter/material.dart';
// import 'package:flype/common/app_assets.dart';
// import 'package:flype/common/app_color.dart';
// import 'dart:math' as math;

// import 'package:flype/common/app_fonts.dart';
// import 'package:flype/data/provider/auth_provider.dart';
// import 'package:provider/provider.dart';

// class SettingPage extends StatelessWidget {
//   final Function() onLogout;

//   const SettingPage({
//     super.key,
//     required this.onLogout,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final authUser = Provider.of<AuthProvider>(context, listen: false);
//     final authWatch = context.watch<AuthProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.background,
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'FLYPE',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.only(
//                   left: 25,
//                   right: 25,
//                 ),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       const CircleAvatar(
//                         radius: 45,
//                         backgroundImage: AssetImage(
//                           AppAsset.profile,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         authUser.user.name.toString(),
//                         style: whiteTextstyle,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Text(
//                 'About Us',
//                 style: whiteTextstyle,
//               ),
//               const SizedBox(height: 10),
//               const Center(
//                 child: Text(
//                   '~ Make our team, discover our history and find branches ~',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     color: AppColor.white,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Logout',
//                     style: whiteTextstyle,
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       final authRead = context.read<AuthProvider>();
//                       final result = await authRead.logout();
//                       if (result) onLogout();
//                     },
//                     child: authWatch.isLoadingLogout
//                         ? const CircularProgressIndicator(
//                             color: Colors.white,
//                           )
//                         : Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 5),
//                                 child: Transform.rotate(
//                                   angle: math
//                                       .pi, // Use math.pi for rotation in radians
//                                   child: const Icon(
//                                     Icons.logout,
//                                     color: AppColor.white,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 'Logout',
//                                 style: whiteTextstyle,
//                               ),
//                             ],
//                           ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
