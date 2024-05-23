import 'dart:math';

class Utility {
  static int getRandomInt(int min, int max) =>
      Random().nextInt(max - min + 1) + min;

  static List<T> rotateArray<T>(List<T> arr, int num, {bool reverse = false}) {
    List<T> resary = List.from(arr);
    for (var i = 0; i < num; i++) {
      if (reverse) {
        resary.insert(0, resary.removeLast());
      } else {
        resary.add(resary.removeAt(0));
      }
    }
    return resary;
  }

  static List<T> uniqArray<T>(List<T> arr) => arr.toSet().toList();

  static List<T> randomSort<T>(List<T> ary) {
    ary.shuffle();
    return ary;
  }
}

class Tones {
  List<String> toneAry;

  Tones(this.toneAry);

  @override
  String toString() => toneAry.toString();

  Tones normalize() {
    final chord2num = ChordFinder.getToneToNumberMap();
    final objAry = toneAry.map((e) => (e, chord2num[e]!)).toList();
    final root = objAry.first;
    objAry.sort((a, b) => a.$2.compareTo(b.$2));
    final idx = objAry.indexOf(root);
    final rotatedArray = Utility.rotateArray(objAry, idx);
    final uniqObjAry = <(String, int)>[];
    (String, int)? before;
    for (final e in rotatedArray) {
      if (before != null && before.$2 == e.$2) continue;
      uniqObjAry.add(e);
      before = e;
    }
    return Tones(uniqObjAry.map((e) => e.$1).toList());
  }

  String getRoot() => toneAry.first;

  List<String> toChords([Map<String, dynamic> options = const {}]) {
    final tones = normalize();
    final root = tones.getRoot();
    List<String> res = [];

    for (final mapType in ["standard", "generated1", "generated2"]) {
      var r = ChordFinder.find(tones.toneAry, mapType);
      if (r != null) res.addAll(r);
      print({"find": r});

      if (res.isEmpty || mapType == "generated2") {
        final tmpChordAry = List.of(tones.toneAry)..removeAt(0);
        r = ChordFinder.find(tmpChordAry, mapType);
        if (r != null) {
          res.addAll(r.map((e) => "$e/${root.toUpperCase()}"));
        }
        print({"rotate_and_onbase1": r});
        r = ChordFinder.findWithRotate(tmpChordAry, root, mapType);
        if (r != null) res.addAll(r);
        print({"rotate_and_onbase2": r});
      }

      if (res.isEmpty || mapType == "generated2") {
        r = ChordFinder.findWithRotate(tones.toneAry, root, mapType);
        if (r != null) res.addAll(r);
        print({"find_with_rotate": r});
      }
    }

    if (res.isEmpty) {
      res.add("$root?");
    } else {
      res = Utility.uniqArray(res);
      if (res.length > 1) {
        final scores = res.map((e) => _calculateScore(e)).toList();
        final maxScore = scores.reduce(max);
        if (options["detail"] == true) {
          res = res
              .asMap()
              .entries
              .map((e) => "${e.value}: ${scores[e.key]}")
              .toList();
        } else {
          res = res.where((e) => _calculateScore(e) == maxScore).toList();
        }
      }
    }

    return res;
  }

  int _calculateScore(String chord) {
    var score = 0;
    final criteria = [
      [RegExp(r'omit\d|\(+13\)'), 6],
      [RegExp(r'\([+-]?\d+\)'), 5],
      [RegExp(r'aug|6|5|[+-]\d+|add\d+|sus2'), 4],
      [RegExp(r'dim7|11|13|\/.+$|9'), 3],
      [RegExp(r'sus4|M7|7'), 2],
    ];

    for (final criterion in criteria) {
      final reg = criterion[0] as RegExp;
      final val = criterion[1] as int;
      final matches = reg.allMatches(chord);
      score -= matches.length * val;
    }

    return score;
  }

  static Tones? parse(String str) {
    var chordStr = str;
    if (RegExp(r'^[^b][^acdefg]+$').hasMatch(chordStr)) {
      chordStr = chordStr.replaceAll('b', '♭');
    }
    chordStr = chordStr
        .toLowerCase()
        .replaceAll(RegExp(r'[＃♯﹟]'), '#')
        .replaceAll(RegExp(r'[どドＣｃ]|ﾄﾞ'), 'c')
        .replaceAll(RegExp(r'[れレﾚＤｄ]'), 'd')
        .replaceAll(RegExp(r'[みミﾐＥｅ]'), 'e')
        .replaceAll(RegExp(r'[Ｆｆ]|ふぁ|ファ|ﾌｧ'), 'f')
        .replaceAll(RegExp(r'[そソｿＧｇ]'), 'g')
        .replaceAll(RegExp(r'[らラﾗＡａ]'), 'a')
        .replaceAll(RegExp(r'[しシｼＢｂ]'), 'b')
        .replaceAll(RegExp(r'[^cdefgab♭#]+'), '');
    return chordStr.isEmpty ? null : Tones(chordStr.split(RegExp(r'.[#♭]?')));
  }
}

class ChordFinder {
  static final _toneNumberTable = [
    ("c", 0),
    ("b#", 0),
    ("c#", 1),
    ("d♭", 1),
    ("d", 2),
    ("d#", 3),
    ("e♭", 3),
    ("e", 4),
    ("f♭", 4),
    ("e#", 5),
    ("f", 5),
    ("f#", 6),
    ("g♭", 6),
    ("g", 7),
    ("g#", 8),
    ("a♭", 8),
    ("a", 9),
    ("a#", 10),
    ("b♭", 10),
    ("b", 11),
    ("c♭", 11),
  ];

  static final _standardChordMap = {
    "0,7": "5",
    "0,4,7": "",
    "0,3,7": "m",
    "0,4,6": "(-5)",
    "0,3,6": "m-5",
    "0,4,8": "aug",
    "0,5,7": "sus4",
    "0,2,7": "sus2",
    "0,4,7,9": "6",
    "0,3,7,9": "m6",
    "0,4,7,10": "7",
    "0,3,7,10": "m7",
    "0,4,7,11": "M7",
    "0,3,7,11": "mM7",
    "0,4,6,10": "7-5",
    "0,3,6,10": "m7-5",
    "0,4,6,11": "M7-5",
    "0,3,6,11": "mM7-5",
    "0,5,7,10": "7sus4",
    "0,3,6,9": "dim7",
    "0,2,4,7": "add9",
    "0,2,3,7": "m(add9)",
    "0,4,5,7": "add4",
    "0,4,8,10": "aug7",
    "0,2,4,7,10": "9",
    "0,3,4,7,10": "+9",
    "0,2,3,7,10": "m9",
    "0,2,4,7,11": "M9",
    "0,2,3,7,11": "mM9",
    "0,2,4,7,9": "69",
    "0,2,3,7,9": "m69",
    "0,2,4,5,7,10": "11",
    "0,2,4,6,7,10": "+11",
    "0,2,3,5,7,10": "m11",
    "0,2,3,6,7,10": "m+11",
    "0,2,4,5,7,11": "M11",
    "0,2,3,5,7,11": "mM11",
    "0,2,4,5,7,9,10": "13",
    "0,2,3,5,7,9,10": "m13",
    "0,2,4,5,7,9,11": "M13",
    "0,2,3,5,7,9,11": "mM13",
    "0,3,4,10": "+9[omit5] ジミヘンコード",
  };

  static Map<String, int> getToneToNumberMap() {
    final res = <String, int>{};
    for (final e in _toneNumberTable) {
      res[e.$1] = e.$2;
    }
    return res;
  }

  static String toneToKana(String toneNameStr) {
    var s = toneNameStr;
    s = s
        .replaceAll('c', 'ド')
        .replaceAll('d', 'レ')
        .replaceAll('e', 'ミ')
        .replaceAll('f', 'ファ')
        .replaceAll('g', 'ソ')
        .replaceAll('a', 'ラ')
        .replaceAll('b', 'シ');
    return s;
  }

  static List<String> getToneNames([String? scale]) {
    return _toneNumberTable.map((e) => e.$1).where((e) {
      switch (scale) {
        case "#":
          return !e.contains('♭') && !e.contains(RegExp(r'b#|e#'));
        case "♭":
          return !e.contains('#') && !e.contains(RegExp(r'c♭|f♭'));
        default:
          return true;
      }
    }).toList();
  }

  static List<String>? find(
    List<String> chordAry, [
    String mapType = "standard",
  ]) {
    final chord2num = getToneToNumberMap();
    const baseNum = 36;
    final numAry = <int>[];
    var beforeNum = baseNum;

    for (final e in chordAry) {
      var num = baseNum + chord2num[e]!;
      if (num < beforeNum) {
        num += 12;
      }
      numAry.add(num);
      beforeNum = num;
    }

    final relNumAry = numAry.map((e) => e - numAry.first).toList();
    final chordMap =
        mapType == "standard" ? _standardChordMap : generateChordMap(mapType);

    final chords = chordMap[relNumAry.join(",")];
    if (chords == null) return null;

    if (chords is List) {
      return chords.map((e) => "${chordAry.first.toUpperCase()}$e").toList();
    } else {
      return ["${chordAry.first.toUpperCase()}$chords"];
    }
  }

  static List<String>? findWithRotate(
      List<String> chordAry, String root, String mapType) {
    final tmpChordAry = List.of(chordAry);
    final resList = <String>[];
    for (var i = 0; i < tmpChordAry.length - 1; i++) {
      final rotatedArray = Utility.rotateArray(tmpChordAry, 1);
      final res = find(rotatedArray, mapType);
      if (res != null) {
        resList.addAll(res.map((e) => "$e/$root"));
      }
    }
    if (resList.isEmpty) return null;
    if (resList.length == 1) return [resList.first];
    return resList;
  }

  static Map<String, List<String>> generateChordMap(String mapType) {
    final map = <String, List<String>>{};
    final chordList = generateChordList();
    for (final e in chordList) {
      if (mapType == "generated1" && e[1].contains('omit')) continue;
      final key = e[0].map((i) => i.toString()).join(",");
      map[key] = (map[key] ?? [])..add(e[1]);
    }
    return map;
  }

  static List<List<dynamic>> generateChordList() {
    final rootAry = [
      [0, ""]
    ];
    final thirdAry = [
      [null, "(omit3)"],
      [2, "sus2"],
      [3, "m"],
      [4, ""],
      [5, "sus4"],
    ];
    final fifthAry = [
      [null, "(omit5)"],
      [6, "-5"],
      [7, ""],
      [8, "+5"],
    ];
    final seventhAry = [
      [null, ""],
      [9, "6"],
      [10, "7"],
      [11, "M7"],
    ];
    final tensionAry = [
      [1, "(-9)"],
      [
        2,
        "(9)",
        [
          [RegExp(r'7(?!\))'), "9"]
        ]
      ],
      [3, "(+9)"],
      [
        5,
        "(11)",
        [
          [RegExp(r'9(?!\))'), "11"]
        ]
      ],
      [6, "(+11)"],
      [8, "(-13)"],
      [
        9,
        "(13)",
        [
          [RegExp(r'11(?!\))'), "13"]
        ]
      ],
      [10, "(+13)"],
    ];

    List<List<dynamic>> productArray(
        List<List<dynamic>> ary1, List<List<dynamic>> ary2) {
      final res = <List<dynamic>>[];
      for (final e1 in ary1) {
        for (final e2 in ary2) {
          final ary = <int>[];
          var exist = false;
          for (final e in [e1[0], e2[0]]) {
            if (e == null) continue;
            if (e is List) {
              ary.addAll(e.map((i) => i as int));
            } else if (ary.contains(e)) {
              exist = true;
            } else {
              ary.add(e as int);
            }
          }
          if (exist) continue;
          final name = "${e1[1]}${e2[1]}";
          res.add([ary, name]);
          final others = e2.length > 2 ? e2[2] : [];
          for (final other in others) {
            final m1 = other[0] as RegExp;
            final n1 = other[1] as String;
            if (name.contains(m1)) {
              res.add([ary, name.replaceAll(m1, n1)]);
            }
          }
        }
      }
      return res;
    }

    List<List<dynamic>> moveToTail(List<List<dynamic>> chordAry, RegExp regex) {
      return chordAry.map((e) {
        final movingTargets =
            regex.allMatches(e[1]).map((m) => m.group(0)).toList();
        if (movingTargets.isNotEmpty) {
          return [e[0], e[1].replaceAll(regex, "") + movingTargets.join("")];
        }
        return e;
      }).toList();
    }

    var tmpAry = productArray(rootAry, thirdAry);
    tmpAry = productArray(tmpAry, seventhAry);
    tmpAry = moveToTail(tmpAry, RegExp(r'(sus\d)'));
    tmpAry = productArray(tmpAry, fifthAry);
    for (final e in tensionAry) {
      tmpAry = productArray(tmpAry, [
        [null, ""],
        e
      ]);
    }
    tmpAry = moveToTail(tmpAry, RegExp(r'(\(omit\d\))'));
    return tmpAry;
  }
}

void main() {
  final chords = [
    "ソシレ",
    "ソシ♭レ",
    "ソシ#レ",
    "ソシレ",
    "cgb",
    "cegb",
    "ACED",
    "ファ ドミソシ",
    "レ ドミソシ",
    "ドミ♭ファ#ラ",
    "レファ#ラ#",
  ];

  for (final chord in chords) {
    print(ChordFinder.find(Tones.parse(chord)?.toneAry ?? []));
  }
}
