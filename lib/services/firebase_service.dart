import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Auth Methods
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'student',
      });

      await userCredential.user!.updateDisplayName(name);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Student ID Methods
  Future<void> submitStudentIdRequest({
    required String studentName,
    required String rollNumber,
    required String branch,
    required File idProof,
    required String reason,
  }) async {
    try {
      String userId = _auth.currentUser!.uid;
      String fileName =
          'student_ids/$userId/${DateTime.now().millisecondsSinceEpoch}_${idProof.path.split('/').last}';

      // Upload file to Storage
      TaskSnapshot uploadTask = await _storage.ref(fileName).putFile(idProof);
      String downloadUrl = await uploadTask.ref.getDownloadURL();

      // Save request in Firestore
      await _firestore.collection('student_id_requests').add({
        'userId': userId,
        'studentName': studentName,
        'rollNumber': rollNumber,
        'branch': branch,
        'idProofUrl': downloadUrl,
        'reason': reason,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Certificate Methods
  Future<void> submitCertificateRequest({
    required String studentName,
    required String rollNumber,
    required String certificateType,
    required String branch,
    required String year,
  }) async {
    try {
      String userId = _auth.currentUser!.uid;

      await _firestore.collection('certificate_requests').add({
        'userId': userId,
        'studentName': studentName,
        'rollNumber': rollNumber,
        'certificateType': certificateType,
        'branch': branch,
        'year': year,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Project Upload Methods
  Future<void> uploadProject({
    required String projectName,
    required String description,
    required File projectFile,
  }) async {
    try {
      String userId = _auth.currentUser!.uid;
      String fileName =
          'projects/$userId/${DateTime.now().millisecondsSinceEpoch}_${projectFile.path.split('/').last}';

      // Upload file to Storage
      TaskSnapshot uploadTask =
          await _storage.ref(fileName).putFile(projectFile);
      String downloadUrl = await uploadTask.ref.getDownloadURL();

      // Save project in Firestore
      await _firestore.collection('projects').add({
        'userId': userId,
        'projectName': projectName,
        'description': description,
        'fileUrl': downloadUrl,
        'fileName': projectFile.path.split('/').last,
        'uploadedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Profile Methods
  Future<void> updateProfile({
    required String name,
    required String rollNumber,
    File? profilePicture,
  }) async {
    try {
      String userId = _auth.currentUser!.uid;
      Map<String, dynamic> updateData = {
        'name': name,
        'rollNumber': rollNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (profilePicture != null) {
        String fileName =
            'profile_pictures/$userId/${DateTime.now().millisecondsSinceEpoch}_${profilePicture.path.split('/').last}';
        TaskSnapshot uploadTask =
            await _storage.ref(fileName).putFile(profilePicture);
        String downloadUrl = await uploadTask.ref.getDownloadURL();
        updateData['profilePictureUrl'] = downloadUrl;
      }

      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      rethrow;
    }
  }

  // Feedback Methods
  Future<void> submitFeedback({
    required String feedback,
    required double rating,
  }) async {
    try {
      String userId = _auth.currentUser!.uid;

      await _firestore.collection('feedback').add({
        'userId': userId,
        'feedback': feedback,
        'rating': rating,
        'submittedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Download Methods
  Stream<QuerySnapshot> getDownloads() {
    String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('downloads')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Notification Methods
  Stream<QuerySnapshot> getNotifications() {
    String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      String userId = _auth.currentUser!.uid;
      QuerySnapshot notifications = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in notifications.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  // Event Methods
  Stream<QuerySnapshot> getEvents() {
    return _firestore
        .collection('events')
        .orderBy('date', descending: false)
        .snapshots();
  }

  Future<void> registerForEvent(String eventId) async {
    try {
      String userId = _auth.currentUser!.uid;

      await _firestore.collection('event_registrations').add({
        'userId': userId,
        'eventId': eventId,
        'registeredAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
