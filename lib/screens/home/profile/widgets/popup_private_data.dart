import 'package:findovio/eula/privacy_screen.dart';
import 'package:findovio/screens/home/profile/widgets/Address_bottom_sheet.dart';
import 'package:findovio/screens/home/profile/widgets/faq_bottom_sheet.dart';
import 'package:findovio/screens/home/profile/widgets/favorite_bottom_sheet.dart';
import 'package:findovio/screens/home/profile/widgets/password_change_bottom_sheet.dart';
import 'package:findovio/screens/home/profile/widgets/personal_info_bottom_sheet.dart';
import 'package:flutter/material.dart';

void showUserProfileOptions(BuildContext context, String optionText) {
  showModalBottomSheet(
    showDragHandle: true,
    barrierColor: const Color.fromARGB(214, 0, 0, 0),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            switch (optionText) {
              case 'Dane osobiste':
                return const PersonalInfoBottomSheet();
              case 'Ulubione':
                return const FavoriteBottomSheet();
              case 'Zmień hasło':
                return const PasswordChangeBottomSheet();
              case 'FAQ':
                return const FaqBottomSheet();
              case 'Powiadomienia':
                return const PasswordChangeBottomSheet();
              case 'Polityka prywatności':
                return const PrivacyPolicyPage(
                    policyType: "polityka_prywatności");
              case 'Regulamin':
                return const PrivacyPolicyPage(policyType: "regulamin");
              case 'Mój adres':
                return const AddressBottomSheet();
              default:
                return Container(); // Return an empty container or default widget
            }
          },
        ),
      );
    },
  );
}
