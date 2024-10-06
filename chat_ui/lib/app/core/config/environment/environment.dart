mixin Environment {
  //static Environment runningEnv = SITEnvironment();
  final String releaseVersion = "0.1.0";

  String get currentEnv => "sit";
      //const String.fromEnvironment(APIConstant.envKey);
  String get appName =>  "abha";
      //const String.fromEnvironment(APIConstant.appNameKey);
  String get baseUrl => "https://edge-abdm.sit.karkinos.in";
      //const String.fromEnvironment(APIConstant.baseURLKey);

}