extension StringExtension on String {
  DateTime toDateTime() {
    return DateTime.parse(this);
  }
}

extension DateTimeExtension on DateTime {
  String toFormattedString() {
    return '$day/$month/$year - $hour:$minute';
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
    formattedNumber = formattedNumber.replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');

    return formattedNumber;
  }
}


