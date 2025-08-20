import 'package:flutter/material.dart';

/// A widget that manages a group of radio buttons.
///
/// This widget replaces the deprecated groupValue and onChanged properties
/// in RadioListTile by providing a parent widget that manages the state.
class RadioGroup<T> extends StatelessWidget {
  /// The currently selected value for the radio group.
  final T value;

  /// Called when the user selects a different radio button.
  final ValueChanged<T> onChanged;

  /// The list of radio buttons to display.
  final List<Widget> children;

  /// Creates a radio group.
  const RadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return InheritedRadioGroup<T>(
      value: value,
      onChanged: onChanged,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// An inherited widget that provides the current value and onChange callback
/// to all RadioListTile descendants.
class InheritedRadioGroup<T> extends InheritedWidget {
  /// The currently selected value for the radio group.
  final T value;

  /// Called when the user selects a different radio button.
  final ValueChanged<T> onChanged;

  /// Creates an inherited radio group.
  const InheritedRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required super.child,
  });

  /// Gets the nearest [InheritedRadioGroup] ancestor from the given context.
  static InheritedRadioGroup<T>? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedRadioGroup<T>>();
  }

  @override
  bool updateShouldNotify(InheritedRadioGroup<T> oldWidget) {
    return value != oldWidget.value || onChanged != oldWidget.onChanged;
  }
}

/// Extension on RadioListTile to work with RadioGroup
extension RadioListTileExtension<T> on RadioListTile<T> {
  /// Creates a new ListTile with Radio that gets its groupValue and onChanged from
  /// the nearest RadioGroup ancestor.
  Widget withRadioGroup(BuildContext context) {
    final group = InheritedRadioGroup.of<T>(context);
    if (group == null) {
      return this;
    }

    return ListTile(
      leading: controlAffinity == ListTileControlAffinity.leading
          ? GestureDetector(
              onTap: () => group.onChanged(value),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: group.value == value
                        ? (activeColor ?? Colors.blue)
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: group.value == value
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeColor ?? Colors.blue,
                          ),
                        ),
                      )
                    : null,
              ),
            )
          : secondary,
      title: title,
      subtitle: subtitle,
      trailing: controlAffinity == ListTileControlAffinity.trailing
          ? GestureDetector(
              onTap: () => group.onChanged(value),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: group.value == value
                        ? (activeColor ?? Colors.blue)
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: group.value == value
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeColor ?? Colors.blue,
                          ),
                        ),
                      )
                    : null,
              ),
            )
          : null,
      isThreeLine: isThreeLine,
      dense: dense,
      contentPadding: contentPadding,
      selected: selected,
      onTap: () => group.onChanged(value),
      autofocus: autofocus,
      enableFeedback: enableFeedback,
      shape: shape,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      visualDensity: visualDensity,
    );
  }
}
