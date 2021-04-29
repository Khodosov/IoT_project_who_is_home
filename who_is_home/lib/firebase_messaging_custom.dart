import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import


class FirebaseMessagingServiceProvider {
  static FirebaseMessagingServiceProvider _instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging();
  static String fcmToken;
  factory FirebaseMessagingServiceProvider() =>
      _instance ??= FirebaseMessagingServiceProvider()._();

  FirebaseMessagingServiceProvider()._() {
    _messaging.configure(
      onMessage: _onMessageMessageHandler,
      onResume: _onResumeOnLauncMessageMessageHandler,
      onLaunch: _onResumeOnLauncMessageMessageHandler,
      onBackgroundMessage: Platform.isIOS ? null : _onBackgroundMessageHandler,
    );

    if (Platform.isIOS) {
      _messaging.requestNotificationPermissions();
    }

    _messaging.getToken()
  }

}