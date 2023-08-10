import 'package:hive_flutter/adapters.dart';
import 'package:hrms/logic/auth_bloc/auth_bloc.dart';
import 'package:hrms/logic/auth_bloc/auth_event.dart';
import 'package:hrms/logic/auth_bloc/auth_state.dart';
import 'package:hrms/logic/email_bloc/email_bloc.dart';
import 'package:hrms/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/screens/model/user.dart';
import 'repositories/repositories.dart';
import 'screens/auth/intro_screen.dart';
import 'package:hrms/style/theme.dart' as Style;

void main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox('data');
  final userRepository = UserRepository();

  final _MyBox = Hive.box('data');
  _MyBox.put("userRepository", userRepository);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) {
            return AuthenticationBloc(userRepository: userRepository)
              ..add(AppStarted());
          },
        ),
        BlocProvider<EmailBloc>(
          create: (BuildContext context) => EmailBloc(userRepository),
        ),
      ],
      child: MainPageRoute(userRepository: userRepository),
    ),
  );
}

class MainPageRoute extends StatefulWidget {
  final UserRepository userRepository;

  MainPageRoute({Key? key, required this.userRepository}) : super(key: key);

  @override
  State<MainPageRoute> createState() => _MainPageRouteState();
}

class _MainPageRouteState extends State<MainPageRoute> {
  @override
  void initState() {
    final _MyBox = Hive.box('data');
    _MyBox.put("baseUrl", "3.232.33.84");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('mn', 'MN'),
      theme: ThemeData(
        fontFamily: 'Rubik',
        primarySwatch: Colors.blueGrey,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return MainScreen(userRepository: widget.userRepository,);
          }
          if (state is AuthenticationUnauthenticated) {
            return IntroPage(userRepository: widget.userRepository);
          }
          if (state is AuthenticationLoading) {
            return Scaffold(
              body: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    SizedBox(
                      height: 25.0,
                      width: 25.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Style.Colors.mainColor),
                        strokeWidth: 4.0,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            body: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    height: 25.0,
                    width: 25.0,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Style.Colors.mainColor),
                      strokeWidth: 4.0,
                    ),
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
