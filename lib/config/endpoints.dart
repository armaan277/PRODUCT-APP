class EndPoints {
  // static const _baseEndpoint = 'https://ecommerce-rendered.onrender.com';
  static const baseEndpoint = 'http://192.168.0.104:3000'; 

  static const loginEndPoint = '$baseEndpoint/login';
  static const signUpEndPoint = '$baseEndpoint/signup';

// All Get End Points
  static const getAllProductsEndPoint = 'productss'; //
  static const getUserCartsProductsEndPoint = 'cartproducts';
  static const getUserFavouritesEndPoint = 'favorite';
  static const getUserAddressEndPoint = '$baseEndpoint/address';
  static const getUserOrdersEndPoint = '$baseEndpoint/myorders';
  static const getUserOrderItemsEndPoint = '$baseEndpoint/bookingcarts';
  static const getAllReviewsEndPoint = '$baseEndpoint/reviews';
  static const getUserDetailsEndPoint = '$baseEndpoint/signup';
  static const getUserReviewsEndPoint = '$baseEndpoint/userreviews';

// All Post End Points
  static const postUserCartProductsEndPoint = '$baseEndpoint/cartproducts';
  static const postUserFavouriteEndPoint = '$baseEndpoint/favorite';
  static const postUserAddressIDEndPoint = '$baseEndpoint/orderslist';
  static const postUserAddressEndPoint = '$baseEndpoint/address';
  static const postUserReviewsEndPoint = '$baseEndpoint/reviews';

// All Patch End Points
  static const patchUserAddressEndPoint = '$baseEndpoint/address';
  static const patchUserCartQtyUpdateEndPoint =
      '$baseEndpoint/cartproducts/updateQuantity';
  static const cancelStatusInDatabaseEndPoint = '$baseEndpoint/orderlist';

// All Delete End Points
  static const deleteUserCartProductsEndPoint = 'cartproducts';
  static const deleteUserFavouriteEndPoint = 'favorite';
  static const deleteUserOrderCartsProducts =
      '$baseEndpoint/ordercartproducts';

// Google SignUp End Points
  static const checkEmailEndpoint = '$baseEndpoint/check-email';
  static const googleSignupEndpoint = '$baseEndpoint/google-signup';

  // OTP End Points
  static const sendOTPEndpoint = '$baseEndpoint/send-otp';
  static const validateOTPEndpoint = '$baseEndpoint/validate-otp';

  // Forget Password
  static const forgetPasswordEndpoint = '$baseEndpoint/forget-password';
  static const updatePasswordEndpoint = '$baseEndpoint/update-password';
}
