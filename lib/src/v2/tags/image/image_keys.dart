final class ImageKeys {
  ImageKeys._();
  static const String link = 'link';
  static const String width = 'width';
  static const String height = 'height';
}

final class BBCodeImageInfo {
  const BBCodeImageInfo(
    this.link, {
    this.width,
    this.height,
  });

  final String link;
  final int? width;
  final int? height;

  @override
  String toString() => '${ImageKeys.link}=$link, '
      '${ImageKeys.width}=$width, '
      '${ImageKeys.height}=$height';

  Map<String, dynamic> toJson() => {
        ImageKeys.link: link,
        ImageKeys.width: width,
        ImageKeys.height: height,
      };

  static BBCodeImageInfo fromJson(Map<String, dynamic> json) {
    final link = switch (json) {
      {ImageKeys.link: final String data} => data,
      _ => null,
    };
    assert(link != null, 'Link in Image delta json MUST NOT a String');

    final width = switch (json) {
      {ImageKeys.width: final int? data} => data,
      _ => null,
    };
    final height = switch (json) {
      {ImageKeys.height: final int? data} => data,
      _ => null,
    };

    return BBCodeImageInfo(
      link!,
      width: width,
      height: height,
    );
  }
}
