import 'package:findovio/consts.dart';
import 'package:findovio/providers/discover_page_filters.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class GenderChooseWidget extends StatefulWidget {
  final String? customTitle;
  final String? customSelection;
  final VoidCallbackAction? callbackForSettingPersonalGender;
  const GenderChooseWidget(
      {super.key,
      this.customTitle,
      this.customSelection,
      this.callbackForSettingPersonalGender});

  @override
  State<GenderChooseWidget> createState() => _GenderChooseWidgetState();
}

class _GenderChooseWidgetState extends State<GenderChooseWidget> {
  String selectedGender = ''; // Zmienna do przechowywania wybranego gender.
  String titleText = 'dla kogo';
  double customHorizontalMargin = 16;

  @override
  void initState() {
    super.initState();
    final userDataProvider =
        Provider.of<DiscoverPageFilterProvider>(context, listen: false);

    // Sprawdź, czy userData zawiera informację o wybranym gender.
    if (userDataProvider.userData.gender == 'Damsk' ||
        userDataProvider.userData.gender == 'woman' ||
        userDataProvider.userData.gender == 'both') {
      selectedGender = userDataProvider.userData.gender;
    }
  }

  String selectGender(String gender) {
    if (selectedGender == gender) {
      // Jeśli już jest wybrany, odznacz go.
      selectedGender = '';
    } else {
      selectedGender = gender;
    }
    final userDataProvider =
        Provider.of<DiscoverPageFilterProvider>(context, listen: false);
    userDataProvider.setForWhom(selectedGender);
    return selectedGender;
  }

  @override
  Widget build(BuildContext context) {
    final userPersonalDataProvider =
        Provider.of<FirebasePyUserProvider>(context, listen: false);
    if (widget.customTitle != null && widget.customTitle != '') {
      titleText = widget.customTitle!;
      customHorizontalMargin = 0;

      if (userPersonalDataProvider.user!.userGender != null) {
        selectedGender = userPersonalDataProvider.user!.userGender!;
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: customHorizontalMargin, vertical: 4.0),
      child: Form(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: Text(titleText,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            ConstsWidgets.gapH8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildGenderContainer('woman', MdiIcons.genderFemale),
                _buildGenderContainer('man', MdiIcons.genderMale),
                if (titleText == 'dla kogo')
                  _buildGenderContainer('both', MdiIcons.genderMaleFemale),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderContainer(String gender, IconData iconData) {
    final userDataProvider = Provider.of<DiscoverPageFilterProvider>(context);
    final userPersonalDataProvider =
        Provider.of<FirebasePyUserProvider>(context, listen: false);
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        if (widget.customTitle == null) {
          userDataProvider.setForWhom(selectGender(gender));
        } else {
          userPersonalDataProvider.user!.userGender = gender;
          userPersonalDataProvider.update();
          setState(() {
            selectedGender = gender;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Colors.white
              : const Color.fromARGB(255, 243, 243, 243),
          boxShadow: [
            BoxShadow(
              color: Colors.orange,
              offset: isSelected ? const Offset(0, 1) : const Offset(0, 0),
            ),
          ],
        ),
        width: 70,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: isSelected ? Colors.orange : Colors.black),
          ],
        ),
      ),
    );
  }
}
