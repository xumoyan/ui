class Utils {
  static dynamic getParams(Map<String, dynamic> map) {
    if (map != null) {
      final Map<String, dynamic> arguments = Map<String, dynamic>.from(map);
      return arguments['params'];
    }
    return null;
  }

  static String getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return 'packages/polkawallet_ui/assets/images/usd.png';
      case 'CNY':
        return 'packages/polkawallet_ui/assets/images/cny.png';
      case 'EUR':
        return 'packages/polkawallet_ui/assets/images/eur.png';
      case 'JPY':
        return 'packages/polkawallet_ui/assets/images/jpy.png';
      case 'HKD':
        return 'packages/polkawallet_ui/assets/images/hkd.png';
      default:
        return 'packages/polkawallet_ui/assets/images/cny.png';
    }
  }

  static String getCoinSymbol(String coin) {
    switch (coin.toUpperCase()) {
      case 'DOT':
        return 'packages/polkawallet_ui/assets/images/coin_dot.png';
      case 'KSM':
        return 'packages/polkawallet_ui/assets/images/coin_ksm.png';
      default:
        return 'packages/polkawallet_ui/assets/images/coin_dot.png';
    }
  }
}
