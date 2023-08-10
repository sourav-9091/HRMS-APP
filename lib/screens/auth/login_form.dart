import 'package:hrms/logic/login_bloc/login_bloc.dart';
import 'package:hrms/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/forgetPage.dart';
import 'package:hrms/style/theme.dart' as Style;

class LoginForm extends StatefulWidget {
  final UserRepository userRepository;
  const LoginForm({Key? key, required this.userRepository}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState(userRepository);
}

class _LoginFormState extends State<LoginForm> {
  final formkey = GlobalKey<FormState>();
  final UserRepository userRepository;

  bool passwordVisible = false;
  _LoginFormState(this.userRepository);
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          email: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login failed. Wrong Username/Password"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 80.0),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(bottom: 18.0, top: 35.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onDoubleTap: () {},
                                child: Image.asset(
                                  'assets/images/kiitLogo.png',
                                  height: 10,
                                  width: 180,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                          ],
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        /* A valid username should start with an alphabet so, [A-Za-z].
                          All other characters can be alphabets, numbers or an underscore so, [A-Za-z0-9_].
                          Since length constraint was given as 8-30 and we had already fixed the first character, so we give {7,29}.
                          We use ^ and $ to specify the beginning and end of matching.*/
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[A-Za-z][A-Za-z0-9_]{5,29}$')
                                .hasMatch(value)) {
                          return 'Please Enter Valid Username';
                        }
                        return null;
                      },
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (value) {
                        //Minimum eight characters, at least one letter and one number
                        /*||
                            !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                                .hasMatch(value) */
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Valid Password';
                        }
                        return null;
                      },
                      obscureText: passwordVisible ? false : true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        ),
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: const Text(
                        "Forget password?",
                        style: TextStyle(color: Colors.black45, fontSize: 12.0),
                      ),
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const ForgetPage(),
                      //     ),
                      //   );
                      // },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 45,
                          child: state is LoginLoading
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        SizedBox(
                                          height: 25.0,
                                          width: 25.0,
                                          child: CupertinoActivityIndicator(),
                                        )
                                      ],
                                    ))
                                  ],
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: () {
                                    if (formkey.currentState!.validate()) {
                                      onLoginButtonPressed();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Invalid Username/Password')),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(color: Style.Colors.grey),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 5.0),
                              ),
                              GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Style.Colors.mainColor,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
