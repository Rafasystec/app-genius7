class ResponseMenuItem{
  ///Category reference on firebase
  final String category;
  final String description;
  final String detail;
  final String icon;
  ///This item reference on firebase
  final String id;
  final List<String>urls;
  final double price;
  final int rate;
  ResponseMenuItem(this.description,this.category,this.detail,this.price,this.urls,this.id,this.icon,this.rate);

}