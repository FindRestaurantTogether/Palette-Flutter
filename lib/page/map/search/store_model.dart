// http://114.71.48.94:8080/ 으로부터 받아온 데이터를 파싱하는 부분입니다.
class Store {
  final String name;
  final String road_address;
  final String jibun_address;
  final String call;
  final String category;
  final List<dynamic> opening_hour;
  final List<dynamic> theme;
  final List<dynamic> service;
  final List<dynamic> menu;
  final List<dynamic> inner_image;
  final List<dynamic> outer_image;
  final List<dynamic> menu_image;

  const Store({
    required this.name,
    required this.road_address,
    required this.jibun_address,
    required this.call,
    required this.category,
    required this.opening_hour,
    required this.theme,
    required this.service,
    required this.menu,
    required this.inner_image,
    required this.outer_image,
    required this.menu_image,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'],
      road_address: json['road_address'],
      jibun_address: json['jibun_address'],
      call: json['call'],
      category: json['category'],
      opening_hour: json['opening_hour'],
      theme: json['theme'],
      service: json['service'],
      menu: json['menu'],
      inner_image: json['inner_image'],
      outer_image: json['outer_image'],
      menu_image: json['menu_image'],
    );
  }
}
