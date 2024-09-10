import 'package:fauna/class/email_validator.dart';
import 'package:fauna/home/chat_class.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:flutter/material.dart';

Future<Map> showDialogForNameEmail(
    {nameController, emailController, contexts}) {
  return showDialog(
      context: contexts,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.only(top: 0.0),
            content: StatefulBuilder(
                // You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Color(0xff9C27B0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                      ),
                      child: Text(
                        "User Detail",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      child: normalTextfield(
                          hintText: 'Enter Name',
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          borderColour: Colors.black45,
                          context: context),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      child: normalTextfield(
                          hintText: 'Enter Email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          borderColour: Colors.black45,
                          context: context),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 50.0,
                        child: fullColouredBtn(
                            text: "Submit",
                            radiusButtton: 20.0,
                            onPressed: () async {
                              var name = nameController.text.trim().toString();
                              var email =
                                  emailController.text.trim().toString();
                              final bool emailValid =
                                  EmailValidator.validate(email);
                              if (name == null || name == "") {
                                showToast("Please enter name");
                              } else if (emailValid) {
                                Map map = {"name": name, "email": email};
                                Navigator.pop(context,map);
                                return map;
                              } else {
                                showToast("Please enter right email");
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              );
            }));
      });
}
