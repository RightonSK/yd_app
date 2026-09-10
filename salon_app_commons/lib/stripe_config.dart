import 'salon_app_commons.dart';

class StripeConfig {
  static String get publishableKey {
    if (flavor == 'prod') {
      return 'pk_live_lqzDM5POMEEXeWTVXUVgzDY800NQJ4IPDM';
    } else if (flavor == 'stg') {
      return 'pk_test_oZ4fiIoLsEdbjAByLQ2JF3b700QTV1Ac8o';
    } else {
      return 'pk_test_51H3eOmAMoVLSjIeB3zdVaCcmMggQ365G7X4vS1Ycb285Q1LQvg7UEye0YuACMdI8YMUrjW7cL8lHjXyuvQVX2Fua00LjBEzsIA';
    }
  }
}
