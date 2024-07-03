import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  final Icon? leading;
  final String? title;
  final String? subTitle;
  final Icon? trailing;

  const ProfileListTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subTitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: leading,
      title: Text(
        '$title',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text('$subTitle'),
      trailing: trailing,
    );
  }
}
