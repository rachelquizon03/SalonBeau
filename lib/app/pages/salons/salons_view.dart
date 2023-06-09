import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/salon_detail/salon_detail_view.dart';
import 'package:salon_app/app/pages/salons/widgets/salon_card.dart';
import 'package:salon_app/app/pages/utils.dart';
import 'package:salon_app/app/widgets/app_bottom_navigation_bar.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/domain/entities/salon.dart';

class SalonsView extends StatefulWidget {
  const SalonsView({super.key});

  @override
  State<SalonsView> createState() => _SalonsViewState();
}

class _SalonsViewState extends State<SalonsView> {
  List salonList = [];
  bool _isLoading = true;
  late ValueNotifier<bool> isPopOnceNotifier;

  Future<void> getSalons() async {
    final salons = await SalonRepository().getSortedPublishedSalons();
    setState(() {
      salonList = salons;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    isPopOnceNotifier = ValueNotifier(false);
    getSalons();
    super.initState();
  }

  @override
  void dispose() {
    isPopOnceNotifier.dispose();
    super.dispose();
  }

  void handleTap(Salon salon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalonDetailView(salon: salon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(!isPopOnceNotifier.value){
          isPopOnceNotifier.value = true;
          showToast(context, "Press back again to exit");
          return await Future.value(false);
        }
        else{
          return await Future.value(true);
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFFFD9ED),
          child: _isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 15.0),
                    Text(
                      'Loading Salons',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                )
              : SingleChildScrollView(
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
                        child: const SafeArea(
                          child: Text(
                            'All Salons',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          itemCount: salonList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SalonCard(
                              title: salonList[index].salonName,
                              urlLogo: salonList[index].logoUrl,
                              totalRatings: salonList[index].getTotalRatings(),
                              onTap: () => handleTap(salonList[index]),
                            );
                          }),
                    ],
                  ),
                ),
        ),
        bottomNavigationBar: AppBottomNavigationBar(
          currentIndex: navigationItemsIndexed['salons'] as int,
        ),
      ),
    );
  }
}
