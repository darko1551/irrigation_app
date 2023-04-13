import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:irrigation/constants/authorization_constants.dart';
import 'package:irrigation/feature/home/page/home_page.dart';
import 'package:irrigation/feature/widget/no_internet_widget.dart';
import 'package:irrigation/models/client_credentials.dart';
import 'package:irrigation/provider/network_provider.dart';
import 'package:irrigation/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AppLocalizations localization;
  Future<ClientCredentials?> authorizeUser() async {
    FlutterAppAuth appAuth = const FlutterAppAuth();
    final AuthorizationTokenResponse? result;
    try {
      result = await appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
          AuthorizationConstants.clientIdentifier,
          AuthorizationConstants.redirectEndpoint,
          serviceConfiguration: AuthorizationServiceConfiguration(
              authorizationEndpoint:
                  AuthorizationConstants.authorizationEndpoint,
              tokenEndpoint: AuthorizationConstants.tokenEndpoint),
          promptValues: ['login'],
          scopes: AuthorizationConstants.scopes));
    } catch (e) {
      Get.snackbar(localization.warning, localization.unsuccessfullLogin,
          backgroundColor: Theme.of(Get.context!).cardColor);
      return null;
    }
    return ClientCredentials(
        accessToken: result!.accessToken!,
        refreshToken: result.refreshToken!,
        expiration: result.accessTokenExpirationDateTime);
  }

  @override
  void initState() {
    initialization();
    super.initState();
  }

  void initialization() async {
    bool clientInitialized = false;
    ClientCredentials? clientCredentials =
        Provider.of<UserProvider>(context, listen: false).clientCredentials;
    if (clientCredentials != null) {
      await Provider.of<UserProvider>(context, listen: false)
          .setClientCredentials(clientCredentials);
      if (mounted) {
        try {
          await Provider.of<UserProvider>(context, listen: false).initUser();
          clientInitialized = true;
        } catch (e) {
          Get.snackbar("Error", e.toString(),
              backgroundColor: Theme.of(context).cardColor);
        }
      }
      if (clientInitialized) {
        Get.offAll(() => const HomePage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    bool networkStatus =
        Provider.of<NetworkProvider>(context, listen: true).networkStatus;
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.login),
        centerTitle: true,
      ),
      body: Center(
        child: networkStatus
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localization.notLoggedIn,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextButton(
                    onPressed: networkStatus
                        ? () async {
                            //await Provider.of<UserProvider>(context,
                            //      listen: false)
                            // .setClientCredentials(null);
                            bool clientInitialized = false;
                            ClientCredentials? clientCredentials =
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .clientCredentials;
                            clientCredentials ??= await authorizeUser();

                            if (clientCredentials != null) {
                              if (mounted) {
                                await Provider.of<UserProvider>(context,
                                        listen: false)
                                    .setClientCredentials(clientCredentials);
                                if (mounted) {
                                  try {
                                    await Provider.of<UserProvider>(context,
                                            listen: false)
                                        .initUser();
                                    clientInitialized = true;
                                  } catch (e) {
                                    Get.snackbar("Error", e.toString(),
                                        backgroundColor:
                                            Theme.of(context).cardColor);
                                  }
                                }
                              }
                              if (clientInitialized) {
                                Get.offAll(() => const HomePage());
                              }
                            }
                          }
                        : null,
                    child: Text(localization.login),
                  ),
                ],
              )
            : const NoInternetWidget(),
      ),
    );
  }
}
