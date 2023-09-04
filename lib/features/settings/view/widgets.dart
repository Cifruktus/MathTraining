import 'package:flutter/material.dart';
import 'package:math_training/widgets/theme.dart';

class NameValueCard extends StatelessWidget {
  final Widget name;
  final Widget value;
  final void Function() onTap;

  const NameValueCard({
    Key? key,
    required this.name,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).extension<AppTheme>()!.data;

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: new Row(children: <Widget>[
          Expanded(
            child: DefaultTextStyle.merge(
              style: theme.cardText,
              child: name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DefaultTextStyle.merge(
              style: theme.cardTextHighlighted,
              child: value,
            ),
          )
        ]),
      ),
    ));
  }
}

class ListDialog<T> extends StatelessWidget {
  final List<ListDialogElement<T>> elements;
  final String title;
  final T? selected;
  final Function(T)? onChoiceMade;

  const ListDialog({
    this.onChoiceMade,
    Key? key,
    required this.title,
    required this.elements,
    this.selected,
  });

  static ListDialog<String> fromStringList(
    String title,
    List<String> list, {
    String? selected,
    Function(String)? onChoiceMade,
  }) {
    return ListDialog(
        onChoiceMade: onChoiceMade,
        title: title,
        selected: selected,
        elements: list
            .map((option) => ListDialogElement(
                  value: option,
                  child: Text(option),
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: elements.map((element) => _buildOption(element, context)).toList(),
    );
  }

  Widget _buildOption(ListDialogElement<T> element, BuildContext context) {
    return Container(
      color: element.value == selected ? Theme.of(context).colorScheme.primary.withAlpha(30) : Colors.transparent,
      child: SimpleDialogOption(
        onPressed: () => Navigator.pop(context, element.value),
        child: element.child,
      ),
    );
  }
}

class ListDialogElement<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const ListDialogElement({
    Key? key,
    required this.value,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
