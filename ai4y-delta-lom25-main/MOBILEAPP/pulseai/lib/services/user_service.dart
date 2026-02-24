import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required String uid,
    required String username,
    required String email,
    String? weight,
    String? height,
    String? bloodGroup,
    String? allergies,
  }) async {
    try {
      final data = {
        'username': username,
        'email': email,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Only include non-null medical data
      if (weight != null && weight.isNotEmpty) data['weight'] = weight;
      if (height != null && height.isNotEmpty) data['height'] = height;
      if (bloodGroup != null && bloodGroup.isNotEmpty) data['bloodGroup'] = bloodGroup;
      if (allergies != null && allergies.isNotEmpty) data['allergies'] = allergies;

      await _firestore
          .collection('users')
          .doc(uid)
          .set(data, SetOptions(merge: true))
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                  "La sauvegarde prend trop de temps. Vérifiez votre connexion.");
            },
          );
    } catch (e) {
      debugPrint('Error saving user data to Firestore: $e');
      rethrow; // Re-throw to let caller handle
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }
}
