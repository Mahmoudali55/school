// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:my_template/core/theme/app_text_style.dart';

// class ParentInfoCard extends StatelessWidget {
//   const ParentInfoCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 1.5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 32,
//               backgroundColor: Colors.blue[100],
//               child: Icon(Icons.person, size: 40, color: Colors.blue[700]),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'أ. محمد أحمد'.tr(),
//                     style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'ولي أمر الطالب'.tr(),
//                     style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(Icons.phone, size: 14, color: Colors.grey[600]),
//                       const SizedBox(width: 4),
//                       Text(
//                         '+966 50 123 4567'.tr(),
//                         style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               onPressed: () {},
//               icon: Icon(Icons.message, color: Colors.blue[700]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
