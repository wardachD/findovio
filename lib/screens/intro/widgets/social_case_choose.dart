import 'package:findovio/screens/intro/widgets/social_icon.dart';
import 'package:flutter/material.dart';

class SocialCaseChoose extends StatelessWidget {
  final bool enabledButton;
  const SocialCaseChoose({
    super.key,
    required this.enabledButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SocialIcon(
            socialMediaType: 'google',
            enabled: enabledButton,
          ),
          // SocialIcon(
          //   socialMediaType: 'facebook',
          // ),
          // SocialIcon(
          //   socialMediaType: 'apple',
          // ),
        ],
      ),
    );
  }
}
