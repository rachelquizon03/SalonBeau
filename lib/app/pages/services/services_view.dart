import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/services/services_add_view.dart';
import 'package:salon_app/app/pages/stylists/stylists_add_view.dart';
import 'package:salon_app/app/widgets/dialog.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/data/service_repository.dart';
import 'package:salon_app/data/stylist_repository.dart';
import 'package:salon_app/domain/entities/service.dart';
import 'package:salon_app/domain/entities/stylist.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({super.key});

  @override
  State<ServicesView> createState() => _StylistsViewState();
}

class _StylistsViewState extends State<ServicesView> {
  List<Service> _services = [];

  void loadStylists() async {
    final services =
        await ServiceRepository().getServicesByUid(SalonRepository.salon!.id);
    setState(() {
      _services = services;
    });
  }

  @override
  void initState() {
    loadStylists();
    super.initState();
  }

  void handleBack() {
    Navigator.of(context).pop();
  }

  void handleAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ServicesAddView(),
      ),
    );

    loadStylists();
  }

  void handleDelete(Service service) {
    showAlertDialog(
      context: context,
      titleText: 'Confirm delete',
      contentText: 'Are you sure you would like to delete this service?',
      onContinue: () async {
        Navigator.of(context).pop();

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
                    Text('Deleting a service'),
                  ],
                ),
              ),
            );
          },
        );

        try {
          await ServiceRepository().deleteService(service);
          Navigator.of(context).pop();
          loadStylists();
        } catch (err) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  void handleEdit(Service service) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicesAddView(data: service),
      ),
    );
    loadStylists();
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            'Services',
                            style: TextStyle(
                              color: Color(0xFFC93480),
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: handleAdd,
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xFFC93480),
                          size: 28.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  ..._services
                      .map(
                        (service) => ServiceColumn(
                          data: service,
                          onDelete: handleDelete,
                          onEdit: handleEdit,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceColumn extends StatelessWidget {
  const ServiceColumn({
    super.key,
    // required this.service,
    required this.data,
    this.onDelete,
    this.onEdit,
  });
  // final String service;
  final Service data;
  final Function(Service)? onDelete;
  final Function(Service)? onEdit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data.category, textAlign: TextAlign.left),
            Row(
              children: [
                IconButton(
                  onPressed: () => onDelete?.call(data),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
                IconButton(
                  onPressed: () => onEdit?.call(data),
                  icon: const Icon(Icons.edit, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15.0),
        const Divider(),
      ],
    );
  }
}
