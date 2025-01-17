class Endponts {
  static const loginEndPoint = 'http://192.168.0.111:3000/login';
  static const signUpEndPoint = 'http://192.168.0.111:3000/signup';

// All Get End Points
  static const getAllProductsEndPoint = 'http://192.168.0.111:3000/product';
  static const getUserCartsProductsEndPoint = 'http://192.168.0.111:3000/cartproducts/';
  static const getUserFavouritesEndPoint = 'http://192.168.0.111:3000/favorite/';
  static const getUserAddressEndPoint = 'http://192.168.0.111:3000/address/';
  static const getUserOrdersEndPoint = 'http://192.168.0.111:3000/myorders/';
  static const getUserOrderItemsEndPoint = 'http://192.168.0.111:3000/bookingcarts/';



// All Post End Points
  static const postUserCartProductsEndPoint = 'http://192.168.0.111:3000/cartproducts';
  static const postUserFavouriteEndPoint = 'http://192.168.0.111:3000/favorite';
  static const postUserAddressIDEndPoint = 'http://192.168.0.111:3000/orderslist';
  static const postUserAddressEndPoint = 'http://192.168.0.111:3000/address';

// All Patch End Points
 static const patchUserAddressEndPoint = 'http://192.168.0.111:3000/address/';
 static const patchUserCartQtyUpdateEndPoint = 'http://192.168.0.111:3000/cartproducts/updateQuantity';

  
// All Delete End Points
 static const deleteUserCartProductsEndPoint = 'http://192.168.0.111:3000/cartproducts/';
 static const deleteUserFavouriteEndPoint = 'http://192.168.0.111:3000/favorite/';
 static const deleteUserOrderCartsProducts = 'http://192.168.0.111:3000/ordercartproducts/';

 
}
