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

