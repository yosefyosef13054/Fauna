import 'package:share/share.dart';

void share({var type, var id}) {
  if (type == "pet") {
    var message = "check out my website ";
    var link = "https://fauna.live/adminportal/deeplink/pet/$id";
    Share.share('${message} ${link}');
  } else { //invite
    var message = "check out my website ";
    var link = "https://fauna.live/adminportal/deeplink/invite";
    Share.share('${message} ${link}');
  }
}
