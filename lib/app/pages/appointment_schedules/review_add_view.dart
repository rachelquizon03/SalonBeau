import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/appointment_schedules/review_add_successful_view.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/data/auth_repository.dart';
import 'package:salon_app/data/ratings_repository.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/domain/entities/appointment.dart';
import 'package:salon_app/domain/entities/rating.dart';

class ReviewAddView extends StatefulWidget {
  const ReviewAddView({super.key, required this.appointment});
  final Appointment appointment;
  @override
  State<ReviewAddView> createState() => _ReviewAddViewState();
}

class _ReviewAddViewState extends State<ReviewAddView> {
  final _formKey = GlobalKey<FormState>();
  final _ratingItems = ['5', '4', '3', '2', '1'];

  final _data = {};

  void handleBack() {
    Navigator.of(context).pop();
  }

  void handleAdd() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 15.0),
                  Text('Leaving a review'),
                ],
              ),
            ),
          );
        },
      );

      try {
        final customer = AuthRepository.customer!;
        await RatingsRepository().addRating(
          Rating(
            star: _data['star'],
            review: _data['review'],
            customerId: customer.id!,
            salonId: widget.appointment.salonId,
          ),
          widget.appointment.id!,
        );
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ReviewAddSuccessfullyView(),
          ),
        );
      } on Exception catch (e, s) {
        print(s);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFFD9ED),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25.0,
                horizontal: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: handleBack,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFFC93480),
                          size: 28.0,
                        ),
                      ),
                      const Text(
                        'Leave a Review',
                        style: TextStyle(
                          color: Color(0xFFC93480),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField(
                          onSaved: (newValue) => _data['star'] = newValue!,
                          decoration: const InputDecoration(
                            labelText: 'Star',
                          ),
                          onChanged: (value) {},
                          items: _ratingItems.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Review'),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter review';
                            }
                            return null;
                          },
                          onSaved: (value) => _data['review'] = value,
                        ),
                        const SizedBox(height: 15.0),
                        AppElevatedButton(
                          onPressed: handleAdd,
                          child: const Text('Add Review'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
