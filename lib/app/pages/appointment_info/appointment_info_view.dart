import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_app/app/pages/appointment_info/appointment_info_successful_view.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/app/pages/salon_detail/salon_detail_view.dart';
import 'package:salon_app/app/widgets/dialog.dart';
import 'package:salon_app/app/widgets/discovery_card.dart';
import 'package:salon_app/data/appointment_repository.dart';
import 'package:salon_app/data/auth_repository.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/data/schedule_repository.dart';
import 'package:salon_app/data/service_repository.dart';
import 'package:salon_app/data/stylist_repository.dart';
import 'package:salon_app/domain/entities/appointment.dart';
import 'package:salon_app/domain/entities/salon.dart';
import 'package:salon_app/domain/entities/service.dart';
import 'package:salon_app/domain/entities/stylist.dart';

class AppointmentInfoView extends StatefulWidget {
  const AppointmentInfoView({super.key, required this.salon});
  final Salon salon;
  @override
  State<AppointmentInfoView> createState() => _AppointmentInfoViewState();
}

class _AppointmentInfoViewState extends State<AppointmentInfoView> {
  List<Service> _services = [];
  List<Stylist> _stylists = [];
  List<Salon> _salons = [];
  bool isPickedDate = false;
  bool isPickedStylist = false;
  bool isPickedService = false;
  bool isPickedTime = false;

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  // String serviceValue = "";
  String stylistValue = "";

  final _formKey = GlobalKey<FormState>();

  final _data = {};

  void loadData() async {
    final services =
        await ServiceRepository().getServicesByUid(widget.salon.id);
    final stylists =
        await StylistRepository().getStylistsByUid(widget.salon.id);

    var salons = await SalonRepository().getPublishedSalons();
    salons = salons.where((salon) => salon.id != widget.salon.id).toList();

    final customer = AuthRepository.customer!;
    final name = '${customer.firstName} ${customer.lastName}';
    _nameController.text = name;
    _emailController.text = customer.email;

    setState(() {
      _salons = salons;
      _services = services;
      _stylists = stylists;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void handleDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2099),
    );
    if (selectedDate != null) {
      if (selectedDate.compareTo(DateTime.now()) < 0) {
        showOkDialog(
          context: context,
          titleText: 'Unable to select date',
          contentText: 'Should select a later date',
        );
        return;
      }
      setState(() {
        isPickedDate = true;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        date = selectedDate;
      });
    }
  }

  void handleTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final now = DateTime.now();
      final date = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      setState(() {
        isPickedTime = true;
        _timeController.text = DateFormat.Hm().format(date);
        time = selectedTime;
      });
    }
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
                  Text('Creating an appointment'),
                ],
              ),
            ),
          );
        },
      );

      final appointment = Appointment(
        date: _data['date'],
        time: _data['time'],
        name: _data['name'],
        service: _data['service'],
        stylist: _data['stylist'],
        email: _emailController.text,
        salonId: widget.salon.id!,
        progress: '',
      );

      try {
        var appointmentSchedule = await ScheduleRepository().getScheduleByUid(appointment.salonId);
        // for(var appointments in appointmentSchedule.blocks){
        //   if(appointments.day.capitalize() == DateFormat('EEEE').format(date)){
        //     if(time.hour >= appointments.startTime.hour && time.hour < appointments.endTime.hour){
        //       var result = await AppointmentRepository().addAppointment(appointment);
        //       if(result.isSuccess){
        //         _dateController.clear();
        //         _timeController.clear();
        //         setState(() {
        //         });
        //         _services = [];
        //         _stylists = [];
        //         Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => const AppointmentInfoSuccessfulView(),
        //           ),
        //         );
        //       }
        //       else{
        //         Navigator.pop(context);
        //         showDialog(context: context, builder: (context) => AlertDialog(
        //           title: Text("Appointment Failed"),
        //           content: Text("Stylist is busy at the selected time, please choose another time or another stylist"),
        //           actions: [
        //             TextButton(
        //               onPressed: () => Navigator.pop(context),
        //               child: Text("Close"),
        //             )
        //           ],
        //         ));
        //       }
        //       break;
        //     }
        //     else{
        //       Navigator.pop(context);
        //       showDialog(context: context, builder: (context) => AlertDialog(
        //         title: Text("Appointment Failed"),
        //         content: Text("The Salon is not available"),
        //         actions: [
        //           TextButton(
        //             onPressed: () => Navigator.pop(context),
        //             child: Text("Close"),
        //           )
        //         ],
        //       ));
        //       break;
        //     }
        //   }
        // }

        for(int i = 0; i < appointmentSchedule.blocks.length; i++){
          if(appointmentSchedule.blocks[i].day.capitalize() == DateFormat('EEEE').format(date)){
            if(time.hour >= appointmentSchedule.blocks[i].startTime.hour && time.hour < appointmentSchedule.blocks[i].endTime.hour){
              var result = await AppointmentRepository().addAppointment(appointment);
              if(result.isSuccess){
                _dateController.clear();
                _timeController.clear();
                setState(() {
                });
                _services = [];
                _stylists = [];
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppointmentInfoSuccessfulView(),
                  ),
                );
              }
              else{
                Navigator.pop(context);
                showDialog(context: context, builder: (context) => AlertDialog(
                  title: Text("Appointment Failed"),
                  content: Text("Stylist is busy at the selected time, please choose another time or another stylist"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Close"),
                    )
                  ],
                ));
              }
              break;
            }
            else{
              Navigator.pop(context);
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text("Appointment Failed"),
                content: Text("The Salon is not available"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Close"),
                  )
                ],
              ));
              break;
            }
          }
          else{
            if((i + 1) == appointmentSchedule.blocks.length){
              Navigator.pop(context);
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text("Appointment Failed"),
                content: Text("The Salon is not available"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Close"),
                  )
                ],
              ));
            }
          }
        }

        // var result = await AppointmentRepository().addAppointment(appointment);
        // if(result.isSuccess){
        //   _dateController.clear();
        //   _timeController.clear();
        //   setState(() {
        //   });
        //   _services = [];
        //   _stylists = [];
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const AppointmentInfoSuccessfulView(),
        //     ),
        //   );
        // }
        // else{
        //   Navigator.pop(context);
        //   showDialog(context: context, builder: (context) => AlertDialog(
        //     title: Text("Appointment Failed"),
        //     content: Text("Stylist is busy at the selected time, please choose another time or another stylist"),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(context),
        //         child: Text("Close"),
        //       )
        //     ],
        //   ));
        // }
      } catch (e) {
        Navigator.of(context).pop();
      }
    }
  }

  void handleDiscoveryTap(Salon salon) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SalonDetailView(salon: salon),
      ),
    );
  }

  void handleBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFFD9ED),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFC93480),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: handleBack,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                      const Text(
                        'Appointment Info',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.network(widget.salon.logoUrl),
                      const SizedBox(height: 25.0),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            children: [
                              TextFormField(
                                enabled: false,
                                controller: _nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input name';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) =>
                                    _data['name'] = newValue!,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Name',
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              DropdownButtonFormField(
                                // value: serviceValue != "" ? serviceValue : null,
                                isExpanded: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input service';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) =>
                                    _data['service'] = newValue!,
                                decoration: const InputDecoration(
                                  labelText: 'Services',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // serviceValue = value ?? "";
                                    isPickedService = true;
                                  });
                                },
                                items: _services
                                    .map((service) => service.category)
                                    .map((service) {
                                  return DropdownMenuItem(
                                    value: service,
                                    child: Text(
                                      service,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 5.0),
                              DropdownButtonFormField(
                                // value: stylistValue,
                                isExpanded: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input stylist';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) =>
                                    _data['stylist'] = newValue!,
                                decoration: const InputDecoration(
                                  labelText: 'Stylist',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    stylistValue = value ?? "";
                                    isPickedStylist = true;
                                  });
                                },
                                items: _stylists
                                    .map((stylist) => stylist.stylist)
                                    .map((stylist) {
                                  return DropdownMenuItem(
                                    value: stylist,
                                    child: Text(
                                      stylist,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ),
                              TextFormField(
                                controller: _dateController,
                                onSaved: (newValue) =>
                                    _data['date'] = newValue!,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input date';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.none,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Date',
                                ),
                                onTap: handleDate,
                              ),
                              SizedBox(height: 15,),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(text: "Note:", style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: " This date is not available for booking.")
                                  ]
                                ),
                              ),
                              TextFormField(
                                controller: _timeController,
                                onSaved: (newValue) =>
                                    _data['time'] = newValue!,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input time';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.none,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Time',
                                ),
                                onTap: handleTime,
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      AppElevatedButton(
                        onPressed: !isPickedStylist ||
                                !isPickedService ||
                                !isPickedDate ||
                                !isPickedTime
                            ? null
                            : handleAdd,
                        child: Text('Add Appointment'),
                      ),
                      const SizedBox(height: 35.0),
                      const Text(
                        'Other Salons',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Container(
                        height: 128.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(8),
                          itemCount: _salons.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DiscoveryCard(
                              urlLogo: _salons[index].logoUrl,
                              onTap: () => handleDiscoveryTap(_salons[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
