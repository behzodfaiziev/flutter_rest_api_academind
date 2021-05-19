class Constants {
  static String appName = 'Sadovod';
  static String userName = '';
  static String token = '';

  // static String mediatorId = '';
  // static String userName = '';
  static String userId = '';
  static String email = '';
  static String role = '';
  static String imageUrl = '';

  //client
  static String clientId = userId;
  static String clientFullName = userName;
  static String clientAddress = 'адресс пока не назначен, функция недоступна';

//supplier
  static String supplierId = userId;
  static String supplierFullName = userName;
  static String supplierAddress = 'адресс пока не назначен, функция недоступна';

//mediator
  static String mediatorId = '';
  static bool mediatorVerified = false;

//TODO: добавить функцию чтоб посредник назначил значения по умолчанию при регистрации и после чтоб могет отредактировать
  static int mediatorOrgSbor = 10;
  static String mediatorPaymentInfo = '94341458329';

  //fotoQuality
  static int imageQHighest = 1;

  static int imageQHigh = 2;

  static int imageQMedium = 3;

  static int imageQLow = 4;

  static int imageQLowest = 5;
}
