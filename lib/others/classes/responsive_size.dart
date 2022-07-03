import 'package:flutter/material.dart';

class ResponsiveSize {
  ///on boarding screen title size
  // ignore: non_constant_identifier_names
  double ob1(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 400) {
      return 20;
    } else {
      return 24;
    }
  }

  double ob2(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 400) {
      return 10;
    } else {
      return 30;
    }
  }

  double ob3(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 400) {
      return 13;
    } else if (480 > screenWidth && screenWidth > 400) {
      return 15;
    } else {
      return 15;
    }
  }

  double gs1(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 480) {
      return 16;
    } else if (720 > screenWidth && screenWidth > 480) {
      return 17;
    } else {
      return 18;
    }
  }

  double gs2(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 480) {
      return 18;
    } else if (720 > screenWidth && screenWidth > 480) {
      return 19;
    } else {
      return 20;
    }
  }

  double ns1(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 480) {
      return 18;
    } else if (720 > screenWidth && screenWidth > 480) {
      return 20;
    } else {
      return 22;
    }
  }

  double fs1(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 280) {
      return 15;
    } else if (320 > screenWidth && screenWidth > 280) {
      return 16;
    } else if (375 > screenWidth && screenWidth >= 320) {
      return 17;
    } else if (425 > screenWidth && screenWidth >= 375) {
      return 18;
    } else if (425 >= screenWidth) {
      return 19;
    } else {
      return 19;
    }
  }

  double fs2(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 280) {
      return 15;
    } else if (320 > screenWidth && screenWidth > 280) {
      return 16;
    } else if (375 > screenWidth && screenWidth >= 320) {
      return 17;
    } else if (425 > screenWidth && screenWidth >= 375) {
      return 18;
    } else if (425 >= screenWidth) {
      return 19;
    } else {
      return 19;
    }
  }

  double fs3(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 280) {
      return 18;
    } else if (320 > screenWidth && screenWidth > 280) {
      return 20;
    } else if (375 > screenWidth && screenWidth >= 320) {
      return 22;
    } else if (425 > screenWidth && screenWidth >= 375) {
      return 24;
    } else if (425 >= screenWidth) {
      return 26;
    } else {
      return 28;
    }
  }

  double fs4(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 280) {
      return 16;
    } else if (320 > screenWidth && screenWidth > 280) {
      return 17;
    } else if (375 > screenWidth && screenWidth >= 320) {
      return 18;
    } else if (425 > screenWidth && screenWidth >= 375) {
      return 19;
    } else if (425 >= screenWidth) {
      return 20;
    } else {
      return 20;
    }
  }

  double fs5(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 280) {
      return 15;
    } else if (320 > screenWidth && screenWidth > 280) {
      return 15;
    } else if (375 > screenWidth && screenWidth >= 320) {
      return 16;
    } else if (425 > screenWidth && screenWidth >= 375) {
      return 17;
    } else if (425 >= screenWidth) {
      return 18;
    } else {
      return 18;
    }
  }
}
