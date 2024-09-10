import 'dart:async';

import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

Future<Null> initUniLinks(context) async {
  var inviteLink = "https://fauna.live/adminportal/deeplink/invite";
  var petLink = "https://fauna.live/adminportal/deeplink/pet";
  StreamSubscription _sub;
  try {
    String initialLink = await getInitialLink();
    print("initialLink+ : " + initialLink.toString());
    // showToast(initialLink);
    // Parse the link and warn the user, if it is not correct,
    // but keep in mind it could be `null`.
    if (initialLink.toString() == "null" || initialLink.toString() == null) {
      print("initialLink+-- : " + initialLink.toString());
    } else {}
  } on PlatformException {}
  // ... check initialLink

  // Attach a listener to the stream
  _sub = getLinksStream().listen((String link) {
    print("initialLink change : " + link.toString());
    if (link.contains(inviteLink)) {
    } else if (link.contains(petLink)) {
      print("linkpet :------ " + link.toString());

      var id = link.toString().replaceAll(petLink+"/", "");
      print("id :------ " + id.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PetDetailClass(
                    id: id,
                    fromBreeder: true,
                    isPreview: false,
                    post: null,
                    images: null,
                  )));
    } else {}
  }, onError: (err) {});

  // NOTE: Don't forget to call _sub.cancel() in dispose()
}
