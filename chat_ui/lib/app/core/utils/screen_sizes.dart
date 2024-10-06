

bool isDesktop({required double screenWidth}) {
  bool isDesktop = screenWidth >= 700;
  return isDesktop;
}

/// Specifies the Chat Card Width size.
double getCardWidth({required double screenWidth}) {
  double cardWidth = 0;
  if (screenWidth >= 1600) {
    cardWidth = screenWidth / 1.6;
  } else if (screenWidth >= 1400 && screenWidth <= 1600) {
    cardWidth = screenWidth / 1.4;
  } else if (screenWidth >= 1160 && screenWidth <= 1600) {
    cardWidth = screenWidth / 1.1;
  } else if (screenWidth >= 700 && screenWidth <= 1160) {
    cardWidth = screenWidth;
  } else if (screenWidth <= 700) {
    cardWidth = screenWidth;
  }
  return cardWidth;
}