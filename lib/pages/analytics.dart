import 'package:firebase_analytics/firebase_analytics.dart';

class MyAnalyticsHelper {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> logLogin() async {
    await analytics.logLogin(loginMethod: 'login');
    print('logLogin succeeded');
  }

  Future<void> logSignUp() async {
    await analytics.logSignUp(signUpMethod: 'register');
    print('logSignUp succeeded');
  }

  Future<void> logScreenView(_value) async {
    await analytics.logScreenView(
      screenName: '$_value',
    );
    print('logScreenView $_value succeeded');
  }

  Future<void> logReviewEvent(_value, _user, _rate, _comment) async {
    await analytics.logEvent(name: '$_value', parameters: <String, dynamic>{
      'username' : '$_user',
      'rate' : '$_rate',
      'reviews' : '$_comment'
    },);
    print('logReviewEvent succeeded');
  }

  Future<void> logDownloadEvent(_value, _user, _book) async {
    await analytics.logEvent(name: '$_value', parameters: <String, dynamic>{
      'username' : '$_user',
      'novel' : '$_book'
    });
    print('logDownloadEvent succeeded');
  }
}