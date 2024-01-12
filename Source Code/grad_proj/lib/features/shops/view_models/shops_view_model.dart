import 'package:flutter/cupertino.dart';
import 'package:grad_proj/core/network/apis_constants.dart';
import 'package:grad_proj/core/network/custom_response.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:grad_proj/features/shops/apis/shops_api.dart';
import 'package:grad_proj/features/shops/models/City.dart';
import 'package:grad_proj/features/shops/models/Tag.dart';
import 'package:grad_proj/features/shops/models/WorkingDay.dart';
import 'package:grad_proj/features/shops/models/Category.dart';
import 'package:grad_proj/features/shops/models/Address.dart';
import 'package:grad_proj/features/shops/models/Shop.dart';

class ShopsViewModel extends ChangeNotifier {
  List<Shop> shops = [];
  List<Category> categories = [];
  List<City> cities = [];
  List<Tag> mainTags = [];
  List<Tag> branchTags = [];

  Map<String, Address> addresses = {};

  List<WorkingHours> localWorkingDays = [];

  String? localImagePath;
  String? imagePathToUpload;
  bool loading = false;
  String? errorMessage;
  final GlobalKey<FormState> mainFormKey = GlobalKey<FormState>();

  int? userID;
  String? userToken;

  int categoryChecked = 0;
  bool showCategoryValidationError = false;
  int cityChecked = 0;
  bool showCityValidationError = false;
  int dayChecked = 0;
  bool showDayValidationError = false;

  ShopsViewModel() {
    pagingController.addPageRequestListener(fetchShopsWithPagination);
  }

  static const numberOfShopsPerRequest = 5;
  final PagingController<int, Shop> pagingController =
      PagingController(firstPageKey: 0);

  void init() {
    localWorkingDays = List.generate(7, (day) {
      return WorkingHours(
        day: day,
        isSelected: false,
      );
    });

    notifyListeners();
  }

  Future<Tag> addTag(Tag tag, bool branchTag) async {
    errorMessage = null;
    notifyListeners();
    try {
      var shopsData = await ShopsAPIs.addField(
          tag, (obj) => obj.toJson(), APIsConstants.tags, userToken);
      int id = shopsData.data["id"];
      tag.id = id;
      if (!branchTag) {
        mainTags.add(tag);
      } else {
        branchTags.add(tag);
      }
    } catch (e) {
      errorMessage = e.toString();
      print("$errorMessage");
    }
    notifyListeners();
    return tag;
  }

  Future<void> deleteShopById(int shopId) async {
    try {
      List<WorkingHours> workingHours =
          await ShopsAPIs.fetchListById<WorkingHours>(
              "${APIsConstants.workingHours}/$shopId",
              WorkingHours.fromJson,
              "workingHrs");

      for (WorkingHours hour in workingHours) {
        try {
          ShopsAPIs.deleteById("${APIsConstants.workingHours}/${hour.id}");
        } catch (error) {
          print(error);
        }
      }
    } catch (error) {
      print("$error");
    }
  }

  Future<void> fetchShopsWithPagination(int? pageKey) async {
    try {
      loading = true;
      final shopList = await ShopsAPIs.fetchShopsByPageNumber<Shop>(
          APIsConstants.shops,
          Shop.fromJson,
          pageKey!,
          numberOfShopsPerRequest);
      final filteredShops =
          shopList.where((shop) => shop.ownerId == userID).toList();

      final isLastPage = filteredShops.length < numberOfShopsPerRequest;

      if (isLastPage) {
        pagingController.appendLastPage(filteredShops);
      } else {
        final nextPage = pageKey + 1;
        pagingController.appendPage(filteredShops, nextPage);
      }
    } catch (error) {
      pagingController.error = error;
      print("$error");
    } finally {
      loading = false;
    }
  }

  Future<void> getShopData<T>(int entityId, {bool isEditMode = false}) async {
    loading = true;
    notifyListeners();
    List<Future> futureActions = [];
    futureActions.add(fetchAll(
        APIsConstants.categories, "categories", Category.fromJson, categories,
        preventLoading: true));
    futureActions.add(fetchAll(
        APIsConstants.cities, "cities", City.fromJson, cities,
        preventLoading: true));
    List futureResponses = await Future.wait(futureActions);
    categories = futureResponses[0];
    cities = futureResponses[1];
    if (isEditMode) {
      await fetchShopInEditMode(entityId);
    }
    loading = false;
    notifyListeners();
  }

  Future<List<T>> fetchAll<T>(String endpoint, String responseFieldName,
      T Function(String) fromJson, List<T> elements,
      {Map<String, dynamic>? queryParameters,
      bool preventLoading = false}) async {
    errorMessage = null;
    if (!preventLoading) {
      loading = true;
    }
    notifyListeners();
    try {
      elements = await ShopsAPIs.fetchAll<T>(
          endpoint, responseFieldName, fromJson,
          queryParameters: queryParameters);
    } catch (e) {
      errorMessage = e.toString();
      print("$errorMessage");
    }
    if (!preventLoading) {
      loading = false;
    }
    notifyListeners();
    return elements;
  }

  Future<void> fetchShopInEditMode(int entityId) async {
    errorMessage = null;
    notifyListeners();
    try {
      Shop shop =
          await ShopsAPIs.fetchById<Shop>("/entitys/$entityId", Shop.fromMap);

      updateCategoriesInEditMode(shop.categories);
      updateTagsInEditMode(shop.tags!);
      updateWorkingDaysInEditMode(entityId);
      updateCityInEditMode(shop.cityId);
      await fetchAllAddressesThatMatchEntityIdInEditMode(entityId);
    } catch (e) {
      handleFetchError(e);
    }
    notifyListeners();
  }

  void updateCategoriesInEditMode(List<Category>? shopCategories) {
    for (Category category in categories) {
      if (shopCategories!.any((apiCategory) => apiCategory.id == category.id)) {
        category.isSelected = true;
        categoryChecked++;
      }
    }
  }

  void updateTagsInEditMode(List<Tag> shopTags) {
    mainTags = shopTags;
  }

  void updateWorkingDaysInEditMode(int entityId) async {
    List<WorkingHours> workingDaysFromAPI =
        await ShopsAPIs.fetchListById<WorkingHours>(
            "/workingHrs/$entityId", WorkingHours.fromJson, "workingHrs");
    for (WorkingHours apiWorkingDay in workingDaysFromAPI) {
      for (WorkingHours localWorkingDay in localWorkingDays) {
        if (localWorkingDay.day == apiWorkingDay.day) {
          if (apiWorkingDay.isSelected!) {
            localWorkingDay.isSelected = true;
            localWorkingDay.openTime = apiWorkingDay.openTime;
            localWorkingDay.closeTime = apiWorkingDay.closeTime;
            dayChecked++;
          }
          break;
        }
      }
    }
  }

  void updateCityInEditMode(int shopCityId) {
    for (City city in cities) {
      if (city.id == shopCityId) {
        city.isSelected = true;
        cityChecked++;
      }
    }
  }

  Future<void> fetchAllAddressesThatMatchEntityIdInEditMode(
      int entityId) async {
    errorMessage = null;
    List<Address> tempAddresses = [];
    try {
      Map<String, dynamic> queryParameters = {"entityId": entityId};
      tempAddresses = await ShopsAPIs.fetchAll(
          APIsConstants.address, "addresses", Address.fromJson,
          queryParameters: queryParameters);

      for (var address in tempAddresses) {
        Address addressWithTags = await ShopsAPIs.fetchById<Address>(
            "/addresses/${address.id}", Address.fromMap);
        addAddressToList(addressWithTags);
      }
    } catch (e) {
      errorMessage = e.toString();
      print("$errorMessage");
    }
  }

  void addAddressToList(Address address) {
    if (!addresses.containsKey(address.long)) {
      addresses["${address.long}"] = Address();
    }
    addresses["${address.long}"] = (address);
    notifyListeners();
  }

  void handleFetchError(dynamic error) {
    errorMessage = error.toString();
  }

  Future<void> addShop(Shop shop) async {
    errorMessage = null;
    loading = true;
    shop.ownerId = userID;
    notifyListeners();
    try {
      var shopsData = await ShopsAPIs.addField(
          shop, (obj) => obj.toJson(), APIsConstants.shops, userToken);
      int id = shopsData.data["id"];
      await addWorkingDayHours(id);
      await updateField("categoryIds", '/entitys/$id/categories',
          returnSelectedCategories()!);
      await addAddresses(id);
      await updateField("tagIds", '/entitys/$id/tags', returnTagsIds(mainTags));
      shops.add(shop);
    } catch (e) {
      errorMessage = e.toString();
      print("$errorMessage");
    }
    loading = false;
    notifyListeners();
  }

  Future<void> addWorkingDayHours(int id) async {
    errorMessage = null;
    notifyListeners();
    try {
      List<Future> futureWorkingHours = [];
      for (var day in localWorkingDays) {
        day.entityId = id;
        if (day.isSelected!) {
          futureWorkingHours.add(ShopsAPIs.addField(day, (obj) => obj.toJson(),
              APIsConstants.workingHours, userToken));
        }
      }
      shops.last.workingDays = localWorkingDays;
      Future.wait(futureWorkingHours);
    } catch (e) {
      errorMessage = e.toString();
      print("$errorMessage");
    }
    notifyListeners();
  }

  Future<void> addAddresses(int entityId) async {
    errorMessage = null;
    notifyListeners();
    try {
      List<Future<CustomResponse>> addressesFutures = [];
      addresses.forEach((key, value) {
        value.entityId = entityId;
        addressesFutures.add(addAddress(value));
      });
      Future.wait(addressesFutures);
    } catch (e) {
      errorMessage = e.toString();
      print("$errorMessage");
    }
    notifyListeners();
  }

  Future<CustomResponse> addAddress(Address address) async {
    CustomResponse addressResponse = CustomResponse();
    try {
      addressResponse = await ShopsAPIs.addField(
          address, (obj) => obj.toJson(), APIsConstants.address, userToken);
      await updateField(
          "tagIds",
          '/addresses/${addressResponse.data["id"]}/tags',
          returnTagsIds(address.tags!));
    } catch (e) {
      errorMessage = e.toString();
      print("$errorMessage");
    }
    notifyListeners();
    return addressResponse;
  }

  List<int>? returnSelectedCategories() {
    List<int> categoiresId = [];
    for (var category in categories) {
      if (category.isSelected) {
        categoiresId.add(category.id!);
        category.isSelected = !category.isSelected;
      }
    }
    return categoiresId;
  }

  List<int> returnTagsIds(List<Tag> tags) {
    List<int> tagsIds = [];
    for (var tag in tags) {
      tagsIds.add(tag.id!);
    }
    return tagsIds;
  }

  Future<void> updateShop(Shop shop, int shopId) async {
    errorMessage = null;
    loading = true;
    List<Future> futureActions = [];
    notifyListeners();
    try {
      int id = shopId;
      await ShopsAPIs.updateEntity(
          shop, (obj) => obj.toJson(), "${APIsConstants.shops}/$id");
      futureActions.add(updateWorkingDayHours(id));
      futureActions.add(updateField("categoryIds", '/entitys/$id/categories',
          returnSelectedCategories()!));

      futureActions.add(updateAddresses(id));
      futureActions.add(
          updateField("tagIds", '/entitys/$id/tags', returnTagsIds(mainTags)));
      await Future.wait(futureActions);
      shops.add(shop);
    } catch (e) {
      errorMessage = e.toString();
      print("$errorMessage");
    }
    loading = false;
    notifyListeners();
  }

  Future<void> updateWorkingDayHours(int shopId) async {
    try {
      List<WorkingHours> apiWorkingDays =
          await ShopsAPIs.fetchListById<WorkingHours>(
              "${APIsConstants.workingHours}/$shopId",
              WorkingHours.fromJson,
              "workingHrs");
      List<Future> futureWorkingHours = [];

      for (WorkingHours localDay in localWorkingDays) {
        bool foundInApi = false;
        for (var apiDay in apiWorkingDays) {
          if (localDay.day == apiDay.day) {
            foundInApi = true;
            if (!localDay.isSelected! && apiDay.isSelected!) {
              futureWorkingHours.add(ShopsAPIs.deleteById(
                  "${APIsConstants.workingHours}/${apiDay.id}"));
            } else {
              localDay.entityId = shopId;
              localDay.id = apiDay.id;
              apiDay = localDay;
              futureWorkingHours.add(ShopsAPIs.updateEntity(
                  apiDay,
                  (obj) => obj.toJson(),
                  "${APIsConstants.workingHours}/${apiDay.id}"));
            }
            break;
          }
        }

        if (!foundInApi && localDay.isSelected!) {
          localDay.entityId = shopId;
          futureWorkingHours.add(ShopsAPIs.addField(localDay,
              (obj) => obj.toJson(), APIsConstants.workingHours, userToken));
        }
      }
      Future.wait(futureWorkingHours);
    } catch (error) {
      print("$error");
    }
  }

  void updateAddressList(Address newAddress, String mapKey) {
    addresses[mapKey] = newAddress;
    notifyListeners();
  }

  Future<void> updateAddresses(int shopId) async {
    try {
      List<Address> tempAddresses = await ShopsAPIs.fetchListById<Address>(
          "${APIsConstants.address}?entityId=$shopId",
          Address.fromJson,
          "addresses");
      if (tempAddresses.isEmpty) return;
      for (Address address in tempAddresses) {
        try {
          addresses["${address.long}"]!.entityId = address.entityId;
          await ShopsAPIs.updateEntity(addresses["${address.long}"],
              (obj) => obj?.toJson(), "${APIsConstants.address}/${address.id}");
          if (addresses["${address.long}"]!.tags == null) return;
          updateField("tagIds", '/addresses/${address.id}/tags',
              returnTagsIds(addresses["${address.long}"]!.tags!));
        } catch (error, s) {
          print(error);
          print(s);
        }
      }
    } catch (error) {
      print("$error");
    }
  }

  Future<void> updateField<T>(String requestBodyValue, String endpoint,
      List<int> branchAddresstags) async {
    errorMessage = null;
    notifyListeners();
    try {
      await ShopsAPIs.updateField(
          branchAddresstags, requestBodyValue, endpoint);
    } catch (e) {
      errorMessage = e.toString();
      print("$errorMessage");
    }
    notifyListeners();
  }

  int? returnSelectedCity() {
    for (var city in cities) {
      if (city.isSelected) {
        return city.id;
      }
    }
    return null;
  }

  void toggleDayIsChecked(WorkingHours day) {
    day.isSelected = !day.isSelected!;
    day.isSelected!
        ? dayChecked++
        : {dayChecked--, day.openTime = null, day.closeTime = null};
    dayChecked > 0 ? showDayValidationError = false : showDayValidationError;
    notifyListeners();
  }

  void toggleCategoryIsChecked(Category category) {
    category.isSelected = !category.isSelected;
    category.isSelected ? categoryChecked++ : categoryChecked--;
    categoryChecked > 0
        ? showCategoryValidationError = false
        : showCategoryValidationError;
    notifyListeners();
  }

  void toggleCityIsChecked(bool value) {
    value ? cityChecked++ : cityChecked--;
    cityChecked > 0 ? showCityValidationError = false : showCityValidationError;
    notifyListeners();
  }

  void setImagePath(String? imagePath) {
    localImagePath = imagePath;
    imagePathToUpload = null;
    notifyListeners();
  }

  void uploadImage(String path) async {
    try {
      String imagePath = await ShopsAPIs.uploadImage(path);
      imagePathToUpload = imagePath;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  bool validateForm() {
    if (categoryChecked > 0) {
      showCategoryValidationError = false;
    } else {
      showCategoryValidationError = true;
    }
    if (cityChecked > 0) {
      showCityValidationError = false;
    } else {
      showCityValidationError = true;
    }
    if (dayChecked > 0) {
      showDayValidationError = false;
    } else {
      showDayValidationError = true;
    }
    notifyListeners();

    if (mainFormKey.currentState!.validate() &&
        !showCategoryValidationError &&
        !showCityValidationError) {
      notifyListeners();
      return true;
    }
    return false;
  }

  void unCheckCategories() {
    for (var category in categories) {
      if (category.isSelected) {
        category.isSelected = false;
      }
    }
  }

  void clearData() {
    categoryChecked = 0;
    dayChecked = 0;
    cityChecked = 0;
    showCategoryValidationError = false;
    showCityValidationError = false;
    showDayValidationError = false;
    unCheckCategories();
    addresses.clear();
    mainTags.clear();
    branchTags.clear();
    notifyListeners();
  }
}
