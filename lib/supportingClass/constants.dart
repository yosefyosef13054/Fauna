import 'package:flutter/material.dart';

const kMainHeading = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 28,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold);

const kSubHeading = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 14,
    color: Color(0xFF595959),
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400);

const kTextFeildStyle = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600);

const ksubButtonStyle = TextStyle(
    fontFamily: "Montserrat",
    fontStyle: FontStyle.normal,
    fontSize: 12,
    fontWeight: FontWeight.w600);

const kButtontyle = TextStyle(
    fontFamily: "Montserrat",
    fontStyle: FontStyle.normal,
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600);
const kButtontyleUnselect = TextStyle(
    fontFamily: "Montserrat",
    fontStyle: FontStyle.normal,
    color: Color(0xFF9C27B0),
    fontSize: 20,
    fontWeight: FontWeight.w600);
const space = SizedBox(
  height: 5,
);

const kHeading = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600);

const kDrawerstyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  fontFamily: "Montserrat",
);

const String NO_INTERNET = "No Internet Connections";
var isGuestLogin = false;

//Sharedprefrence keys
const String AUTHTOKEN = "auth_token";
const String USERID = "user_id";
const String USERNAME = "user_name";
const String USERPHONE = "user_phone";
const String USERPROFILE = "user_profile";
const String USEREMAIL = "user_email";
const String USERPASSWORD = "user_password";
const String ISBREEDER = "is_breeder";
const String GETROUTE = "get_route";
const String STRIPECUSTOMERID = "stripecustomerid";
const String ADDRESS = "address";
const String LATITUDE = "latitude";
const String LONGITUDE = "longitude";
const String FCMTOKEN = "fcm_token";

//APIS
const String HOMEAPI = "home";
const String REGISTER_API = "register";
const String LOGIN_API = "login";
const String SOCIAL_LOGIN_API = "socialLogin";
const String VERIFY_OTP = "verifyEmail";
const String FILTERS_API = "fields";
const String RESEND_OTP = "resendVerifyCode";
const String FORGOT_API = "forgotPassword";
const String LOGOUT_API = "logout";
const String SELECTED_CATEGORY_API = "categoryPost";
const String SELECTED_SUBCATEGORY_API = "subCategories/";
const String POST_DETAIL_API = "post/";
const String FAVORITE_API = "save_post";
const String FAVORITE_LIST_API = "favourite";
const String FILTER_POSTS_API = "posts";
const String PROFILE = "profile";
const String BREEDERVERIFICATIONB = "breederVerificationB";
const String FIELDS = "fields";
const String BREEDERPLAN = "breederPlan/";
const String SUBCATEGORIES = "subCatFields";
const String MYPOST = "myPost";
const String MYPOSTBUY = "myPostBuy";
const String POSTFIELDS = "postFields";
const String GIVEFEEDBACK = "addRating";
const String PAYMENTHISTORY = "payments";
const String MAKEBREEDER = "makeBreeder";
const String HOMEFOUND = "homefoundmanually";
const String ALLCATEGORYPOST = "allCategoryPost";

const String BREEDERINFO = "breederVerificationA";

const String EDIT_PROFILE = "updateProfile";
const String DISPUTES = "myDispute";
const String COMPLAINT_TYPE = "disputeType";

const String ADD_DISPUTES = "addDispute";

const String SEARCH = "search";
const String SEARCH_CATEGORY = "searchCategory";
const String ADDPOST = "addPost";
const String FEATUREDBREDEER = "featuredbreeders";
const String TOP_BREDEER = "topbreeders";
const String SAVEDRAFTPOST = "addDraftPost";

const String FEATURED_PETS = "featuredpets";
const String BREEDER_DETAILS = "breederDetails";

const String FORGOT_OTP = "VerifyforgotPasswordOtp";
const String RESET_PASS = "reset";
const String SECRETKEY = "secretKey";
const String TOKENKEY = "tokenKey";
const String CHANGE_PASS = "changePassword";

const String CHANGEEMAIL_VERIFY_OTP = "verifyEmailChange";

const String DELETE_POSTIMG = "deleteImage";
const String ADD_POSTIMG = "addImage";
const String EDIT_POST = "editPost";

const String SELLER_API = "becomeBreeder";
const String LICENSED_BREEDER = "becomeLicencedBreeder";
const String SEND_MSG = "sendMessages";
const String GET_CHATLIST = "getMessages";
const String GET_MESSAGES = "getconversation";
const String EXPLORE = "explore";
const String UPDATECOUNTER = "updateReadCount";
const String UPDATEPROFILEIMG = "updateProfileImg";
const String DELETEPOST = "deletePost";

String ChanelName = "";
String CURRENTSCREEN = "";
bool isInForeground = true;

//static text
const String ACCEPTEDOFFER = "Accepted Offer";
const String COUNTEROFFER = "Counter Offer";
