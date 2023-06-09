import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app/domain/entities/rating.dart';

class RatingsRepository {
  Future<Rating> getRatingById(id) async {
    final feedbackSnapshot =
        await FirebaseFirestore.instance.collection("feedback").doc(id).get();
    final feedbackData = feedbackSnapshot.data() ?? {};
    return Rating.fromJson({...feedbackData, 'id': feedbackSnapshot.id});
  }

  Future<List<Rating>> getRatingsByUid(uid) async {
    final feedbackSnapshot = await FirebaseFirestore.instance
        .collection("feedback")
        .where('salonId', isEqualTo: uid)
        .get();
    final List<Rating> feedbacks = [];
    for (final doc in feedbackSnapshot.docs) {
      final data = doc.data();
      feedbacks.add(
        Rating(
          customerId: data['customerID'] ?? '',
          review: data['review'],
          salonId: data['salonId'],
          star: data['star'],
        ),
      );
    }
    return feedbacks;
  }

  Future<Rating> addRating(Rating rating, String appointmentId) async {
    final feedback =
        await FirebaseFirestore.instance.collection("feedback").add({
      'createdAt': Timestamp.now(),
      ...rating.toJSON(),
    });
    await FirebaseFirestore.instance
        .collection("salon")
        .doc(rating.salonId)
        .set({
      "ratings": FieldValue.arrayUnion([rating.star])
    }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection("Appointment")
        .doc(appointmentId)
        .set({"feedbackId": feedback.id}, SetOptions(merge: true));
    return rating;
  }
}
