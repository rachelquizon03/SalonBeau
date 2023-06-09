import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/app/pages/stylists/stylists_view.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/data/stylist_repository.dart';
import 'package:salon_app/domain/entities/stylist.dart';

class StylistsAddView extends StatefulWidget {
  const StylistsAddView({super.key, this.data});
  final Stylist? data;
  @override
  State<StylistsAddView> createState() => _StylistsAddViewState();
}

class _StylistsAddViewState extends State<StylistsAddView> {
  final _formKey = GlobalKey<FormState>();
  final data = {};

  void handleBack() {
    Navigator.of(context).pop();
  }

  void handleAdd() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final salon = SalonRepository.salon!;
      final stylist = Stylist(salonId: salon.id!, stylist: data['stylist']);

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
                  Text('Creating a stylist'),
                ],
              ),
            ),
          );
        },
      );

      try {
        await StylistRepository().addStylist(stylist);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } catch (e) {
        Navigator.of(context).pop();
      }
    }
  }

  void handleEdit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final salon = SalonRepository.salon!;

      final stylist = Stylist(
        id: widget.data!.id,
        salonId: salon.id!,
        stylist: data['stylist'],
      );

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
                  Text('Editing a stylist'),
                ],
              ),
            ),
          );
        },
      );

      try {
        await StylistRepository().editStylist(stylist);
        Navigator.of(context).pop();
        Future.delayed(Duration(milliseconds: 300), () => Navigator.of(context).pop());
      } catch (e) {
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
                        'Stylist',
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
                        TextFormField(
                          initialValue: widget.data?.stylist,
                          decoration:
                              const InputDecoration(labelText: 'Stylist'),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter stylist';
                            }
                            return null;
                          },
                          onSaved: (value) => data['stylist'] = value,
                        ),
                        const SizedBox(height: 15.0),
                        AppElevatedButton(
                          onPressed: widget.data == null ? handleAdd : handleEdit,
                          child: const Text('Submit'),
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
