import 'package:flutter/material.dart';
import 'flow_page.dart' as fp;

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return fp.FlowPage(
      flowController: fp.FlowController(
          action: "Register Account",
          title: "Register",
          flows: [
            fp.Flow("name", "Type in your Full Name", "Enter your Full Name"),
            fp.Flow("email", "Type in your Email Address",
                "Enter your Email Address",
                inputType: TextInputType.emailAddress),
            fp.Flow("number", "Type in your phone number",
                "Enter your Phone Number",
                inputType: TextInputType.number),
            fp.Flow("company", "Type in your company name", "Company Name"),
            fp.Flow("password", "Type in your password", "Setup a Password",
                inputType: TextInputType.visiblePassword, isPassword: true),
          ],
          isLogin: false,
          reverseAction: () {
            Navigator.of(context).pushReplacementNamed("/login");
          }),
    );
  }
}
