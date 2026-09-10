import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MembersMapModel extends ChangeNotifier {
  MembersMapModel({this.members}) {
    _init();
  }

  List<User>? members;
  Completer<GoogleMapController> googleMapController = Completer();
  LatLng? selectedLocation;
  bool isLoading = false;
  final _repository = UserRepository();

  Future _init() async {
    if (members != null) {
      return;
    }

    startLoading();
    try {
      members = await _repository.fetchHasPrefectureMember();
    } catch (e) {
      logger.d(e);
      rethrow;
    } finally {
      endLoading();
      notifyListeners();
    }
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// メンバーのListをもとに表示が重ならないようにしたGoogleMapマーカーを返す
  Set<Marker> getDistributedMarkers(
    BuildContext context,
  ) {
    if (members == null || members!.isEmpty) {
      return <Marker>{};
    }
    final random = Random();
    return members!.where((member) => member.location != null).map((member) {
      // 同じ場所にいるメンバーが見つかったら
      final sameLocationExists = members!.any(
        (element) => element.location == member.location,
      );
      // 1km以上10km以内でランダムな距離&ランダムな方位にずらす
      final newLocation = sameLocationExists
          ? _moveLatLng(
              member.location!,
              1000 + random.nextInt(9000),
              random.nextInt(360),
            )
          : member.location;
      return Marker(
        markerId: MarkerId(member.id),
        position: newLocation!,
        infoWindow: InfoWindow(
          title: member.nickname,
          onTap: () {
            context.push(MemberDetailPage.route(member.nickname!));
          },
        ),
      );
    }).toSet();
  }

  /// ある緯度経度[point]から半径方向：[radialDirection]に[distanceMeter]メートル移動した緯度経度を返す
  ///
  /// [radialDirection]は0~360の範囲。北：0、東：90、南：180、西：270
  LatLng _moveLatLng(LatLng? point, int? distanceMeter, int? radialDirection) {
    // 期待しない引数であれば計算をスキップする
    if (point == null ||
        distanceMeter == null ||
        radialDirection == null ||
        distanceMeter < 0 ||
        radialDirection < 0 ||
        radialDirection > 360) {
      logger.d('計算をスキップします');
      logger.d(
        'point: $point, distanceMeter: $distanceMeter, radialDirection: $radialDirection',
      );
      return const LatLng(0, 0);
    }

    // latitude: 緯度 longitude: 経度
    final radius = radialDirection;
    const earthRadius = 6378150;

    // 緯線の移動距離
    final latitudeDistance = distanceMeter * cos(radius);

    // 1mあたりの緯度
    const earthCircle = 2 * pi * earthRadius;
    const latitudePerMeter = 360 / earthCircle;

    // 緯度の変化量
    final latitudeDelta = latitudeDistance * latitudePerMeter;
    final newLatitude = point.latitude + latitudeDelta;

    // 経線上の移動距離
    final longitudeDistance = distanceMeter * sin(radialDirection * pi / 180);

    // 1mあたりの経度
    final earthRadiusAtLongitude = earthRadius * cos(newLatitude * pi / 180);
    final earthCircleAtLongitude = 2 * pi * earthRadiusAtLongitude;
    final longitudePerMeter = 360 / earthCircleAtLongitude;

    // 経度の変化量
    final longitudeDelta = longitudeDistance * longitudePerMeter;

    return LatLng(newLatitude, point.longitude + longitudeDelta);
  }
}
