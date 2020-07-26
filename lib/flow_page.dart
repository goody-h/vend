import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlowPage extends StatefulWidget {
  FlowPage({Key key, this.flowController}) : super(key: key);
  final FlowController flowController;

  @override
  _FlowPageState createState() => _FlowPageState();
}

class Flow {
  Flow(this.name, this.hint, this.title,
      {this.inputType = TextInputType.text, this.isPassword = false});
  String value = "";
  final String name;
  final String hint;
  final String title;
  final TextInputType inputType;
  final bool isPassword;
}

class FlowController {
  FlowController(
      {this.flows,
      this.action,
      this.title,
      this.isLogin = false,
      this.reverseAction});
  bool isLast = true;
  bool isFirst = false;
  final String action;
  final String title;
  int index = 0;
  final List<Flow> flows;
  bool showPassword = false;
  final bool isLogin;
  final VoidCallback reverseAction;

  Flow get flow => flows[index];

  bool get hasValue => flow.value != null && flow.value != "";

  bool get showBotton => hasValue;

  bool nextFlow() {
    if (showPassword) showPassword = false;
    if (index < flows.length - 1) {
      index++;
      return true;
    }
    return false;
  }

  setValue(String value) {
    flow.value = value;
  }

  bool previousFlow() {
    if (index > 0) {
      index--;
      return false;
    }
    return true;
  }
}

class _FlowPageState extends State<FlowPage> {
  TextEditingController controller = TextEditingController();

  FlowController flowController;

  @override
  void initState() {
    super.initState();

    flowController = widget.flowController;

    controller.addListener(() {
      final value = controller.text;
      final hasvalue = flowController.hasValue;
      flowController.setValue(value);

      if (hasvalue != flowController.hasValue) setState(() {});

      print(value);
    });
  }

  _togglePasswordVisibility() {
    setState(() {
      flowController.showPassword = !flowController.showPassword;
    });
  }

  Future<bool> _onPopScope() {
    final pop = flowController.previousFlow();
    if (!pop) {
      controller.text = flowController.flow.value;
      setState(() {});
      return Future.value(false);
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 250,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          right: 0,
                          // child: SvgPicture.asset("assets/images/background.svg"),
                          child: Image.asset("assets/images/background.png"),
                        ),
                        Positioned(
                          top: 24,
                          left: 15,
                          child: Image.asset("assets/images/logo.png"),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 18),
                          child: Text(
                            flowController.title,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 26),
                          child: Text(
                            flowController.flow.title,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextField(
                            maxLines: 1,
                            keyboardType: flowController.flow.inputType,
                            obscureText: flowController.flow.isPassword &&
                                !flowController.showPassword,
                            decoration: InputDecoration(
                              suffixIcon: flowController.flow.isPassword
                                  ? GestureDetector(
                                      onTap: () {
                                        _togglePasswordVisibility();
                                      },
                                      child: Icon(
                                        flowController.showPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.24),
                                        size: 24,
                                      ),
                                    )
                                  : null,
                              hintText: flowController.flow.hint,
                              contentPadding: EdgeInsets.only(
                                top: 2,
                                bottom: 19,
                                left: 0,
                                right: 0,
                              ),
                              isDense: true,
                              hintStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(255, 255, 255, 0.24),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 255, 255, 0.24),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(255, 255, 255, 0.44),
                                  width: 1,
                                ),
                              ),
                            ),
                            cursorColor: Colors.white,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white.withOpacity(0.96),
                              fontWeight: FontWeight.w500,
                            ),
                            controller: controller),
                        Padding(
                          padding: EdgeInsets.only(top: 39),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AnimatedOpacity(
                                opacity: flowController.showBotton ? 1 : 0,
                                duration: Duration(milliseconds: 500),
                                child: IgnorePointer(
                                  ignoring: !flowController.showBotton,
                                  child: RaisedButton(
                                    onPressed: () {
                                      final next = flowController.nextFlow();
                                      if (next) {
                                        controller.clear();
                                        setState(() {});
                                        FocusManager.instance.primaryFocus
                                            .unfocus();
                                      }
                                    },
                                    color: Colors.white,
                                    child: flowController.index !=
                                            flowController.flows.length - 1
                                        ? Row(
                                            children: <Widget>[
                                              Text(
                                                "OK",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Icon(
                                                Icons.done,
                                                color: Colors.black,
                                                size: 16,
                                              )
                                            ],
                                          )
                                        : Text(
                                            flowController.action,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 80,
                                height: 33,
                                child: Stack(
                                  children: <Widget>[
                                    AnimatedPositioned(
                                      child: AnimatedOpacity(
                                        opacity: flowController.index > 0 ||
                                                flowController.hasValue
                                            ? 1
                                            : 0,
                                        duration: Duration(milliseconds: 500),
                                        child: IgnorePointer(
                                          ignoring:
                                              !(flowController.index > 0 ||
                                                  flowController.hasValue),
                                          child: Container(
                                            height: 33,
                                            width: 32,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: Color(
                                                    int.parse("0xFF514362")),
                                                width: 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_back,
                                                color: Color(
                                                    int.parse("0xFF514362")),
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      left: (flowController.index == 0 &&
                                                  !flowController.hasValue) ||
                                              flowController.index ==
                                                  flowController.flows.length -
                                                      1
                                          ? 48
                                          : 0,
                                      top: 0,
                                      duration: Duration(milliseconds: 500),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: AnimatedOpacity(
                                        opacity: flowController.index ==
                                                flowController.flows.length - 1
                                            ? 0
                                            : 1,
                                        duration: Duration(milliseconds: 500),
                                        child: IgnorePointer(
                                          ignoring: !(flowController.index ==
                                              flowController.flows.length - 1),
                                          child: Container(
                                            height: 33,
                                            width: 32,
                                            margin: EdgeInsets.only(left: 16),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Color(
                                                      int.parse("0xFF514362")),
                                                  width: 1,
                                                )),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Color(
                                                    int.parse("0xFF514362")),
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: flowController.index == 0 &&
                                  !flowController.hasValue
                              ? 1
                              : 0,
                          duration: Duration(milliseconds: 500),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 26,
                                    top: 40,
                                  ),
                                  child: Text(
                                    flowController.isLogin
                                        ? "Or login with"
                                        : "Or Register to start using",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                IgnorePointer(
                                  ignoring: (flowController.index == 0 &&
                                      !flowController.hasValue),
                                  child: RaisedButton(
                                    padding: EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 40,
                                      right: 40,
                                    ),
                                    color: Colors.white,
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          "assets/images/google.svg",
                                        ),
                                        Container(
                                          width: 15,
                                        ),
                                        Text(
                                          flowController.isLogin
                                              ? "Login with Google"
                                              : "Create account with Google",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 100, bottom: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                flowController.isLogin
                                    ? "I don't have an account?"
                                    : "Already have an account",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  flowController.reverseAction();
                                },
                                child: Text(
                                  flowController.isLogin ? "Register" : "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Color(int.parse("0xFF110027")),
        ),
        onWillPop: _onPopScope);
  }
}
