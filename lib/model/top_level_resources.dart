class TopLevelResources {
  String type;
  List<Links> links;
  String releaseVersion;

  TopLevelResources({this.type, this.links, this.releaseVersion});

  TopLevelResources.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    if (json['links'] != null) {
      links = List<Links>.empty(growable: true);
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
    releaseVersion = json['releaseVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = this.type;
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    data['releaseVersion'] = this.releaseVersion;
    return data;
  }
}

class Links {
  String type;
  String rel;
  String href;
  String method;

  Links({this.type, this.rel, this.href, this.method});

  Links.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    rel = json['rel'];
    href = json['href'];
    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = this.type;
    data['rel'] = this.rel;
    data['href'] = this.href;
    data['method'] = this.method;
    return data;
  }
}