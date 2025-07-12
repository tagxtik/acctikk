// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Choose Your Language`
  String get selectLang {
    return Intl.message(
      'Choose Your Language',
      name: 'selectLang',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Type Your Email Address`
  String get typeEmail {
    return Intl.message(
      'Type Your Email Address',
      name: 'typeEmail',
      desc: '',
      args: [],
    );
  }

  /// `Type Your Password`
  String get typePassword {
    return Intl.message(
      'Type Your Password',
      name: 'typePassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Remember me !`
  String get remMe {
    return Intl.message(
      'Remember me !',
      name: 'remMe',
      desc: '',
      args: [],
    );
  }

  /// `Main Home`
  String get main {
    return Intl.message(
      'Main Home',
      name: 'main',
      desc: '',
      args: [],
    );
  }

  /// `Type Your Username`
  String get usernameType {
    return Intl.message(
      'Type Your Username',
      name: 'usernameType',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Add Photo`
  String get addPhoto {
    return Intl.message(
      'Add Photo',
      name: 'addPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Remove Photo`
  String get removePhoto {
    return Intl.message(
      'Remove Photo',
      name: 'removePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Add User`
  String get adduser {
    return Intl.message(
      'Add User',
      name: 'adduser',
      desc: '',
      args: [],
    );
  }

  /// `Current Users`
  String get currentUsers {
    return Intl.message(
      'Current Users',
      name: 'currentUsers',
      desc: '',
      args: [],
    );
  }

  /// `Required Field`
  String get requiredField {
    return Intl.message(
      'Required Field',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `National ID`
  String get natid {
    return Intl.message(
      'National ID',
      name: 'natid',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get fname {
    return Intl.message(
      'First Name',
      name: 'fname',
      desc: '',
      args: [],
    );
  }

  /// `last Name`
  String get lname {
    return Intl.message(
      'last Name',
      name: 'lname',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get phone {
    return Intl.message(
      'Mobile',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Attachments`
  String get attatch {
    return Intl.message(
      'Attachments',
      name: 'attatch',
      desc: '',
      args: [],
    );
  }

  /// `Add Attachments`
  String get addattatch {
    return Intl.message(
      'Add Attachments',
      name: 'addattatch',
      desc: '',
      args: [],
    );
  }

  /// `Choose Max 9 Photos`
  String get attatchLimit {
    return Intl.message(
      'Choose Max 9 Photos',
      name: 'attatchLimit',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get addService {
    return Intl.message(
      '',
      name: 'addService',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get serviceCode {
    return Intl.message(
      '',
      name: 'serviceCode',
      desc: '',
      args: [],
    );
  }

  /// `Items`
  String get items {
    return Intl.message(
      'Items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Packages`
  String get packages {
    return Intl.message(
      'Packages',
      name: 'packages',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Clients`
  String get clients {
    return Intl.message(
      'Clients',
      name: 'clients',
      desc: '',
      args: [],
    );
  }

  /// `Suppliers`
  String get suppliers {
    return Intl.message(
      'Suppliers',
      name: 'suppliers',
      desc: '',
      args: [],
    );
  }

  /// `Accounts`
  String get accounts {
    return Intl.message(
      'Accounts',
      name: 'accounts',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
