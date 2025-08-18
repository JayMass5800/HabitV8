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
  /// Creates a new RadioListTile that gets its groupValue and onChanged from
  /// the nearest RadioGroup ancestor.
  RadioListTile<T> withRadioGroup(BuildContext context) {
    final group = InheritedRadioGroup.of<T>(context);
    if (group == null) {
      return this;
    }

    return RadioListTile<T>(
      value: value,
      groupValue: group.value,
      onChanged: (_) => group.onChanged(value),
      title: title,
      subtitle: subtitle,
      secondary: secondary,
      isThreeLine: isThreeLine,
      dense: dense,
      contentPadding: contentPadding,
      selected: selected,
      controlAffinity: controlAffinity,
      autofocus: autofocus,
      activeColor: activeColor,
      toggleable: toggleable,
      enableFeedback: enableFeedback,
      shape: shape,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      visualDensity: visualDensity,
    );
  }
}
