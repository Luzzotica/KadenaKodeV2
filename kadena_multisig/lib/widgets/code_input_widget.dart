import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_highlight/themes/vs2015.dart';

class CodeInputWidget extends StatefulWidget {
  final CodeController codeController;

  const CodeInputWidget({
    super.key,
    required this.codeController,
  });

  @override
  State<CodeInputWidget> createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Colors.white,
          //   width: 1,
          // ),
          borderRadius: BorderRadius.circular(8),
        ),
        // constraints: const BoxConstraints(
        //   minHeight: 100,
        // ),
        child: Theme(
          data: ThemeData.light(),
          child: CodeTheme(
            data: const CodeThemeData(styles: vs2015Theme),
            child: CodeField(
              controller: widget.codeController,
              textStyle: const TextStyle(fontFamily: 'SourceCode'),
            ),
          ),
        ),
      ),
    );
  }
}
