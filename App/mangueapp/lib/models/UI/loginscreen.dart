import 'package:flutter/material.dart';
import 'package:mangueapp/bloc/blocs/user_bloc_provider.dart';
import 'package:mangueapp/init.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback login;
  final bool newUser;

  const LoginPage({Key key, this.login, this.newUser}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCont = new TextEditingController();
  TextEditingController usernameCont = new TextEditingController();
  TextEditingController firstCont = new TextEditingController();
  TextEditingController passwordCont = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: widget.newUser ? getSignupPage() : getSigninPage()
      ),
    );
  }

  Widget getSigninPage(){
    TextEditingController usernameText = new TextEditingController();
    TextEditingController passwordText = new TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(crab, width: 134),
        Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 45),
          child: Text(
            'Manguezal',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Ageoextrabold',
              fontSize: 40,
              color: logoColor
            )
          ),
        ),
        Container(
          height: 50,
          width: 330,
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
            Container(
              child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextField(
                  onSubmitted: (value) {
                    if (usernameText.text != null || passwordText.text != null){
                      userBloc.signinUser(usernameText.text, passwordText.text, "").then((_){
                        widget.login();
                      });
                    }
                  },
                  controller: usernameText,
                  style: TextStyle(
                    fontFamily: 'Ageo',
                    fontSize: 18,
                    color: textColor
                  ),
                  maxLength: 28,
                  decoration: InputDecoration(
                    hintText: "Usuário",
                    hintStyle: TextStyle(
                      fontFamily: 'Ageo',
                      fontSize: 18,
                      color: textColor
                    ),
                    border: InputBorder.none,
                    counterText: ''
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: textColor,
                  width: 1
                )
              ),
            ),
            ]
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Container(
            height: 50,
            width: 330,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    onSubmitted: (value) {
                      if (usernameText.text != null || passwordText.text != null){
                        userBloc.signinUser(usernameText.text, passwordText.text, "").then((_){
                          widget.login();
                        });
                      }
                    },
                    controller: passwordText,
                    obscureText: true,
                    style: TextStyle(
                      fontFamily: 'Ageo',
                      fontSize: 18,
                      color: textColor
                    ),
                    maxLength: 28,
                    decoration: InputDecoration(
                      hintText: "Senha",
                      hintStyle: TextStyle(
                        fontFamily: 'Ageo',
                        fontSize: 18,
                        color: textColor
                      ),
                      border: InputBorder.none,
                      counterText: ''
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: textColor,
                    width: 1
                  )
                ),
              ),
              ]
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 55, 0, 0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
            GestureDetector(
              onTap: () {
                if (usernameText.text != null || passwordText.text != null){
                  userBloc.signinUser(usernameText.text, passwordText.text, "").then((_){
                    widget.login();
                  });
                }
              },
              child: Container(
                height: 30,
                width: 130,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Ageoextrabold',
                      fontSize: 18,
                      color: textColor
                    )
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: textColor,
                    width: 1
                  )
                ),
              ),
            ),
            ]
          ),
        )
      ],
    );
  }

  Widget getSignupPage(){
    return Column(children: <Widget>[
      TextField(
        controller: emailCont,
        decoration: InputDecoration(
          hintText: 'Email'
        )
      ),
      TextField(
        controller: usernameCont,
        decoration: InputDecoration(
          hintText: 'Username'
        )
      ),
      TextField(
        controller: firstCont,
        decoration: InputDecoration(
          hintText: 'First name'
        )
      ),
      TextField(
        controller: passwordCont,
        decoration: InputDecoration(
          hintText: 'password'
        )
      ),
      FlatButton(
        color: Colors.red,
        child: Text('sign up'),
        onPressed: () {
          userBloc.registerUser(usernameCont.text, firstCont.text, '', passwordCont.text, emailCont.text).then((_) {
            widget.login();
          });
        }
      )
    ],
    );
  }
}