String? cvvValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your card CVV';
  }
  final regex = RegExp(r'^[0-9]{3,4}$');
  if (!regex.hasMatch(value)) {
    return 'Invalid CVV';
  }
  return null;
}

String? cardExpiryDateValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your card expiry date (MM/YY)';
  }
  final regex = RegExp(r'^\d{2}/\d{2}$');
  if (!regex.hasMatch(value)) {
    return 'Invalid expiry date format (MM/YY)';
  }
  final parts = value.split('/');
  final month = int.tryParse(parts[0]) ?? 0;
  final year = int.tryParse(parts[1]) ?? 0;
  if (month < 1 || month > 12) {
    return 'Invalid month in expiry date';
  }
  final currentYear = DateTime.now().year;
  final currentMonth = DateTime.now().month;
  final cardYear = 2000 + year;
  if (cardYear < currentYear ||
      (cardYear == currentYear && month < currentMonth)) {
    return 'Card has expired';
  }
  return null;
}
