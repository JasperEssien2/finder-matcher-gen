import 'package:example/models.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:flutter/material.dart';

class ItemTask extends StatelessWidget {
  const ItemTask({
    super.key,
    required this.taskModel,
  });

  @MatchDeclaration()
  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(15);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(radius),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 5,
              color: Colors.grey[200]!,
              offset: const Offset(-2, -2),
            ),
          ]),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: const BorderRadius.only(
                topLeft: radius,
                bottomLeft: radius,
              ),
            ),
            width: 30,
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              taskModel.task,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  @MatchDeclaration()
  Color get priorityColor {
    switch (taskModel.priority) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
    }
    throw Exception('Unsupported priority: ${taskModel.priority}');
  }
}

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    Key? key,
    required this.onPress,
  }) : super(key: key);

  final VoidCallback onPress;

  @MatchDeclaration(defaultValue: 'Add Task')
  String get fabText => 'Add Task';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return FloatingActionButton.extended(
      key: const ValueKey('add-task-fab'),
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          fabText,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      onPressed: onPress,
    );
  }
}

class AddTargetBottomSheet extends StatefulWidget {
  const AddTargetBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddTargetBottomSheet> createState() => _AddTargetBottomSheetState();
}

class _AddTargetBottomSheetState extends State<AddTargetBottomSheet> {
  final _taskTextController = TextEditingController();

  var selectedPriority = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0)
        ..copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Task',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          AppTextField(
            key: const ValueKey('task-field'),
            controller: _taskTextController,
            label: 'Task',
            prefix: const Icon(Icons.task),
            inputType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 24),
          Slider(
            min: 0,
            max: 7,
            activeColor: sliderColor,
            inactiveColor: Colors.grey[200],
            value: selectedPriority,
            onChanged: (val) {
              setState(() {
                selectedPriority = val;
              });
            },
          ),
          const SizedBox(height: 24),
          SaveButton(
            listenable: Listenable.merge(
              [_taskTextController],
            ),
            enable: _enableButton,
            onPress: () => Navigator.pop(
              context,
              TaskModel(
                _taskTextController.text,
                selectedPriority.toInt(),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  bool _enableButton() => _taskTextController.text.isNotEmpty;

  Color get sliderColor {
    switch (selectedPriority.toInt()) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
    }
    return Colors.red;
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key? key,
    required this.listenable,
    required this.enable,
    required this.onPress,
  }) : super(key: key);

  final Listenable listenable;
  final bool Function() enable;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AnimatedBuilder(
        animation: listenable,
        builder: (context, _) {
          return RawMaterialButton(
            onPressed: enable() ? onPress : null,
            fillColor: enable() ? theme.primaryColor : Colors.grey[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Save',
              style: theme.textTheme.button!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.inputType,
    this.readOnly,
    this.onTap,
    this.suffix,
    this.prefix,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? inputType;
  final bool? readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        readOnly: readOnly ?? false,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefix,
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Colors.white),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
