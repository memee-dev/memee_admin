//excel

mixin AppColumn {
  static const List<String> categories = ['ID', 'Name', 'Status', 'Actions'];
  static const List<String> products = ['ID', 'Name', 'Status'];
  static const List<String> dlExecutives = ['Name', 'Email', 'PhoneNumber', 'Alloted', 'Status'];
  static const List<String> users = ['ID', 'UserName', 'Email', 'PhoneNumber', 'Verifed', 'Status'];
  static const List<String> admins = ['ID', 'Name', 'Email', 'Admin Level', 'Status'];
  static const List<String> payments = ['ID', 'User Name', 'Order Id', 'Product', 'Category','Dl Name','Amount'];
}
