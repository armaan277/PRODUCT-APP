class Endponts {
  static const _baseEndpoint = 'https://ecommerce-rendered.onrender.com';
  static const loginEndPoint = '$_baseEndpoint/login';
  static const signUpEndPoint = '$_baseEndpoint/signup';

// All Get End Points
  static const getAllProductsEndPoint = '$_baseEndpoint/products';
  static const getUserCartsProductsEndPoint = '$_baseEndpoint/cartproducts';
  static const getUserFavouritesEndPoint = '$_baseEndpoint/favorite';
  static const getUserAddressEndPoint = '$_baseEndpoint/address';
  static const getUserOrdersEndPoint = '$_baseEndpoint/myorders';
  static const getUserOrderItemsEndPoint = '$_baseEndpoint/bookingcarts';
  static const getUserReviewsEndPoint = '$_baseEndpoint/reviews';

// All Post End Points
  static const postUserCartProductsEndPoint = '$_baseEndpoint/cartproducts';
  static const postUserFavouriteEndPoint = '$_baseEndpoint/favorite';
  static const postUserAddressIDEndPoint = '$_baseEndpoint/orderslist';
  static const postUserAddressEndPoint = '$_baseEndpoint/address';
  static const postUserReviewsEndPoint = '$_baseEndpoint/reviews';

// All Patch End Points
  static const patchUserAddressEndPoint = '$_baseEndpoint/address';
  static const patchUserCartQtyUpdateEndPoint ='$_baseEndpoint/cartproducts/updateQuantity';

// All Delete End Points
  static const deleteUserCartProductsEndPoint = '$_baseEndpoint/cartproducts';
  static const deleteUserFavouriteEndPoint = '$_baseEndpoint/favorite';
  static const deleteUserOrderCartsProducts ='$_baseEndpoint/ordercartproducts';
}
