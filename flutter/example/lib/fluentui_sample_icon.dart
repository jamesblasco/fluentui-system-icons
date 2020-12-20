import 'package:flutter/widgets.dart';

class FluentUISampleIcon implements Comparable {
  final IconData iconData;
  final String iconName;
  final double defaultSize;

  FluentUISampleIcon(this.iconData, this.iconName, this.defaultSize);

  @override
  String toString() =>
      'IconDefinition{iconData: $iconData, title: $iconName, size: $defaultSize}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FluentUISampleIcon &&
          runtimeType == other.runtimeType &&
          iconData == other.iconData &&
          iconName == other.iconName &&
          defaultSize == other.defaultSize;

  @override
  int get hashCode =>
      iconData.hashCode ^ iconName.hashCode ^ defaultSize.hashCode;

  @override
  int compareTo(other) => iconName.compareTo(other.name);
}

class IconGroup implements Comparable {
  final Map<String, List<FluentUISampleIcon>> iconsByStyle;
  final String name;
  final String id;

  IconGroup(this.iconsByStyle, this.name, this.id);

  @override
  String toString() => 'IconGroup{icon: $id}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IconGroup && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) => name.compareTo(other.name);

  static List<IconGroup> listFrom(List<FluentUISampleIcon> icons) {
    Map<String, IconGroup> groups = {};

    for (final icon in icons) {
      final nameList = icon.iconName.split('_');
      final id = nameList.sublist(0, nameList.length - 2).join('_');
      final name = nameList
          .sublist(0, nameList.length - 2)
          .map((e) => e.capitalize())
          .join(' ');
      final style = nameList.last;
      groups[id] ??= IconGroup({}, name, id);
      groups[id].iconsByStyle[style] ??= [];
      groups[id].iconsByStyle[style].add(icon);
    }

    return groups.values.toList();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
