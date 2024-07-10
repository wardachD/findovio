import 'package:animated_introduction/animated_introduction.dart';

final List<SingleIntroScreen> pages = [
  const SingleIntroScreen(
    imageWithBubble: false,
    title: 'Znajdź salony',
    description:
        "Odkryj świat nowych fryzur i relaksu. Znajdź idealne miejsce do odświeżenia!",
    imageAsset: 'assets/images/intro1.png',
  ),
  const SingleIntroScreen(
    imageWithBubble: false,
    title: 'Rezerwuj usługi',
    description:
        "Twoje poszukiwania salonu tak łatwe jak przeglądanie menu kawiarni.",
    imageAsset: 'assets/images/intro2.png',
  ),
  const SingleIntroScreen(
    imageWithBubble: false,
    title: 'Zarejestruj się',
    description:
        'Zarejestruj się i otwórz drzwi do wyjątkowych ofert, zniżek i bonusów.',
    imageAsset: 'assets/images/intro3.png',
  ),
];
