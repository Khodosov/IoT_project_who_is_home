import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_home/pages/sign_up.dart';

void main() {
  // В соответсвии с ТЗ проверим форму для ввода почты вводя следующие строки:
  final String incorrectMailWithoutAt = 'testmail.ru';
  final String incorrectgMailWithoutDot = 'test@mailru';
  final String incorrectMailWithoutTextAfterAt = 'test@';
  final String incorrectMailWithoutTextAfterDot = 'test@mail.';
  final String incorrectMailWithNoSymbols = '';
  final String incorrectMailWithoutSymbolsBeforeAt = '@mail.ru';
  final String incorrectMailWithoutSymbolsBeforeDot = '.ru';
  final String correctMailSPBU = 'st068705@student.spbu.ru';
  final String correctMail = 'test@gmail.com';

  // В соответсвии с ТЗ проверим форму для ввода пароля вводя следующие строки:
  final String incorrectPasswordWithNoSymbols = '';
  final String incorrectPasswordToShort = 't';
  final String correctPassword = 'TESTtest';
  final String oneMoreCorrectPassword = 'TESTtest1';

  // В соответсвии с ТЗ проверим форму для ввода номера устройства вводя
  // следующие строки:
  final String correctNumber = '777';
  final String oneMoreCorrectNumber = '1';
  final String incorrectNumberWithNoSymbols = '';
  final String incorrectNumberIncludingLetters = '77a';
  final String incorrectNumberWithOnlyLetters = 'test';



}