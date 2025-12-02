// import 'package:flutter/material.dart';
// import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
// import 'package:my_template/core/theme/app_colors.dart';
// import 'package:my_template/core/theme/app_text_style.dart';


// class HelpSupportScreen extends StatelessWidget {
//   const HelpSupportScreen({super.key});

//   final List<Map<String, dynamic>> _faqs = const [
//     {
//       'question': 'كيف أسجل في المقرر الدراسي؟',
//       'answer': 'يمكنك التسجيل في المقرر من خلال قائمة المقررات ثم النقر على زر التسجيل.',
//     },
//     {
//       'question': 'كيف أتسلم الواجبات؟',
//       'answer': 'يمكنك تسليم الواجبات من خلال صفحة المقرر ثم اختيار الواجب المطلوب.',
//     },
//     {
//       'question': 'كيف أتواصل مع الأستاذ؟',
//       'answer': 'يمكنك التواصل مع الأستاذ من خلال صفحة المقرر ثم النقر على أيقونة المحادثة.',
//     },
//     {
//       'question': 'ماذا أفعل إذا نسيت كلمة المرور؟',
//       'answer':
//           'يمكنك استعادة كلمة المرور من خلال صفحة تسجيل الدخول ثم النقر على نسيت كلمة المرور.',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         context,
//         title: Text(
//           'المساعدة والدعم',
//           style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // الأسئلة الشائعة
//               Text(
//                 'الأسئلة الشائعة',
//                 style: AppTextStyle.titleSmall(context, color: AppColor.blackColor(context)),
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _faqs.length,
//                   itemBuilder: (context, index) {
//                     final faq = _faqs[index];
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       child: ExpansionTile(
//                         title: Text(faq['question'], style: AppTextStyle.bodyMedium(context)),
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Text(
//                               faq['answer'],
//                               style: AppTextStyle.bodySmall(
//                                 context,
//                                 color: AppColor.greyColor(context),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               // طرق التواصل
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'طرق التواصل',
//                         style: AppTextStyle.titleSmall(
//                           context,
//                           color: AppColor.blackColor(context),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildContactOption(
//                         icon: Icons.email,
//                         title: 'البريد الإلكتروني',
//                         subtitle: 'support@university.edu',
//                         onTap: () => _launchEmail('support@university.edu'),
//                         context: context,
//                       ),
//                       _buildContactOption(
//                         icon: Icons.phone,
//                         title: 'الهاتف',
//                         subtitle: '+966 11 123 4567',
//                         onTap: () => _launchPhone('+966111234567'),
//                         context: context,
//                       ),
//                       _buildContactOption(
//                         icon: Icons.chat,
//                         title: 'الدعم الفني المباشر',
//                         subtitle: 'متاح من الساعة 8 صباحاً حتى 4 مساءً',
//                         onTap: () => _openLiveChat(context),
//                         context: context,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContactOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     required BuildContext context,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: AppColor.primaryColor(context)),
//       title: Text(title, style: AppTextStyle.bodyMedium(context)),
//       subtitle: Text(
//         subtitle,
//         style: AppTextStyle.bodySmall(context, color: AppColor.greyColor(context)),
//       ),
//       onTap: onTap,
//     );
//   }

//   Future<void> _launchEmail(String email) async {
//     final Uri uri = Uri.parse('mailto:$email');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }



//   void _openLiveChat(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('الدعم الفني المباشر', style: AppTextStyle.titleMedium(context)),
//         content: Text(
//           'سيفتح نافذة الدردشة المباشرة مع فريق الدعم الفني. هل تريد المتابعة؟',
//           style: AppTextStyle.bodyMedium(context),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('إلغاء', style: AppTextStyle.bodyMedium(context)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // افتح نافذة الدردشة
//             },
//             child: Text('متابعة', style: AppTextStyle.bodyMedium(context, color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }
