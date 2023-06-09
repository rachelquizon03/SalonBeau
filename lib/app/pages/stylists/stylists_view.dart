import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/stylists/stylists_add_view.dart';
import 'package:salon_app/app/widgets/dialog.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/data/stylist_repository.dart';
import 'package:salon_app/domain/entities/stylist.dart';

class StylistsView extends StatefulWidget {
  const StylistsView({super.key});

  @override
  State<StylistsView> createState() => _StylistsViewState();
}

class _StylistsViewState extends State<StylistsView> {
  List<Stylist> _stylists = [];

  void loadStylists() async {
    final stylists =
        await StylistRepository().getStylistsByUid(SalonRepository.salon!.id);
    setState(() {
      _stylists = stylists;
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
        builder: (context) => const StylistsAddView(),
      ),
    );

    loadStylists();
  }

  void handleDelete(Stylist stylist) {
    showAlertDialog(
      context: context,
      titleText: 'Confirm delete',
      contentText: 'Are you sure you would like to delete this stylist?',
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
                    Text('Deleting a stylist'),
                  ],
                ),
              ),
            );
          },
        );

        try {
          await StylistRepository().deleteStylist(stylist);
          Navigator.of(context).pop();
          loadStylists();
        } catch (err) {
          Navigator.of(context).pop();
        }
      },
    );
  }

void handleEdit(Stylist stylist) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StylistsAddView(data: stylist),
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
                            'Stylists',
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
                  ..._stylists
                      .map(
                        (stylist) => StylistColumn(
                          data: stylist,
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

class StylistColumn extends StatelessWidget {
  const StylistColumn({
    super.key,
    required this.data,
    this.onDelete,
    this.onEdit,
  });
  final Stylist data;
  final Function(Stylist)? onDelete;
  final Function(Stylist)? onEdit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data.stylist, textAlign: TextAlign.left),
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
