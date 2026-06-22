import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['zh_Hant', 'th', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? zh_HantText = '',
    String? thText = '',
    String? enText = '',
  }) =>
      [zh_HantText, thText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    '5bnmpul0': {
      'zh_Hant': 'N P U S T',
      'en': 'N P U S T',
      'th': 'N P U S T',
    },
    'q4cw4s55': {
      'zh_Hant': 'Home',
      'en': 'Home',
      'th': 'Home',
    },
  },
  // main
  {
    'ae07q469': {
      'zh_Hant': '選單',
      'en': '',
      'th': '',
    },
    'ixwx5ry9': {
      'zh_Hant': '場域：',
      'en': '',
      'th': '',
    },
    'jnz3uat5': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'o0s2bex9': {
      'zh_Hant': 'Search...',
      'en': '',
      'th': '',
    },
    't9djzgv0': {
      'zh_Hant': '系統設定',
      'en': 'setting',
      'th': '',
    },
    'kgck7334': {
      'zh_Hant': '即時監看',
      'en': '',
      'th': '',
    },
    'ndmkfvk7': {
      'zh_Hant': '裝置控制',
      'en': '',
      'th': '',
    },
    'gnkaytf3': {
      'zh_Hant': '查詢歷史',
      'en': '',
      'th': '',
    },
    '27htf27u': {
      'zh_Hant': '電視牆',
      'en': '',
      'th': '',
    },
    'an9547s2': {
      'zh_Hant': 'Home',
      'en': '',
      'th': '',
    },
  },
  // set_page
  {
    'somemuiq': {
      'zh_Hant': '系統設定',
      'en': '',
      'th': '',
    },
    '78iufz79': {
      'zh_Hant': '飼料桶編號：',
      'en': '',
      'th': '',
    },
    '4h0amtdw': {
      'zh_Hant': 'Search for an item...',
      'en': '',
      'th': '',
    },
    '929537p5': {
      'zh_Hant': '飼料桶高度：',
      'en': '',
      'th': '',
    },
    'jlqtb4vb': {
      'zh_Hant': 'cm',
      'en': '',
      'th': '',
    },
    'k1by14za': {
      'zh_Hant': '滿桶通報：',
      'en': '',
      'th': '',
    },
    '99pgpvuu': {
      'zh_Hant': 'cm',
      'en': '',
      'th': '',
    },
    'fc1n6wx4': {
      'zh_Hant': '缺料通報：',
      'en': '',
      'th': '',
    },
    'tzvuqfri': {
      'zh_Hant': 'cm',
      'en': '',
      'th': '',
    },
    '1qvki5dz': {
      'zh_Hant': '數據傳送間隔：',
      'en': '',
      'th': '',
    },
    'wbp95w8j': {
      'zh_Hant': 'min',
      'en': '',
      'th': '',
    },
    'gv03gx5v': {
      'zh_Hant': '保鮮期限：',
      'en': '',
      'th': '',
    },
    'orbb10qd': {
      'zh_Hant': 'day',
      'en': '',
      'th': '',
    },
    'lchlfcvd': {
      'zh_Hant': '餵食噸數：',
      'en': '',
      'th': '',
    },
    '4aus2atr': {
      'zh_Hant': 'ton',
      'en': '',
      'th': '',
    },
    'aie8u2qf': {
      'zh_Hant': '飼料密度：',
      'en': '',
      'th': '',
    },
    '5t9anphn': {
      'zh_Hant': 'kg/L',
      'en': '',
      'th': '',
    },
    'q6a89eu8': {
      'zh_Hant': '溫度範圍：',
      'en': '',
      'th': '',
    },
    's7dav4fh': {
      'zh_Hant': '~',
      'en': '',
      'th': '',
    },
    'rtxg06jv': {
      'zh_Hant': '℃',
      'en': '',
      'th': '',
    },
    '8el42y5y': {
      'zh_Hant': '濕度範圍：',
      'en': '',
      'th': '',
    },
    'v2jicy7a': {
      'zh_Hant': '~',
      'en': '',
      'th': '',
    },
    '4nx1hhqg': {
      'zh_Hant': '%',
      'en': '',
      'th': '',
    },
    'lw1ey7bs': {
      'zh_Hant': '儲存',
      'en': '',
      'th': '',
    },
    'srmrwvjt': {
      'zh_Hant': 'Home',
      'en': '',
      'th': '',
    },
  },
  // map_page
  {
    'i6618z1s': {
      'zh_Hant': '即時監看',
      'en': '',
      'th': '',
    },
    '77h75ps7': {
      'zh_Hant': 'Home',
      'en': '',
      'th': '',
    },
  },
  // controller_page
  {
    'h42y3b7a': {
      'zh_Hant': '裝置控制',
      'en': '',
      'th': '',
    },
    't5jz1zix': {
      'zh_Hant': '     ',
      'en': '',
      'th': '',
    },
    'w07wb1ah': {
      'zh_Hant': '飼料桶編號：',
      'en': '',
      'th': '',
    },
    'wlu03r3x': {
      'zh_Hant': 'Search for an item...',
      'en': '',
      'th': '',
    },
    'z0iagl65': {
      'zh_Hant': '基本控制',
      'en': '',
      'th': '',
    },
    'xtgqak6u': {
      'zh_Hant': '影像電源',
      'en': '',
      'th': '',
    },
    'to3n8acg': {
      'zh_Hant': '卸料閥門',
      'en': '',
      'th': '',
    },
    '8p4xcjlo': {
      'zh_Hant': '溫度：',
      'en': '',
      'th': '',
    },
    'vrp13i6i': {
      'zh_Hant': '濕度：',
      'en': '',
      'th': '',
    },
    'ldsysd41': {
      'zh_Hant': '高度：',
      'en': '',
      'th': '',
    },
    '6mxkounv': {
      'zh_Hant': '最近一次送料重量：',
      'en': '',
      'th': '',
    },
    'kmj3kjdc': {
      'zh_Hant': '餵飼重量：',
      'en': '',
      'th': '',
    },
    '3twcas9t': {
      'zh_Hant': '℃',
      'en': '',
      'th': '',
    },
    'ddb0h5rn': {
      'zh_Hant': '%',
      'en': '',
      'th': '',
    },
    'c6j0eeiy': {
      'zh_Hant': 'cm',
      'en': '',
      'th': '',
    },
    'pscjxlm7': {
      'zh_Hant': 'kg',
      'en': '',
      'th': '',
    },
    'x7yte07k': {
      'zh_Hant': 'kg',
      'en': '',
      'th': '',
    },
    '87v6793a': {
      'zh_Hant': '氣閥控制',
      'en': '',
      'th': '',
    },
    'p9fc4c1d': {
      'zh_Hant': '單顆輪流啟動',
      'en': '',
      'th': '',
    },
    '0wfe5dob': {
      'zh_Hant': '兩顆輪流啟動',
      'en': '',
      'th': '',
    },
    '7li87k9f': {
      'zh_Hant': '三顆輪流啟動',
      'en': '',
      'th': '',
    },
    '4niie82z': {
      'zh_Hant': '六顆輪流啟動',
      'en': '',
      'th': '',
    },
    'vrlrqgz5': {
      'zh_Hant': '1號',
      'en': '',
      'th': '',
    },
    'u6qeabo2': {
      'zh_Hant': '2號',
      'en': '',
      'th': '',
    },
    'j1falsg0': {
      'zh_Hant': '3號',
      'en': '',
      'th': '',
    },
    'e365e3rl': {
      'zh_Hant': '4號',
      'en': '',
      'th': '',
    },
    'p3y8f2ok': {
      'zh_Hant': '5號',
      'en': '',
      'th': '',
    },
    'uqunagv8': {
      'zh_Hant': '6號',
      'en': '',
      'th': '',
    },
    'vs03adx2': {
      'zh_Hant': '自動模式',
      'en': '',
      'th': '',
    },
    'jnuo8nbb': {
      'zh_Hant': '氣閥關閉',
      'en': '',
      'th': '',
    },
    'vnue36fz': {
      'zh_Hant': 'Home',
      'en': '',
      'th': '',
    },
  },
  // select_page
  {
    'vicctcfs': {
      'zh_Hant': '查詢歷史',
      'en': '',
      'th': '',
    },
    'mz4du82z': {
      'zh_Hant': '飼料桶編號：',
      'en': '',
      'th': '',
    },
    'nh2pdkyr': {
      'zh_Hant': 'Search for an item...',
      'en': '',
      'th': '',
    },
    '26ed71zw': {
      'zh_Hant': '~',
      'en': '',
      'th': '',
    },
    'qcsqvlue': {
      'zh_Hant': '剩料',
      'en': '',
      'th': '',
    },
    'xzku90kg': {
      'zh_Hant': '訊息',
      'en': '',
      'th': '',
    },
    't0pfler7': {
      'zh_Hant': '剩料',
      'en': '',
      'th': '',
    },
    'aa8pu6ep': {
      'zh_Hant': '搜尋',
      'en': '',
      'th': '',
    },
    'y8kf56vd': {
      'zh_Hant': '餵食次數：',
      'en': '',
      'th': '',
    },
    'al5q4noz': {
      'zh_Hant': '餵食頓數：',
      'en': '',
      'th': '',
    },
    'a5qnj3jj': {
      'zh_Hant': '查無訊息!',
      'en': '',
      'th': '',
    },
    'bitom3if': {
      'zh_Hant': 'Home',
      'en': '',
      'th': '',
    },
  },
  // login
  {
    's6nsfxxe': {
      'zh_Hant': '登入',
      'en': '',
      'th': '',
    },
    'sycmastu': {
      'zh_Hant': '帳號',
      'en': '',
      'th': '',
    },
    'mh2ngkrh': {
      'zh_Hant': '密碼',
      'en': '',
      'th': '',
    },
    'xttal02t': {
      'zh_Hant': '自動填寫',
      'en': '',
      'th': '',
    },
    'p1joskdg': {
      'zh_Hant': 'Sign In',
      'en': '',
      'th': '',
    },
    'e9hnxe7r': {
      'zh_Hant': '註冊!!!',
      'en': '',
      'th': '',
    },
    'tdpvufed': {
      'zh_Hant': 'Home',
      'en': '',
      'th': '',
    },
  },
  // TV
  {
    'zboxhg9k': {
      'zh_Hant': 'Page Title',
      'en': '',
      'th': '',
    },
    'quxdeh1c': {
      'zh_Hant': 'Location #1',
      'en': '',
      'th': '',
    },
    'jrovyyqp': {
      'zh_Hant': '   PH值 :',
      'en': '',
      'th': '',
    },
    'ux31nkf2': {
      'zh_Hant': '12.7',
      'en': '',
      'th': '',
    },
    'z4w5vspw': {
      'zh_Hant': 'ph      ',
      'en': '',
      'th': '',
    },
    'rjax1k0d': {
      'zh_Hant': '  溫度 :',
      'en': '',
      'th': '',
    },
    '4fdbqsiu': {
      'zh_Hant': '29.4',
      'en': '',
      'th': '',
    },
    '4yqrot2b': {
      'zh_Hant': '˚C      ',
      'en': '',
      'th': '',
    },
    '2meecbmx': {
      'zh_Hant': ' 溶氧度 :',
      'en': '',
      'th': '',
    },
    'm6prurmm': {
      'zh_Hant': '5.28',
      'en': '',
      'th': '',
    },
    'iaccu9xl': {
      'zh_Hant': 'ppm  ',
      'en': '',
      'th': '',
    },
    'x1a987td': {
      'zh_Hant': '   濁度 :',
      'en': '',
      'th': '',
    },
    'bjggm6f7': {
      'zh_Hant': '0',
      'en': '',
      'th': '',
    },
    'd2ntov5x': {
      'zh_Hant': 'NTU     ',
      'en': '',
      'th': '',
    },
    'ia58vupf': {
      'zh_Hant': '電導度 :',
      'en': '',
      'th': '',
    },
    '5rtbjxd2': {
      'zh_Hant': '0.058',
      'en': '',
      'th': '',
    },
    'wlagvetk': {
      'zh_Hant': 'mS/cm',
      'en': '',
      'th': '',
    },
    '9l67r0pu': {
      'zh_Hant': 'Location #2',
      'en': '',
      'th': '',
    },
    'itaeg5np': {
      'zh_Hant': '   PH值 :',
      'en': '',
      'th': '',
    },
    'j6sv18kj': {
      'zh_Hant': '12.1',
      'en': '',
      'th': '',
    },
    '3lt95xiv': {
      'zh_Hant': 'ph      ',
      'en': '',
      'th': '',
    },
    'uhj0arti': {
      'zh_Hant': '  溫度 :',
      'en': '',
      'th': '',
    },
    'f6wgblo0': {
      'zh_Hant': '29.6',
      'en': '',
      'th': '',
    },
    'l51a5jya': {
      'zh_Hant': '˚C      ',
      'en': '',
      'th': '',
    },
    '3u5xow8q': {
      'zh_Hant': ' 溶氧度 :',
      'en': '',
      'th': '',
    },
    'f5zhovep': {
      'zh_Hant': '6.05',
      'en': '',
      'th': '',
    },
    'bfpxa9o6': {
      'zh_Hant': 'ppm  ',
      'en': '',
      'th': '',
    },
    'dlhd7zx6': {
      'zh_Hant': '   濁度 :',
      'en': '',
      'th': '',
    },
    'pscyer5u': {
      'zh_Hant': '0',
      'en': '',
      'th': '',
    },
    '4q40y9iq': {
      'zh_Hant': 'NTU     ',
      'en': '',
      'th': '',
    },
    'uhoonvld': {
      'zh_Hant': '電導度 :',
      'en': '',
      'th': '',
    },
    '08gmgvy7': {
      'zh_Hant': '0.073',
      'en': '',
      'th': '',
    },
    'himg7k4y': {
      'zh_Hant': 'mS/cm',
      'en': '',
      'th': '',
    },
    'le5jr25u': {
      'zh_Hant': 'Location #3',
      'en': '',
      'th': '',
    },
    'g0810vg4': {
      'zh_Hant': '   PH值 :',
      'en': '',
      'th': '',
    },
    'gr6m86xx': {
      'zh_Hant': '7.2',
      'en': '',
      'th': '',
    },
    'u5o867er': {
      'zh_Hant': 'ph      ',
      'en': '',
      'th': '',
    },
    '6rk87s8d': {
      'zh_Hant': '  溫度 :',
      'en': '',
      'th': '',
    },
    'gug5s2bu': {
      'zh_Hant': '29.7',
      'en': '',
      'th': '',
    },
    'xl1cqei7': {
      'zh_Hant': '˚C      ',
      'en': '',
      'th': '',
    },
    'yeqprc86': {
      'zh_Hant': ' 溶氧度 :',
      'en': '',
      'th': '',
    },
    'w09hv7ez': {
      'zh_Hant': '4.86',
      'en': '',
      'th': '',
    },
    'nciyc2tz': {
      'zh_Hant': 'ppm  ',
      'en': '',
      'th': '',
    },
    'i9bc0ztb': {
      'zh_Hant': '   濁度 :',
      'en': '',
      'th': '',
    },
    'lfmdjv5j': {
      'zh_Hant': '0',
      'en': '',
      'th': '',
    },
    '9uv2t9ul': {
      'zh_Hant': 'NTU     ',
      'en': '',
      'th': '',
    },
    'wv7mgpdn': {
      'zh_Hant': '電導度 :',
      'en': '',
      'th': '',
    },
    '6ucnc02t': {
      'zh_Hant': '0.044',
      'en': '',
      'th': '',
    },
    'f9bk2qtq': {
      'zh_Hant': 'mS/cm',
      'en': '',
      'th': '',
    },
    'ctxlvc9t': {
      'zh_Hant': 'Location #4',
      'en': '',
      'th': '',
    },
    'zg0uxvp0': {
      'zh_Hant': '   PH值 :',
      'en': '',
      'th': '',
    },
    'yt8h50fd': {
      'zh_Hant': '10',
      'en': '',
      'th': '',
    },
    'kpvaehvd': {
      'zh_Hant': 'ph      ',
      'en': '',
      'th': '',
    },
    '61adpg9h': {
      'zh_Hant': '  溫度 :',
      'en': '',
      'th': '',
    },
    'lfmjxyzz': {
      'zh_Hant': '28.7',
      'en': '',
      'th': '',
    },
    'vutbb6k8': {
      'zh_Hant': '˚C      ',
      'en': '',
      'th': '',
    },
    'alkzd9up': {
      'zh_Hant': ' 溶氧度 :',
      'en': '',
      'th': '',
    },
    'xb9gdosy': {
      'zh_Hant': '5.76',
      'en': '',
      'th': '',
    },
    'jae52ijc': {
      'zh_Hant': 'ppm  ',
      'en': '',
      'th': '',
    },
    'tn4h75yp': {
      'zh_Hant': '   濁度 :',
      'en': '',
      'th': '',
    },
    'x47ffutv': {
      'zh_Hant': '158.5',
      'en': '',
      'th': '',
    },
    'lkrr6yez': {
      'zh_Hant': 'NTU    ',
      'en': '',
      'th': '',
    },
    'd97tvsq7': {
      'zh_Hant': '電導度 :',
      'en': '',
      'th': '',
    },
    'hre9k5cz': {
      'zh_Hant': '0.058',
      'en': '',
      'th': '',
    },
    'hyn9zt91': {
      'zh_Hant': 'mS/cm',
      'en': '',
      'th': '',
    },
    'pevfry38': {
      'zh_Hant': 'Location #5',
      'en': '',
      'th': '',
    },
    'akmudj0h': {
      'zh_Hant': '   PH值 :',
      'en': '',
      'th': '',
    },
    'ohzqxwjf': {
      'zh_Hant': '8.9',
      'en': '',
      'th': '',
    },
    'dbzjbhli': {
      'zh_Hant': 'ph      ',
      'en': '',
      'th': '',
    },
    'nhindw8b': {
      'zh_Hant': '  溫度 :',
      'en': '',
      'th': '',
    },
    'yrv2uq18': {
      'zh_Hant': '29.6',
      'en': '',
      'th': '',
    },
    '02h1fl6x': {
      'zh_Hant': '˚C      ',
      'en': '',
      'th': '',
    },
    'qmuure1f': {
      'zh_Hant': ' 溶氧度 :',
      'en': '',
      'th': '',
    },
    'lbuwi6l6': {
      'zh_Hant': '5.96',
      'en': '',
      'th': '',
    },
    'toae9ygv': {
      'zh_Hant': 'ppm  ',
      'en': '',
      'th': '',
    },
    'vpkxhyxg': {
      'zh_Hant': '   濁度 :',
      'en': '',
      'th': '',
    },
    'lxay8pl5': {
      'zh_Hant': '76.8',
      'en': '',
      'th': '',
    },
    'vzzk5h15': {
      'zh_Hant': 'NTU     ',
      'en': '',
      'th': '',
    },
    'cqyavpx2': {
      'zh_Hant': '電導度 :',
      'en': '',
      'th': '',
    },
    '046gua8p': {
      'zh_Hant': '0.044',
      'en': '',
      'th': '',
    },
    'tzvzv8q3': {
      'zh_Hant': 'mS/cm',
      'en': '',
      'th': '',
    },
    '8lnvtyv2': {
      'zh_Hant': 'Location #6',
      'en': '',
      'th': '',
    },
    'e68y40cn': {
      'zh_Hant': '   PH值 :',
      'en': '',
      'th': '',
    },
    'eez3w3vh': {
      'zh_Hant': '6.3',
      'en': '',
      'th': '',
    },
    'xhhyas9h': {
      'zh_Hant': 'ph      ',
      'en': '',
      'th': '',
    },
    '0laceq3s': {
      'zh_Hant': '  溫度 :',
      'en': '',
      'th': '',
    },
    'mtpmabxg': {
      'zh_Hant': '30',
      'en': '',
      'th': '',
    },
    '8wauvlcr': {
      'zh_Hant': '˚C      ',
      'en': '',
      'th': '',
    },
    'hif4ntr0': {
      'zh_Hant': ' 溶氧度 :',
      'en': '',
      'th': '',
    },
    'km1balkl': {
      'zh_Hant': '5.37',
      'en': '',
      'th': '',
    },
    'algmkugw': {
      'zh_Hant': 'ppm  ',
      'en': '',
      'th': '',
    },
    'icm7wprc': {
      'zh_Hant': '   濁度 :',
      'en': '',
      'th': '',
    },
    '47qrwmim': {
      'zh_Hant': '0',
      'en': '',
      'th': '',
    },
    'tabu350f': {
      'zh_Hant': 'NTU     ',
      'en': '',
      'th': '',
    },
    'e80ca9fr': {
      'zh_Hant': '電導度 :',
      'en': '',
      'th': '',
    },
    'uvdpa8cx': {
      'zh_Hant': '0.102',
      'en': '',
      'th': '',
    },
    '4zs5w2js': {
      'zh_Hant': 'mS/cm',
      'en': '',
      'th': '',
    },
    'pcwo8weg': {
      'zh_Hant': 'Home',
      'en': 'Home',
      'th': 'Home',
    },
  },
  // date
  {
    'yd92ugyh': {
      'zh_Hant': '年',
      'en': '',
      'th': '',
    },
    '96vxhf4o': {
      'zh_Hant': '月',
      'en': '',
      'th': '',
    },
    'bfcfddcw': {
      'zh_Hant': '日',
      'en': '',
      'th': '',
    },
    'zkrrixcp': {
      'zh_Hant': '確定',
      'en': '',
      'th': '',
    },
  },
  // LoginWarning
  {
    'fj2ficvq': {
      'zh_Hant': '登入警告',
      'en': '',
      'th': '',
    },
    'bcsi53sx': {
      'zh_Hant': '您輸入的帳號或密碼錯誤，請查確認後再次登入',
      'en': '',
      'th': '',
    },
  },
  // warn
  {
    '9780ralg': {
      'zh_Hant': '飼料不足',
      'en': '',
      'th': '',
    },
    'r2rnyby8': {
      'zh_Hant': '飼料量低於設定參數，請聯絡飼料廠添加!!',
      'en': '',
      'th': '',
    },
    '3885eluv': {
      'zh_Hant': 'Remind me later',
      'en': '',
      'th': '',
    },
    'sboaumhm': {
      'zh_Hant': '關閉',
      'en': '',
      'th': '',
    },
  },
  // Miscellaneous
  {
    'hsles1k1': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'r39a47sa': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'bnig8sx5': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'r7tpbu8c': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    '1o34l391': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'jnxdq84x': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'cmvsvrgs': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    '8v5d9jpb': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    '2z0yoj94': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'g7lq5bto': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'm751vjdh': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    '2amu6716': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'sqw7ipf5': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'ill9lob3': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'uthlls9v': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    '89btp9ls': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'tun9pmcf': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    '13r7do5t': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'xwz60462': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    '8giz4s6d': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'w1c3id1k': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'c7s6h4xx': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'w3lctyhf': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    '7eygevvi': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
    'tyktj0hy': {
      'zh_Hant': '',
      'en': '',
      'th': '',
    },
  },
].reduce((a, b) => a..addAll(b));
