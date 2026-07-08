import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> openWhatsApp(Anomaly anomaly) async {
    if (anomaly.phone == null || anomaly.phone!.isEmpty) {
      return;
    }
    final phone = anomaly.phone!.replaceAll(RegExp(r'[^\d]'), '');
    final url = Uri.parse('https://wa.me/$phone?text=');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw StateError("Could not open WhatsApp");
    }
  }
}
