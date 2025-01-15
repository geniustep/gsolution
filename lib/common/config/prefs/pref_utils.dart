import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_keys.dart';
import 'package:gsolution/src/authentication/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  PrefUtils();

  static SharedPreferences? preferences;
  static double latitude = 0;
  static double longitude = 0;
  static var products = <ProductModel>[].obs;
  static var categoryProduct = <ProductCategoryModel>[].obs;
  static var partners = <PartnerModel>[].obs;
  static var user = UserModel().obs;
  static RxList<OrderModel> sales = <OrderModel>[].obs;
  static var orderLine = <OrderLineModel>[].obs;
  static var accountMove = <AccountMoveModel>[].obs;
  static var accountJournal = <AccountJournalModel>[].obs;

  static Future<void> initPreferences() async {
    preferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> clearPrefs() async {
    await initPreferences();
    await preferences!.clear();
  }

  static Future<void> setToken(String token) async {
    await initPreferences();
    await preferences!.setString(PrefKeys.token, token);
  }

  static Future<String> getToken() async {
    await initPreferences();
    return preferences!.getString(PrefKeys.token) ?? "";
  }

  static Future<void> setIsLoggedIn(bool isLoggedIn) async {
    await initPreferences();
    await preferences!.setBool(PrefKeys.isLoggedIn, isLoggedIn);
  }

  static Future<bool> getIsLoggedIn() async {
    await initPreferences();
    return preferences!.getBool(PrefKeys.isLoggedIn) ?? false;
  }

// Location

  static setLatitude(double lat) async {
    latitude = lat;
    return await preferences!.setDouble(PrefKeys.lat, latitude);
  }

  static double getLatitude() {
    if (preferences!.containsKey(PrefKeys.lat)) {
      return preferences!.getDouble(PrefKeys.lat)!;
    }
    return 0;
  }

  static setLongitude(double long) async {
    longitude = long;
    return await preferences!.setDouble(PrefKeys.long, longitude);
  }

  static double getLongitude() {
    if (preferences!.containsKey(PrefKeys.long)) {
      return preferences!.getDouble(PrefKeys.long)!;
    }
    return 0;
  }

// Users
  static Future<void> setUser(String userData) async {
    await initPreferences();
    await preferences!.setString(PrefKeys.user, userData);
  }

  static Future<UserModel> getUser() async {
    await initPreferences();
    Map<String, dynamic> getUser =
        jsonDecode(preferences!.getString(PrefKeys.user) ?? "{}");
    user.value = UserModel.fromJson(getUser);
    return user.value;
  }

  // Partners
  static Future<void> setPartners(RxList<PartnerModel> partner) async {
    await initPreferences();
    partners = partner;
    preferences!.setString(PrefKeys.partners, jsonEncode(partner.toList()));
  }

  static Future<RxList<PartnerModel>> getPartners() async {
    await initPreferences();
    var partnersString = preferences!.getString(PrefKeys.partners);
    if (partnersString == null || partnersString.isEmpty) {
      return <PartnerModel>[].obs;
    }
    List<dynamic> decoded = jsonDecode(partnersString);
    return RxList(decoded.map((e) => PartnerModel.fromJson(e)).toList());
  }

  static Future<void> updatePartner(PartnerModel updatedPartner) async {
    RxList<PartnerModel> currentPartners = await getPartners();
    int index = currentPartners
        .indexWhere((partner) => partner.id == updatedPartner.id);
    if (index != -1) {
      currentPartners[index] = updatedPartner;
    } else {
      currentPartners.add(updatedPartner);
    }
    await setPartners(currentPartners);
  }

  // Products
  static Future<void> setProducts(RxList<ProductModel> product) async {
    await initPreferences();
    products = product;
    preferences!.setString(PrefKeys.products, jsonEncode(product.toList()));
  }

  static Future<RxList<ProductModel>> getProducts() async {
    await initPreferences();
    var productsString = preferences!.getString(PrefKeys.products);
    if (productsString == null || productsString.isEmpty) {
      return <ProductModel>[].obs;
    }
    List<dynamic> decoded = jsonDecode(productsString);
    return RxList(decoded.map((e) => ProductModel.fromJson(e)).toList());
  }

  // Category Product
  static Future<void> setCatgProducts(
      RxList<ProductCategoryModel> productCtgy) async {
    await initPreferences();
    categoryProduct = productCtgy;
    preferences!
        .setString(PrefKeys.categoryProduct, jsonEncode(productCtgy.toList()));
  }

  static Future<RxList<ProductCategoryModel>> getCatgProducts() async {
    await initPreferences();
    var productsString = preferences!.getString(PrefKeys.categoryProduct);
    if (productsString == null || productsString.isEmpty) {
      return <ProductCategoryModel>[].obs;
    }
    List<dynamic> decoded = jsonDecode(productsString);
    return RxList(
        decoded.map((e) => ProductCategoryModel.fromJson(e)).toList());
  }

  // sales
  static Future<void> setSales(RxList<OrderModel> saleS) async {
    await initPreferences();
    sales = saleS;
    preferences!.setString(PrefKeys.sales, jsonEncode(saleS.toList()));
  }

  static Future<RxList<OrderModel>> getSales() async {
    await initPreferences();
    var salesString = preferences!.getString(PrefKeys.sales);

    if (salesString == null || salesString.isEmpty) {
      return <OrderModel>[].obs;
    }
    List<dynamic> decoded = jsonDecode(salesString);
    RxList<OrderModel> salesList =
        RxList(decoded.map((e) => OrderModel.fromJson(e)).toList());

    return salesList;
  }

  // salesLine
  static Future<void> setSalesLine(RxList<OrderLineModel> salesLine) async {
    await initPreferences();
    orderLine = salesLine;
    preferences!.setString(PrefKeys.salesLine, jsonEncode(salesLine.toList()));
  }

  static Future<RxList<OrderLineModel>> getSalesLine() async {
    await initPreferences();
    var salesString = preferences!.getString(PrefKeys.salesLine);
    if (salesString == null || salesString.isEmpty) {
      return <OrderLineModel>[].obs;
    }
    List<dynamic> decoded = jsonDecode(salesString);
    return RxList(decoded.map((e) => OrderLineModel.fromJson(e)).toList());
  }

  ////// ***** Invoice ****** //////
  /// Account Move

  static Future<void> setAccountMove(RxList<AccountMoveModel> account) async {
    await initPreferences();
    accountMove = account;
    preferences!.setString(PrefKeys.accountMove, jsonEncode(account.toList()));
  }

  static Future<RxList<AccountMoveModel>> getAccountMove() async {
    await initPreferences();
    var accountMoveString = preferences!.getString(PrefKeys.accountMove);
    if (accountMoveString == null || accountMoveString.isEmpty) {
      return <AccountMoveModel>[].obs;
    }
    List<dynamic> decoded = jsonDecode(accountMoveString);
    return RxList(decoded.map((e) => AccountMoveModel.fromJson(e)).toList());
  }

  // Account Journal

  static Future<void> setAccountJournal(
      RxList<AccountJournalModel> account) async {
    await initPreferences();
    accountJournal = account;
    preferences!
        .setString(PrefKeys.accountJournal, jsonEncode(account.toList()));
  }

  static Future<RxList<AccountJournalModel>> getAccountJournal() async {
    await initPreferences();
    var accountJournalString = preferences!.getString(PrefKeys.accountJournal);
    if (accountJournalString == null || accountJournalString.isEmpty) {
      return <AccountJournalModel>[].obs;
    }
    List<dynamic> decoded = jsonDecode(accountJournalString);
    return RxList(decoded.map((e) => AccountJournalModel.fromJson(e)).toList());
  }
}
