import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sample_showcase/fluentui_sample_icon.dart';

import 'sample_icons.dart';

void main() {
  runApp(FluentUIIconKit());
}

class FluentUIIconKit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fluent icons',
      home: FluentUIShowcaseWidget(),
    );
  }
}

class LimitedSize extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const LimitedSize({Key key, this.maxWidth = 700, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerWidth = constraints.biggest.width;
        final double padding =
            maxWidth < containerWidth ? (containerWidth - maxWidth) / 2 : 0;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: child,
        );
      },
    );
  }
}

class FluentUIShowcaseWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FluentUIShowcaseWidgetState();
}

class FluentUIShowcaseWidgetState extends State<FluentUIShowcaseWidget> {
  var _searchTerm = "";

  TextEditingController dismissText = TextEditingController();

  List<IconGroup> groups;
  @override
  void initState() {
    groups = IconGroup.listFrom(icons);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*24 is for notification bar on Android*/
    final filteredIcons = groups
        .where((group) =>
            _searchTerm.isEmpty ||
            group.name.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: LimitedSize(
          child: Column(
            children: <Widget>[
              _searchBar(context),
              Expanded(
                child: GridView.builder(
                  itemCount: filteredIcons.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 64,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final icon = filteredIcons[index];
                    return IconPreview(group: icon);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            FluentIcons.search_24_regular,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(
              () {
                _searchTerm = "";
              },
            );
          },
        ),
        Expanded(
          child: TextField(
            controller: dismissText,
            onChanged: (text) => setState(() => _searchTerm = text),
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Search icons'),
          ),
        ),
        if (_searchTerm.isNotEmpty)
          IconButton(
            icon: Icon(
              FluentIcons.dismiss_24_filled,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(
                () {
                  _searchTerm = "";
                  dismissText.text = "";
                },
              );
            },
          ),
      ],
    );
  }
}

class IconPreview extends StatelessWidget {
  final IconGroup group;

  const IconPreview({Key key, this.group}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final icon = group.iconsByStyle.values.first.last;
    return Material(
      child: Tooltip(
        message: group.name,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return LimitedSize(
                  maxWidth: 800,
                  child: Dialog(
                    child: DetailIconPage(
                      group: group,
                    ),
                  ),
                );
              },
            );
          },
          onHover: (_) {},
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              child: Icon(
                icon.iconData,
                size: 24,
              ),
              width: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class DetailIconPage extends StatelessWidget {
  final IconGroup group;

  const DetailIconPage({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 32),
          Text(
            group.name,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 10),
          for (final style in group.iconsByStyle.entries) ...[
            Text(
              style.key.capitalize(),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final icon in style.value
                    ..sort(
                        (a, b) => b.defaultSize.compareTo(a.defaultSize))) ...[
                    Tooltip(
                      message: 'Tap to copy',
                      child: Material(
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            ClipboardData data = ClipboardData(
                                text: 'FluentIcons.${icon.iconName}');
                            Clipboard.setData(data);

                            final snackBar = SnackBar(
                              content:
                                  Text('Copied: FluentIcons.${icon.iconName}'),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            Navigator.of(context).pop();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 72,
                                width: 72,
                                child:
                                    Icon(icon.iconData, size: icon.defaultSize),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${icon.defaultSize.toInt()}',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                  ],
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
          ],
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
