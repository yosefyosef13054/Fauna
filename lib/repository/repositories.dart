import 'package:fauna/models/breederDetail_model.dart';
import 'package:fauna/models/breederList_model.dart';
import 'package:fauna/models/breeder_infoModel.dart';
import 'package:fauna/models/chat_history.dart';
import 'package:fauna/models/chat_list.dart';
import 'package:fauna/models/complaint_model.dart';
import 'package:fauna/models/disputes_model.dart';
import 'package:fauna/models/explore.dart';
import 'package:fauna/models/filter_model.dart';
import 'package:fauna/models/home_model.dart';
import 'package:fauna/models/main_search.dart';
import 'package:fauna/models/paymentHistoryModel.dart';
import 'package:fauna/models/post_model.dart';
import 'package:fauna/models/posts_model.dart';
import 'package:fauna/models/profile_model.dart';
import 'package:fauna/models/rating_model.dart';
import 'package:fauna/models/register_model.dart';
import 'package:fauna/models/showAllBreedsModel.dart';
import 'package:fauna/models/sub_category.dart';
import 'package:fauna/models/user_model.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/supportingClass/constants.dart';

class HomeRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<HomeModelClass> getHomeData(bodyParam) async {
    var response;
    if (isGuestLogin) {
      response = await _apiProvider.postWithToken(HOMEAPI, bodyParam);
    } else {
      response = await _apiProvider.postWithToken(HOMEAPI, bodyParam);
    }
    return HomeModelClass.fromJson(response);
  }
}

class RegisterRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<RegisterModelClass> getRegisterData(Map<String, dynamic> data) async {
    final response = await _apiProvider.post(REGISTER_API, data);
    return RegisterModelClass.fromJson(response);
  }
}

class LoginRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<UserModelClass> getLoginData(Map<String, dynamic> data) async {
    final response = await _apiProvider.post(LOGIN_API, data);
    return UserModelClass.fromJson(response);
  }
}

class SocialRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<UserModelClass> getLoginData(Map<String, dynamic> data) async {
    final response = await _apiProvider.post(SOCIAL_LOGIN_API, data);
    return UserModelClass.fromJson(response);
  }
}

class OTPRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<UserModelClass> getData(Map<String, dynamic> data) async {
    final response = await _apiProvider.post(VERIFY_OTP, data);
    return UserModelClass.fromJson(response);
  }

  Future<UserModelClass> sendOtp(Map<String, dynamic> data) async {
    final response = await _apiProvider.post(FORGOT_OTP, data);
    return UserModelClass.fromJson(response);
  }
}

class SetPasswordRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<UserModelClass> resendOTP(Map<String, dynamic> data) async {
    final response = await _apiProvider.post(RESET_PASS, data);
    return UserModelClass.fromJson(response);
  }
}

class ResendOTPRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<ResendModelClass> resendOTP(Map<String, dynamic> data) async {
    final response = await _apiProvider.post(RESEND_OTP, data);
    return ResendModelClass.fromJson(response);
  }
}

class ForgetRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<ResendModelClass> forgotPassword(Map<String, dynamic> data) async {
    final response = await _apiProvider.post(FORGOT_API, data);
    return ResendModelClass.fromJson(response);
  }
}

class FilterRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<FilterModelClass>> getFilterData() async {
    final response = await _apiProvider.get(FILTERS_API);
    List eventList;
    eventList = response
        .map<FilterModelClass>((json) => FilterModelClass.fromJson(json))
        .toList();
    return eventList;
  }
}

class LogoutRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<ResendModelClass> logoutAPI() async {
    final response = await _apiProvider.getWithToken(LOGOUT_API, null);
    return ResendModelClass.fromJson(response);
  }
}

class SubCategoryRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<SubCategoryModelClass>> getsubCategoriesData(id) async {
    final response = await _apiProvider.get(SELECTED_SUBCATEGORY_API + id);
    List eventList;
    eventList = response
        .map<SubCategoryModelClass>(
            (json) => SubCategoryModelClass.fromJson(json))
        .toList();
    return eventList;
  }
}

class PostDetailRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<PostModelClass> getPostDetailAPI(id) async {
    var response;
    if (isGuestLogin) {
      response = await _apiProvider.get(POST_DETAIL_API + id);
    } else {
      response = await _apiProvider.getWithToken(POST_DETAIL_API + id, null);
    }

    return PostModelClass.fromJson(response);
  }
}

class PostsRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<PostsModel>> getPosts(data) async {
    var response;
    if (isGuestLogin) {
      response = await _apiProvider.post(SELECTED_CATEGORY_API, data);
    } else {
      response = await _apiProvider.postWithToken(SELECTED_CATEGORY_API, data);
    }
    List eventList;
    eventList =
        response.map<PostsModel>((json) => PostsModel.fromJson(json)).toList();
    return eventList;
  }
}

class FavRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<ResendModelClass> favourite(data) async {
    final response = await _apiProvider.postWithToken(FAVORITE_API, data);
    return ResendModelClass.fromJson(response);
  }
}

class FavListRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<PostsModel>> getFavPosts() async {
    final response = await _apiProvider.getWithToken(FAVORITE_LIST_API, null);
    List eventList;
    eventList =
        response.map<PostsModel>((json) => PostsModel.fromJson(json)).toList();
    return eventList;
  }

  Future<List<PostsModel>> getFeaturedPets(params) async {
    var response;
    if (isGuestLogin) {
      response = await _apiProvider.post(FEATURED_PETS, params);
    } else {
      response = await _apiProvider.postWithToken(FEATURED_PETS, params);
    }
    List eventList;
    eventList =
        response.map<PostsModel>((json) => PostsModel.fromJson(json)).toList();
    return eventList;
  }
}

class FilterPostRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<PostsModel>> getFilteredPosts(params) async {
    final response = await _apiProvider.post(FILTER_POSTS_API, params);
    List eventList;
    eventList =
        response.map<PostsModel>((json) => PostsModel.fromJson(json)).toList();
    return eventList;
  }
}

class ProfileRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<UserProfileModel> getUser() async {
    final response = await _apiProvider.getWithToken(PROFILE, null);
    return UserProfileModel.fromJson(response);
  }
}

class InfoModelRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<BreederInfoModelClass> breederInfo(data) async {
    final response = await _apiProvider.postWithToken(BREEDERINFO, data);
    return BreederInfoModelClass.fromJson(response);
  }
}

class EditProfileRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<UserProfileModel> editUser(data) async {
    final response = await _apiProvider.postWithToken(EDIT_PROFILE, data);
    return UserProfileModel.fromJson(response);
  }
}

class DisputesRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<DisputesModel>> disputesList(data) async {
    final response =
        await _apiProvider.postWithTokenWithoutScret(DISPUTES, data);
    List eventList;
    eventList = response
        .map<DisputesModel>((json) => DisputesModel.fromJson(json))
        .toList();
    return eventList;
  }
}

class ComplaintRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<ComplaintModel>> getComplaints() async {
    final response = await _apiProvider.getWithToken(COMPLAINT_TYPE, null);
    List eventList;
    eventList = response
        .map<ComplaintModel>((json) => ComplaintModel.fromJson(json))
        .toList();
    return eventList;
  }
}

class AddDisputeRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<ResendModelClass> addDispute(data) async {
    final response = await _apiProvider.postWithToken(ADD_DISPUTES, data);
    return ResendModelClass.fromJson(response);
  }
}

class BeederRegisterRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<UserProfileModel> editUser(data) async {
    final response = await _apiProvider.postWithToken(EDIT_PROFILE, data);
    return UserProfileModel.fromJson(response);
  }
}

class SearchHomeRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<MainSearchModel>> search(data) async {
    final response = await _apiProvider.post(SEARCH, data);
    List eventList;
    eventList = response
        .map<MainSearchModel>((json) => MainSearchModel.fromJson(json))
        .toList();
    return eventList;
  }
}

class SearchCategoryRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<SubCategoryModelClass>> searchCategory(data) async {
    final response = await _apiProvider.post(SEARCH_CATEGORY, data);
    List eventList;
    eventList = response
        .map<SubCategoryModelClass>(
            (json) => SubCategoryModelClass.fromJson(json))
        .toList();
    return eventList;
  }
}

class BreedersListRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<FeaturedBreederModel>> topBreederlist() async {
    final response = await _apiProvider.get(TOP_BREDEER);
    List eventList;
    eventList = response
        .map<FeaturedBreederModel>(
            (json) => FeaturedBreederModel.fromJson(json))
        .toList();
    return eventList;
  }
}

class BeederDetailRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<BreederDetailModel> getBreederDetail(data) async {
    final response = await _apiProvider.post(BREEDER_DETAILS, data);
    return BreederDetailModel.fromJson(response);
  }
}

class ChangePassRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<UserProfileModel> chnagePass(data) async {
    final response = await _apiProvider.postWithToken(CHANGE_PASS, data);
    return UserProfileModel.fromJson(response);
  }
}

class EmailOTPRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<UserProfileModel> getData(Map<String, dynamic> data) async {
    final response = await _apiProvider.post(CHANGEEMAIL_VERIFY_OTP, data);
    return UserProfileModel.fromJson(response);
  }
}

class DeleteRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<ResendModelClass> deletePost(Map<String, dynamic> data) async {
    final response = await _apiProvider.post(DELETE_POSTIMG, data);
    return ResendModelClass.fromJson(response);
  }
}

class ChatListRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<ChatList>> getChatList() async {
    final response = await _apiProvider.getWithToken(GET_CHATLIST, null);
    List eventList;
    eventList =
        response.map<ChatList>((json) => ChatList.fromJson(json)).toList();
    return eventList;
  }
}

class ChatMessagesRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<ChatHistory>> getMessages(Map<String, dynamic> data) async {
    final response = await _apiProvider.postWithToken(GET_MESSAGES, data);
    List eventList;
    eventList = response
        .map<ChatHistory>((json) => ChatHistory.fromJson(json))
        .toList();
    return eventList;
  }
}

class ExploreRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<ExploreModelClass>> explore(dataParams) async {
    final response = await _apiProvider.postWithToken(EXPLORE, dataParams);
    List eventList;
    eventList = response
        .map<ExploreModelClass>((json) => ExploreModelClass.fromJson(json))
        .toList();
    return eventList;
  }
}

class RateRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<RateModelClass> rateOwner(Map<String, dynamic> data) async {
    final response = await _apiProvider.postWithToken(GIVEFEEDBACK, data);
    return RateModelClass.fromJson(response);
  }
}

class PayHistoryRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<List<PaymentHistoryModel>> getHistory(data) async {
    final response = await _apiProvider.getWithToken(PAYMENTHISTORY, null);
    List eventList;
    eventList = response
        .map<PaymentHistoryModel>((json) => PaymentHistoryModel.fromJson(json))
        .toList();
    return eventList;
  }
}

class MarkHomeRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<MarkModel> rateOwner(Map<String, dynamic> data) async {
    final response = await _apiProvider.postWithToken(HOMEFOUND, data);
    return MarkModel.fromJson(response);
  }
}

class ShowAllBreedRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<ShowAllBreedsModel> showBreeds(Map<String, dynamic> data, page) async {
    final response = await _apiProvider.postWithToken(
        ALLCATEGORYPOST + "?page=" + page.toString(), data);
    return ShowAllBreedsModel.fromJson(response);
  }
}
