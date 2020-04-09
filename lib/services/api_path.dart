class APIPath {

  //  static const String host = "s-tm.herokuapp.com";
//  static const String getSubjectsUrl = "http://$host/api/subjects";

  static const String host = "192.168.0.13:8080";
  static const String authenticateUrl = "http://$host/api/authenticate";
  static const String accountUrl = "http://$host/api/account";
  static const String logoutUrl = "http://$host/api/logout";

  static const String getMeasuresUrl = "http://$host/api/measures?page=0&size=20&sort=date,asc";
  static const String createOrUpdateMeasureUrl = "http://$host/api/measures";
  static const String deleteMeasureUrl = "http://$host/api/measures/{id}";
}
