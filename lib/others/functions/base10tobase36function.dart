///print(base10tobase36(base10Number: 4654534545454));
///output "1NE9HOWMM"
String base10tobase36({required int base10Number}) {
  double ontcs = base10Number.toDouble();
  int ct = 36;
  String sonucReverseString = "";
  String sonucString = "";

  List list = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];

  while (ontcs >= ct) {
    double kalan = ontcs % ct;
    ontcs = ontcs - kalan.toInt();
    ontcs = ontcs / ct;
    //sonucReverseString = sonucReverseString + kalan.toString();
    if (kalan < 10) {
      sonucReverseString = sonucReverseString + kalan.toString();
    } else if (kalan >= 10) {
      sonucReverseString = sonucReverseString + list[kalan.toInt() - 10];
    }
  }

  if (ontcs < 10) {
    sonucReverseString = sonucReverseString + ontcs.toString();
  } else if (ontcs >= 10) {
    sonucReverseString = sonucReverseString + list[ontcs.toInt() - 10];
  }

  for (int i = sonucReverseString.length - 1; i >= 0; i--) {
    sonucString = sonucString + sonucReverseString[i];
  }

  return sonucString;
}
