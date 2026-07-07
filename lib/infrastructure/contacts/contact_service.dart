import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactService {
  static Future<String?> createContact(Anomaly anomaly) async {
    if (anomaly.phone == null || anomaly.phone!.isEmpty) {
      return null;
    }
    return await FlutterContacts.create(
      Contact(
        name: Name(first: anomaly.nameSearch, last: anomaly.name),
        phones: [Phone(number: anomaly.phone!)],
      ),
    );
  }

  static Future<void> deleteContact(Anomaly anomaly) async {
    if (anomaly.contactId == null || anomaly.contactId!.isEmpty) {
      return;
    }
    await FlutterContacts.delete(anomaly.contactId!);
  }

  static Future<void> updateContact(Anomaly anomaly) async {
    if (anomaly.contactId == null || anomaly.contactId!.isEmpty) {
      return;
    }
    if (anomaly.phone == null || anomaly.phone!.isEmpty) {
      await FlutterContacts.delete(anomaly.contactId!);
    } else {
      await FlutterContacts.update(
        Contact(
          id: anomaly.contactId!,
          name: Name(first: anomaly.nameSearch, last: anomaly.name),
          phones: [Phone(number: anomaly.phone!)],
        ),
      );
    }
  }

  static Future<PermissionStatus> requestPermission() =>
      FlutterContacts.permissions.request(PermissionType.readWrite);
}
