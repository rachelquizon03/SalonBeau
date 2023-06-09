import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/app/pages/services/services_view.dart';
import 'package:salon_app/app/pages/stylists/stylists_view.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/data/service_repository.dart';
import 'package:salon_app/data/stylist_repository.dart';
import 'package:salon_app/domain/entities/service.dart';
import 'package:salon_app/domain/entities/stylist.dart';

class ServicesAddView extends StatefulWidget {
  const ServicesAddView({super.key, this.data});
  final Service? data;
  @override
  State<ServicesAddView> createState() => _ServicesAddViewState();
}

class _ServicesAddViewState extends State<ServicesAddView> {
  final _formKey = GlobalKey<FormState>();
  final data = {};

  void handleBack() {
    Navigator.of(context).pop();
  }

  void handleAdd() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final salon = SalonRepository.salon!;

      final cost = double.parse(data['cost']);
      final service = Service(
        salonId: salon.id!,
        category: data['category'],
        subCategory: data['subCategory'] ?? '',
        cost: cost,
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
                  Text('Creating a service'),
                ],
              ),
            ),
          );
        },
      );

      try {
        await ServiceRepository().addService(service);
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

      final cost = double.parse(data['cost']);
      final service = Service(
        id: widget.data!.id,
        salonId: salon.id!,
        category: data['category'],
        subCategory: data['subCategory'] ?? '',
        cost: cost,
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
                  Text('Editing a service'),
                ],
              ),
            ),
          );
        },
      );

      try {
        await ServiceRepository().editService(service);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
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
                        'Service',
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
                          initialValue: widget.data?.category,
                          decoration:
                              const InputDecoration(labelText: 'Category'),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter category';
                            }
                            return null;
                          },
                          onSaved: (value) => data['category'] = value,
                        ),
                        TextFormField(
                          initialValue: widget.data?.cost.toString(),
                          decoration: const InputDecoration(labelText: 'Cost'),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter cost';
                            }
                            return null;
                          },
                          onSaved: (value) => data['cost'] = value,
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          initialValue: widget.data?.subCategory,
                          decoration:
                              const InputDecoration(labelText: 'Sub Category'),
                          onSaved: (value) => data['subCategory'] = value,
                        ),
                        const SizedBox(height: 15.0),
                        AppElevatedButton(
                          onPressed: widget.data != null ? handleEdit : handleAdd,
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
