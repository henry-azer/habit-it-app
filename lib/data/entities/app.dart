class App {
  late bool init;
  late String initDate;
  late String lastDate;

  App({
    this.init = false,
    this.initDate = "",
    this.lastDate = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'init': init,
      'initDate': initDate,
      'lastDate': lastDate,
    };
  }

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      init: json['init'] ?? false,
      initDate: json['initDate'] ?? "",
      lastDate: json['lastDate'] ?? "",
    );
  }
}
