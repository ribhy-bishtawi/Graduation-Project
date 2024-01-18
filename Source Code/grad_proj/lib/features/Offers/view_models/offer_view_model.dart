import 'package:flutter/cupertino.dart';
import 'package:grad_proj/core/network/apis_constants.dart';
import 'package:grad_proj/core/network/custom_response.dart';
import 'package:grad_proj/features/Offers/apis/apis/offers_api.dart';
import 'package:grad_proj/features/Offers/models/offer.dart';
import 'package:grad_proj/features/notification/apis/apis/notifications_api.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OfferViewModel extends ChangeNotifier {
  int? userID;
  String? userToken;
  List<Offer> offers = [];
  static const numberOfShopsPerRequest = 5;
  bool loading = false;

  final PagingController<int, Offer> pagingController =
      PagingController(firstPageKey: 0);

  OfferViewModel() {
    pagingController.addPageRequestListener(fetchOffersWithPagination);
  }

  Future<void> fetchOffersWithPagination(int? pageKey) async {
    try {
      loading = true;
      final offersList = await OffersAPI.fetchOffersByPageNumber<Offer>(
          APIsConstants.offer,
          userToken!,
          Offer.fromJson,
          pageKey!,
          numberOfShopsPerRequest);
      final isLastPage = offersList.length < numberOfShopsPerRequest;

      if (isLastPage) {
        pagingController.appendLastPage(offersList);
      } else {
        final nextPage = pageKey + 1;
        pagingController.appendPage(offersList, nextPage);
      }
    } catch (error) {
      pagingController.error = error;
      print("$error");
    } finally {
      loading = false;
    }
  }

  Future<CustomResponse> addOffer(Offer offer) async {
    loading = true;
    notifyListeners();
    var shopsData;
    try {
      shopsData = await OffersAPI.postMethod(
          offer, (obj) => obj.toJson(), APIsConstants.offer, userToken);
      offers.add(offer);
    } catch (e) {
      print("$e");
    }
    loading = false;
    notifyListeners();
    return shopsData;
  }

  Future<void> deleteOfferById(int offerID) async {
    try {
      OffersAPI.deleteById("${APIsConstants.offer}/$offerID", userToken!);
    } catch (error) {
      print("$error");
    }
  }
}
