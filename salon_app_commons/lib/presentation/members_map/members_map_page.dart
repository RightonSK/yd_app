import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'members_map_model.dart';

class MembersMapPage extends StatelessWidget {
  const MembersMapPage({super.key, 
    this.initialPrefecture,
    this.members,
  });
  final Prefecture? initialPrefecture;
  final List<User>? members;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MembersMapModel>(
      create: (_) => MembersMapModel(members: members),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('メンバーズマップ'),
        ),
        body: Consumer<MembersMapModel>(
          builder: (context, model, child) {
            model.googleMapController.future.then((controller) {
              if (model.selectedLocation != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLng(model.selectedLocation!),
                );
              }
            });
            return model.isLoading
                ? const FlutterUnivLoadingIndicator()
                : Column(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          myLocationButtonEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            model.googleMapController.complete(controller);
                          },
                          initialCameraPosition:
                              initialPrefecture?.location != null
                                  ? CameraPosition(
                                      target: initialPrefecture!.location!,
                                      zoom: 8.0,
                                    )
                                  : CameraPosition(
                                      target: Prefecture.NAGANO.location!,
                                      zoom: 4.8,
                                    ),
                          markers: model.getDistributedMarkers(context),
                          onTap: (selectedLocation) {
                            model.selectedLocation = selectedLocation;
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: primaryNavyColor,
                        child: const SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              '※メンバー都道府県情報を元に適当に位置をマッピングしています(実際の住所とは異なります)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
