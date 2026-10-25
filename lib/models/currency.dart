enum CurrencySymbolPosition {
  before, // e.g., $100.00
  after, // e.g., 100.00 €
}

class Currency {
  final String code;
  final String symbol;
  final String name;
  final CurrencySymbolPosition position;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    this.position = CurrencySymbolPosition.after,
  });

  /// Formats an amount with currency symbol.
  /// Example: format(100.00) -> "100.00 €" or "$100.00"
  String format(double amount, {int decimals = 2}) {
    final formattedAmount = amount.toStringAsFixed(decimals);
    switch (position) {
      case CurrencySymbolPosition.before:
        return '$symbol$formattedAmount';
      case CurrencySymbolPosition.after:
        return '$formattedAmount $symbol';
    }
  }

  /// Formats an amount as monthly cost.
  /// Example: formatMonthly(10.00) -> "10.00 € / mo" or "10.00 €/mo"
  String formatMonthly(double amount, {int decimals = 2, bool compact = false}) {
    final formatted = format(amount, decimals: decimals);
    return compact ? '$formatted/mo' : '$formatted / mo';
  }

  String get displayName => '$name ($symbol)';

  Currency copyWith({
    String? code,
    String? symbol,
    String? name,
    CurrencySymbolPosition? position,
  }) {
    return Currency(
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'symbol': symbol,
      'name': name,
      'position': position.name,
    };
  }

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] as String? ?? 'EUR',
      symbol: json['symbol'] as String? ?? '€',
      name: json['name'] as String? ?? 'Euro',
      position: json['position'] == 'before'
          ? CurrencySymbolPosition.before
          : CurrencySymbolPosition.after,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          symbol == other.symbol &&
          name == other.name &&
          position == other.position;

  @override
  int get hashCode => Object.hash(code, symbol, name, position);

  // Default Presets
  static const Currency euro = Currency(
    code: 'EUR',
    symbol: '€',
    name: 'Euro',
    position: CurrencySymbolPosition.after,
  );

  static const Currency usDollar = Currency(
    code: 'USD',
    symbol: '\$',
    name: 'US Dollar',
    position: CurrencySymbolPosition.before,
  );

  static const Currency britishPound = Currency(
    code: 'GBP',
    symbol: '£',
    name: 'British Pound',
    position: CurrencySymbolPosition.before,
  );

  static const Currency japaneseYen = Currency(
    code: 'JPY',
    symbol: '¥',
    name: 'Japanese Yen',
    position: CurrencySymbolPosition.before,
  );

  static const Currency swissFranc = Currency(
    code: 'CHF',
    symbol: 'CHF',
    name: 'Swiss Franc',
    position: CurrencySymbolPosition.after,
  );

  static const Currency canadianDollar = Currency(
    code: 'CAD',
    symbol: 'CA\$',
    name: 'Canadian Dollar',
    position: CurrencySymbolPosition.before,
  );

  static const Currency australianDollar = Currency(
    code: 'AUD',
    symbol: 'A\$',
    name: 'Australian Dollar',
    position: CurrencySymbolPosition.before,
  );

  static const Currency chineseYuan = Currency(
    code: 'CNY',
    symbol: 'CN¥',
    name: 'Chinese Yuan',
    position: CurrencySymbolPosition.before,
  );

  static const Currency indianRupee = Currency(
    code: 'INR',
    symbol: '₹',
    name: 'Indian Rupee',
    position: CurrencySymbolPosition.before,
  );

  static const Currency brazilianReal = Currency(
    code: 'BRL',
    symbol: 'R\$',
    name: 'Brazilian Real',
    position: CurrencySymbolPosition.before,
  );

  static List<Currency> get presetCurrencies => const [
        euro,
        usDollar,
        britishPound,
        japaneseYen,
        swissFranc,
        canadianDollar,
        australianDollar,
        chineseYuan,
        indianRupee,
        brazilianReal,
      ];
}
