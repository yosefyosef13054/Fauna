import 'dart:async';

import 'package:fauna/models/breederDetail_model.dart';
import 'package:fauna/models/breederList_model.dart';
import 'package:fauna/models/complaint_model.dart';
import 'package:fauna/models/disputes_model.dart';
import 'package:fauna/models/explore.dart';
import 'package:fauna/models/filter_model.dart';
import 'package:fauna/models/home_model.dart';
import 'package:fauna/models/main_search.dart';
import 'package:fauna/models/post_model.dart';
import 'package:fauna/models/posts_model.dart';
import 'package:fauna/models/rating_model.dart';
import 'package:fauna/models/showAllBreedsModel.dart';
import 'package:fauna/models/sub_category.dart';
import 'package:fauna/models/user_model.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/repository/repositories.dart';

class HomeBloc {
  HomeRepository _repository;
  StreamController _blocController;
  StreamSink<Response<HomeModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<HomeModelClass>> get loginStream => _blocController.stream;

  HomeBloc() {
    _blocController = StreamController<Response<HomeModelClass>>();
    _repository = HomeRepository();
    // getHomeData(param);
  }

  getHomeData(bodyParams) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      HomeModelClass loginData = await _repository.getHomeData(bodyParams);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));

      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class FilterBloc {
  FilterRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<FilterModelClass>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<FilterModelClass>>> get loginStream =>
      _blocController.stream;

  FilterBloc() {
    _blocController = StreamController<Response<List<FilterModelClass>>>();
    _repository = FilterRepository();
    getFilterData();
  }

  getFilterData() async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<FilterModelClass> loginData = await _repository.getFilterData();
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));

      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class SubcategoryBloc {
  SubCategoryRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<SubCategoryModelClass>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<SubCategoryModelClass>>> get loginStream =>
      _blocController.stream;

  SubcategoryBloc() {
    _blocController = StreamController<Response<List<SubCategoryModelClass>>>();
    _repository = SubCategoryRepository();
    //  getFilterData();
  }

  getSubCategoryData(id) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<SubCategoryModelClass> loginData =
          await _repository.getsubCategoriesData(id);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));

      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class PostDetailBloc {
  PostDetailRepository _repository;
  StreamController _blocController;
  StreamSink<Response<PostModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<PostModelClass>> get loginStream => _blocController.stream;

  PostDetailBloc() {
    _blocController = StreamController<Response<PostModelClass>>();
    _repository = PostDetailRepository();
  }

  getPostData(id) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      PostModelClass loginData = await _repository.getPostDetailAPI(id);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));

      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class PostListBloc {
  PostsRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<PostsModel>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<PostsModel>>> get loginStream => _blocController.stream;

  PostListBloc() {
    _blocController = StreamController<Response<List<PostsModel>>>();
    _repository = PostsRepository();
  }

  getPosts(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<PostsModel> loginData = await _repository.getPosts(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class FavBloc {
  FavRepository _repository;
  StreamController _blocController;
  StreamSink<Response<ResendModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<ResendModelClass>> get loginStream => _blocController.stream;

  FavBloc() {
    _blocController = StreamController<Response<ResendModelClass>>();
    _repository = FavRepository();
  }

  setFavorite(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      ResendModelClass loginData = await _repository.favourite(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class FavListBloc {
  FavListRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<PostsModel>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<PostsModel>>> get loginStream => _blocController.stream;

  FavListBloc() {
    _blocController = StreamController<Response<List<PostsModel>>>();
    _repository = FavListRepository();
  }

  getFavorites() async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<PostsModel> loginData = await _repository.getFavPosts();
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  getFeaturedPets(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<PostsModel> loginData = await _repository.getFeaturedPets(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class PostFliterBloc {
  FilterPostRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<PostsModel>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<PostsModel>>> get loginStream => _blocController.stream;

  PostFliterBloc() {
    _blocController = StreamController<Response<List<PostsModel>>>();
    _repository = FilterPostRepository();
  }

  getFilteredPosts(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<PostsModel> loginData = await _repository.getFilteredPosts(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class DisputesBloc {
  DisputesRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<DisputesModel>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<DisputesModel>>> get loginStream =>
      _blocController.stream;

  DisputesBloc() {
    _blocController = StreamController<Response<List<DisputesModel>>>();
    _repository = DisputesRepository();
  }

  getDisputes(data) async {
    print("data :-" + data.toString());
    loginDataSink.add(Response.loading('loading'));
    try {
      List<DisputesModel> loginData = await _repository.disputesList(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class ComplaintBloc {
  ComplaintRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<ComplaintModel>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<ComplaintModel>>> get loginStream =>
      _blocController.stream;
  ComplaintBloc() {
    _blocController = StreamController<Response<List<ComplaintModel>>>();
    _repository = ComplaintRepository();
  }
  getComplaintType() async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<ComplaintModel> loginData = await _repository.getComplaints();
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class AddDisputeBloc {
  AddDisputeRepository _repository;
  StreamController _blocController;
  StreamSink<Response<ResendModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<ResendModelClass>> get loginStream => _blocController.stream;

  AddDisputeBloc() {
    _blocController = StreamController<Response<ResendModelClass>>();
    _repository = AddDisputeRepository();
  }

  addDisputes(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      ResendModelClass loginData = await _repository.addDispute(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class HomeSearchBloc {
  SearchHomeRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<MainSearchModel>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<MainSearchModel>>> get loginStream =>
      _blocController.stream;

  HomeSearchBloc() {
    _blocController = StreamController<Response<List<MainSearchModel>>>();
    _repository = SearchHomeRepository();
  }

  search(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<MainSearchModel> loginData = await _repository.search(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class SearchCategiryBloc {
  SearchCategoryRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<SubCategoryModelClass>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<SubCategoryModelClass>>> get loginStream =>
      _blocController.stream;

  SearchCategiryBloc() {
    _blocController = StreamController<Response<List<SubCategoryModelClass>>>();
    _repository = SearchCategoryRepository();
  }

  search(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<SubCategoryModelClass> loginData =
          await _repository.searchCategory(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class ExploreBloc {
  ExploreRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<ExploreModelClass>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<ExploreModelClass>>> get loginStream =>
      _blocController.stream;

  ExploreBloc() {
    _blocController = StreamController<Response<List<ExploreModelClass>>>();
    _repository = ExploreRepository();
  }

  explorePosts(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<ExploreModelClass> loginData = await _repository.explore(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));

      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class BreederListBloc {
  BreedersListRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<FeaturedBreederModel>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<FeaturedBreederModel>>> get loginStream =>
      _blocController.stream;

  BreederListBloc() {
    _blocController = StreamController<Response<List<FeaturedBreederModel>>>();
    _repository = BreedersListRepository();
  }

  getTopBreedersList() async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<FeaturedBreederModel> loginData = await _repository.topBreederlist();
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));

      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class BreederDetailBloc {
  BeederDetailRepository _repository;
  StreamController _blocController;
  StreamSink<Response<BreederDetailModel>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<BreederDetailModel>> get loginStream =>
      _blocController.stream;

  BreederDetailBloc() {
    _blocController = StreamController<Response<BreederDetailModel>>();
    _repository = BeederDetailRepository();
  }

  getBreederListInfo(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      BreederDetailModel loginData = await _repository.getBreederDetail(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));

      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class RateBloc {
  RateRepository _repository;
  StreamController _blocController;
  StreamSink<Response<RateModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<RateModelClass>> get loginStream => _blocController.stream;

  RateBloc() {
    _blocController = StreamController<Response<RateModelClass>>();
    _repository = RateRepository();
  }

  rateData(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      RateModelClass loginData = await _repository.rateOwner(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));

      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class ShowAllBreedsBloc {
  ShowAllBreedRepository _repository;
  StreamController _blocController;
  StreamSink<Response<ShowAllBreedsModel>> get showBreedsDataSink =>
      _blocController.sink;
  Stream<Response<ShowAllBreedsModel>> get showBreedsStream =>
      _blocController.stream;

  ShowAllBreedsBloc() {
    _blocController = StreamController<Response<ShowAllBreedsModel>>();
    _repository = ShowAllBreedRepository();
  }

  showAllBreeds(data, page) async {
    showBreedsDataSink.add(Response.loading('loading'));
    try {
      ShowAllBreedsModel loginData = await _repository.showBreeds(data, page);
      showBreedsDataSink.add(Response.completed(loginData));
    } catch (e) {
      showBreedsDataSink.add(Response.error(e.toString()));

      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}
