import 'package:flutter/material.dart';

class AppDataRow extends DataRow {
  const AppDataRow({required super.cells, super.onSelectChanged});
}

// DataRow userDataRow(
//   BuildContext context,
//   UserModel user,
// ) {
//   return DataRow(
//     cells: [
//       DataCell(Text(user.id)),
//       DataCell(Text(user.userName)),
//       DataCell(Text(user.email)),
//       DataCell(
//           Text('${user.defaultAddress().no}, ${user.defaultAddress().area}')),
//       DataCell(Text(user.phoneNumber)),
//       DataCell(Text(user.verified ? 'Verified' : 'Not verified')),
//       DataCell(
//         AppSwitch(
//           value: user.active,
//           onTap: (bool val) {
//             user.active = val;
//             locator.get<UserCubit>().updateUser(user);
//           },
//         ),
//       ),
//     ],
//     onSelectChanged: (selected) async {
//       final result = await showDetailedDialog(
//         context,
//         child: UserDetailed(user: user),
//       );
//       if (result != null && result is UserModel) {
//         user = result;
//       }
//     },
//   );
// }