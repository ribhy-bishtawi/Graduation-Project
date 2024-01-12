import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:map_picker/map_picker.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:grad_proj/core/constants/constants.dart';
import 'package:grad_proj/core/helper/permission_manager.dart';
import 'package:grad_proj/features/shops/models/Address.dart';
import 'package:grad_proj/features/shops/models/Tag.dart';
import 'package:grad_proj/features/shops/view_models/shops_view_model.dart';
import 'package:grad_proj/resources/app_strings.dart';
import 'package:grad_proj/theme/button_styles.dart';
import 'package:grad_proj/theme/palette.dart';
import 'package:grad_proj/theme/text_style_util.dart';
import 'package:grad_proj/widgets/CustomTextField.dart';
import 'package:grad_proj/widgets/WrapText.dart';

class ChooseLocation extends StatefulWidget {
  final bool isEditMode;
  final Address? address;
  final String? mapValueToChangeInEditMode;
  const ChooseLocation(
      {super.key,
      required this.isEditMode,
      required this.address,
      required this.mapValueToChangeInEditMode});

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  late CameraPosition cameraPosition;
  final _controller = Completer<GoogleMapController>();
  late ShopsViewModel provider;
  MapPickerController mapPickerController = MapPickerController();
  final TextEditingController _tagWordController = TextEditingController();
  final TextEditingController branchNameTextController =
      TextEditingController();
  LatLng? _currentLocation;
  var textController = TextEditingController();
  List<Tag> tagWords = [];
  Address? address;
  String postOrEditModeText(String postText, String? editText) {
    if (editText == null) return postText;
    return widget.isEditMode ? editText : postText;
  }

  @override
  void initState() {
    address = widget.isEditMode ? widget.address : null;
    if (widget.isEditMode) branchNameTextController.text = address!.arabicName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO:localization
    // final locale = context.locale;
    provider = Provider.of<ShopsViewModel>(context);
    tagWords = widget.isEditMode ? address?.tags ?? [] : provider.branchTags;

    cameraPosition = widget.isEditMode
        ? CameraPosition(
            target: LatLng(address!.lat!, address!.long!), zoom: 14.4746)
        : const CameraPosition(
            target: LatLng(32.221617, 35.261280), zoom: 14.4746);

    final double horizontalPadding = 0.05.sw;
    final double verticalPadding = 0.02.sh;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppStrings.addNewBranchLocation,
          style: TextStyleUtil.titleTextStyle,
          textAlign: TextAlign.right,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MapPicker(
              iconWidget: Image.asset(
                "assets/images/location_icon512px.png",
                height: 24.h,
              ),
              mapPickerController: mapPickerController,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 1.sw,
                    height: 650.w,
                    child: GoogleMap(
                      myLocationEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      initialCameraPosition: cameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMoveStarted: () {
                        mapPickerController.mapMoving!();
                        textController.text = "checking ...";
                      },
                      onCameraMove: (cameraPosition) {
                        this.cameraPosition = cameraPosition;
                      },
                      onCameraIdle: () async {
                        mapPickerController.mapFinishedMoving!();
                      },
                    ),
                  ),
                  Positioned(
                      bottom: 0.05.sw,
                      right: 0.01.sh,
                      child: ElevatedButton(
                        onPressed: () {
                          _requestLocationPermission();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Palette.textInputText,
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding,
                          ),
                          elevation: 4.0,
                        ),
                        child: Icon(
                          Icons.gps_fixed,
                          size: 20.sp,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            //TODO change with localization
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: SizedBox(
                  height: 194.h,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    children: [
                      Text(
                        AppStrings.addBranchScreenTitle,
                        style: TextStyleUtil.addShopHeaderTextStyle,
                      ),
                      Constants.gapH16,
                      CustomTextField(
                          textFieldController: branchNameTextController,
                          hintText: postOrEditModeText(
                              AppStrings.offerName, address?.arabicName),
                          textStyle: TextStyleUtil.addShopInputTextStyle),
                      Constants.gapH24,
                      ElevatedButton(
                          onPressed: () {
                            widget.isEditMode
                                ? provider.updateAddressList(
                                    Address(
                                        arabicName:
                                            branchNameTextController.text,
                                        englishName: "llllllllll",
                                        lat: cameraPosition.target.latitude,
                                        long: cameraPosition.target.longitude,
                                        tags: tagWords),
                                    widget.mapValueToChangeInEditMode!)
                                : provider.addAddressToList(Address(
                                    arabicName: branchNameTextController.text,
                                    englishName: "llllllllll",
                                    lat: cameraPosition.target.latitude,
                                    long: cameraPosition.target.longitude,
                                    tags: tagWords));
                            Routemaster.of(context).pop();
                          },
                          style: ButtonStyles.primaryButtonStyle,
                          child: Text(
                            AppStrings.shopInformationSaveButton,
                            style: TextStyleUtil.buttonTextStyle,
                          )),
                      Constants.gapH24,
                      Align(
                        alignment: Alignment.centerRight,
                        child: WrapText(elementsList: tagWords),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                                textFieldController: _tagWordController,
                                hintText: AppStrings.branchHintWords,
                                textStyle: TextStyleUtil.addShopInputTextStyle),
                          ),
                          Constants.gapW10,
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                                onPressed: () async {
                                  Tag tag = await provider.addTag(
                                    Tag(
                                      arabicName: _tagWordController.text,
                                      // TODO ask about the english name
                                      englishName: "null",
                                    ),
                                    true,
                                  );
                                  widget.isEditMode
                                      ? address!.tags?.add(tag)
                                      : null;

                                  setState(() {
                                    _tagWordController.clear();
                                  });
                                },
                                style: ButtonStyles.primaryButtonStyle,
                                child: Text(
                                  AppStrings.hintWordAddButton,
                                  style: TextStyleUtil.buttonTextStyle,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      final GoogleMapController mapController = await _controller.future;

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 14.0),
      );
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _requestLocationPermission() async {
    var status = await PermissionManager.requestLocation();
    if (status) {
      _getCurrentLocation();
    }
  }
}
