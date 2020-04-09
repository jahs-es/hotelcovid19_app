import 'package:hotelcovid19_app/common/platform_alert_dialog.dart';
import 'package:meta/meta.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required String exception,
  }) : super(
    title: title,
    content: exception,
    defaultActionText: 'OK'
  );
}
