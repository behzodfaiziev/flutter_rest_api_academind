// SPApp.saveUserNameSP(userName);
import 'package:academind_api_rest/providers/auth.dart';
import 'package:academind_api_rest/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'providers/auth.dart';
import 'utils/shared_preferences.dart';
import 'package:jose/jose.dart';

class Wrapper extends StatelessWidget {
  static const routeWrapper = '/wrapper';

  Wrapper({Key key, this.auth}) : super(key: key);
  final Auth auth;

  //
  // getUserInfo() async {
  //   print('Step2');
  //   //TODO: this function should be at the top of all widgets after main();
  //   Constants.userName = await SPApp.getUserNameSP();
  //   Constants.email = await SPApp.getUserEmailSP();
  //   Constants.imageUrl = await SPApp.getUserImageUrlSP();
  //   print('Step 2.1');
  //   Constants.userId = await SPApp.getToken();
  //
  //   print('Step 2.2');
  //
  //   print('GEtttttitngggg TOKEN : ${Constants.userId}');
  // }

  @override
  Widget build(BuildContext context) {
    print('ROLE IS: ${Constants.role}');

    Future<void> _logout() async {
      await Provider.of<Auth>(context, listen: false).logout();
    }

    String role = Constants.role;

    Future<dynamic> _getToken() async {
      Constants.token = await SPApp.getToken();
      Constants.userName = await SPApp.getUserNameSP();
      Constants.email = await SPApp.getUserEmailSP();
      Constants.imageUrl = await SPApp.getUserImageUrlSP();
      var jwt = JsonWebToken.unverified(Constants.token);
      role = jwt.claims['role'];
      // print('claims: ${jwt.claims['role']}');
      // print('claims: ${jwt.claims}');

      return role;
    }

    // _getToken();

    return FutureBuilder(
        future: _getToken(),
        builder: (ctx, snap) {
          if (snap.hasData && snap.data != null) {
            final role = snap.data;
            switch (role) {
              // case 'admin':
              //   {
              //     return AdminScreen();
              //   }
              //   break;

              case 'client':
                {
                  return Material(
                     child: Scaffold(
                       appBar: AppBar(
                         title: Text('Welcome: $role'),
                  actions: [
                    FlatButton.icon(
                      onPressed: () async {
                        _logout();
                        // SPApp.saveToken(null);
                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                        // await prefs.setString('token', '');
                        // print('3UserID: ${Constants.userId}');
                        // await prefs.setString('userId', '');
                        // print('4UserID: ${Constants.userId}');
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      icon: Icon(Icons.send),
                      label: Text("Logout"),
                    )
                  ],
                       ),
                     ),
                  );
                }
                break;
              // case 'mediator':
              //   {
              //     return Provider<Database>(
              //         create: (_) => FirestoreDatabase(
              //             uid: _fireAuth.currentUser.uid),
              //         child: MediatorMainScreen());
              //   }
              //   break;

              // case 'supplier':
              //   {
              //     return Provider<Database>(
              //         create: (_) => FirestoreDatabase(
              //             uid: _fireAuth.currentUser.uid),
              //         child: SupplierMainScreen());
              //   }
              //   break;
            }
            print('FUTUREBUILDER: $snap');
            return Scaffold(
              appBar: AppBar(
                title: Text('Welcome $snap'),
                actions: [
                  FlatButton.icon(
                    onPressed: () async {
                      _logout();
                      // SPApp.saveToken(null);
                      // SharedPreferences prefs = await SharedPreferences.getInstance();
                      // await prefs.setString('token', '');
                      // print('3UserID: ${Constants.userId}');
                      // await prefs.setString('userId', '');
                      // print('4UserID: ${Constants.userId}');
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    icon: Icon(Icons.send),
                    label: Text("Logout"),
                  )
                ],
                // title: Text('Welcome'),
              ),
              body: Center(
                child: Text(snap.data),
              ),
            );
          }
          return Material(
            child: Text(
              'Loading.....',
              style: TextStyle(color: Colors.white),
            ),
          );
          // final user = snap.data();
          // var role = user['role'];
        });
  }
}

class RoleBasedView extends StatelessWidget {
  const RoleBasedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
