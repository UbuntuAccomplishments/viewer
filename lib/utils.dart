extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    Set ids = {};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension AddHtmlAnchors on String {
  String addUrlsAsHtmlAnchors() {
    return replaceAllMapped(
        RegExp(r'(https?://[^\s]+)'), (m) => '<a href="${m[1]}">${m[1]}</a>');
  }

  bool containsEmail() {
    return RegExp(r'^([^<]+)\s+<([^>]+)>$').hasMatch(this);
  }

  String addEmailsAsHtmlAnchors() {
    return replaceAllMapped(RegExp(r'^([^<]+)\s+<([^>]+@[^>]+)>$'),
        (m) => '<a href="mailto:${m[2]}">${m[1]} &lt;${m[2]}&gt;</a>');
  }

  String convertToHtmlList({bool ordered = false}) {
    if (this == "") {
      return this;
    }
    final lines = split('\n');
    if (lines.length == 1) {
      return this;
    }

    final tag = ordered ? 'ol' : 'ul';
    return '<$tag>${lines.map((l) => '<li>$l</li>').join()}</$tag>';
  }
}

bool truthy(v) => (v is bool) ? v : (v as String).toLowerCase() == "true";
