extension StringExtension on String {
  DateTime toDateTime() {
    return DateTime.parse(this);
  }
}

extension DateTimeExtension on DateTime {
  String toFormattedString() {
    String paddedDay = day.toString().padLeft(2, '0');
    String paddedMonth = month.toString().padLeft(2, '0');
    String paddedYear = year.toString();
    String paddedHour = hour.toString().padLeft(2, '0');
    String paddedMinute = minute.toString().padLeft(2, '0');

    return '$paddedDay/$paddedMonth/$paddedYear - $paddedHour:$paddedMinute';
  }

  String when() {
    final now = DateTime.now();
    final difference = now.difference(this);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

extension NumExtension on num {
  String fromTimestamp() {
    return DateTime.fromMillisecondsSinceEpoch(toInt()).toFormattedString();
  }

  String toCurrency() {
    if (this == 0) return '0';

    String formattedNumber;

    if (abs() >= 1) {
      formattedNumber =
          toStringAsFixed(2).replaceAll(RegExp(r'(\.0+)|(0+)$'), '');
    } else {
      int decimalPlaces =
          2 + toString().split('.')[1].indexOf(RegExp(r'[1-9]'));
      formattedNumber = toStringAsFixed(decimalPlaces);
    }

    List<String> parts = formattedNumber.split('.');
    RegExp regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    parts[0] =
        parts[0].replaceAllMapped(regExp, (Match match) => '${match[1]},');

    return parts.join('.');
  }

  // String toCurrency() {
  //   if (abs() >= 1000) {
  //     if (toString().contains('.')) {
  //       List<String> parts = toString().split('.');
  //       String integerPart = parts[0];
  //       String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

  //       RegExp regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  //       integerPart =
  //           integerPart.replaceAllMapped(regex, (match) => '${match[1]},');

  //       if (decimalPart.length > 3) {
  //         decimalPart = decimalPart.substring(0, 3);
  //       }

  //       return integerPart + decimalPart;
  //     }
  //   }
  //   return toString();
  // }

  String toCurrencyString() {
    if (this >= 1000000000000) {
      return '${(this / 1000000000000).toStringAsFixed(1)}T';
    } else if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1)}B';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    } else {
      return toStringAsFixed(2);
    }
  }
}

extension PriceFormatter on double {
  String formatCoinPrice() {
    int decimalPlaces;
    if (this >= 1) {
      decimalPlaces = 2;
    } else {
      decimalPlaces = 2;
      double temp = this;
      while (temp < 1) {
        temp *= 10;
        decimalPlaces++;
      }
      decimalPlaces = decimalPlaces > 8 ? 8 : decimalPlaces;
    }

    String formattedNumber = toStringAsFixed(decimalPlaces);
    formattedNumber =
        formattedNumber.replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');

    formattedNumber = double.parse(formattedNumber).toCurrency();

    return formattedNumber;
  }
}
