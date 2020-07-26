import 'package:flutter/material.dart';
import 'flow_page.dart' as fp;

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return fp.FlowPage(
      flowController: fp.FlowController(
          action: "Login Account",
          title: "Log In",
          flows: [
            fp.Flow("email", "Type in your Email Address...",
                "Enter your Email Address",
                inputType: TextInputType.emailAddress),
            fp.Flow("password", "Type in your password",
                "Enter your Email Password",
                inputType: TextInputType.visiblePassword, isPassword: true),
          ],
          isLogin: true,
          reverseAction: () {
            Navigator.of(context).pushReplacementNamed("/");
          }),
    );
  }
}
