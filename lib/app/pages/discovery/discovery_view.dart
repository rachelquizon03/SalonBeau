import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/discovery/widgets/verify_popup.dart';
import 'package:salon_app/app/pages/utils.dart';
import 'package:salon_app/app/widgets/discovery_card.dart';
import 'package:salon_app/app/pages/discovery/widgets/top_card.dart';
import 'package:salon_app/app/pages/salon_detail/salon_detail_view.dart';
import 'package:salon_app/app/widgets/app_bottom_navigation_bar.dart';
import 'package:salon_app/data/auth_repository.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/domain/entities/salon.dart';

class DiscoveryView extends StatefulWidget {
  const DiscoveryView({super.key});

  @override
  State<DiscoveryView> createState() => _DiscoveryViewState();
}

class _DiscoveryViewState extends State<DiscoveryView> {
  List salonList = [];
  bool _isLoading = true;

  late ValueNotifier<bool> isPopOnceNotifier;

  void showVerifyPopup(){
    if(!AuthRepository().isVerified == AuthRepository().isLoggedIn){
      Future.delayed(Duration(milliseconds: 2000), (){
        showDialog(context: context, builder: (context) => VerifyPopup());
      });
    }
  }

  Future<void> getSalons() async {
    final salons = await SalonRepository().getPublishedSalons();
    setState(() {
      salonList = salons;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    isPopOnceNotifier = ValueNotifier(false);
    getSalons();
    showVerifyPopup();
    super.initState();
  }

  @override
  void dispose() {
    isPopOnceNotifier.dispose();
    super.dispose();
  }

  void handleDiscoveryTap(Salon salon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalonDetailView(salon: salon),
      ),
    );
  }

  void handleRatedTap(Salon salon) {
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
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 56.0),
                        Container(
                          height: 128.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(8),
                            itemCount: salonList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return DiscoveryCard(
                                urlLogo: salonList[index].logoUrl,
                                onTap: () => handleDiscoveryTap(salonList[index]),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 28.0),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFBADD1),
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Top Rated Salon",
                                style: TextStyle(
                                  color: Color(0xFFC93480),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21.0,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // GridView.count(
                              //   crossAxisSpacing: 10,
                              //   mainAxisSpacing: 10,
                              //   shrinkWrap: true,
                              //   physics: const ScrollPhysics(),
                              //   crossAxisCount: 2,
                              //   children: List.generate(
                              //     salonList.length,
                              //     (index) {
                              //       return TopCard(
                              //         salonName: salonList[index].salonName,
                              //         urlLogo: salonList[index].logoUrl,
                              //         onTap: () =>
                              //             handleRatedTap(salonList[index]),
                              //       );
                              //     },
                              //   ),
                              // ),
                              Wrap(
                                spacing: 5,
                                children: List.generate(
                                  salonList.length,
                                  (index) {
                                    return TopCard(
                                      salonName: salonList[index].salonName,
                                      urlLogo: salonList[index].logoUrl,
                                      onTap: () =>
                                          handleRatedTap(salonList[index]),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: AppBottomNavigationBar(
          currentIndex: navigationItemsIndexed['discovery'] as int,
        ),
      ),
    );
  }
}
