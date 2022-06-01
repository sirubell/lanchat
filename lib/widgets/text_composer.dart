import 'package:flutter/material.dart';
import 'package:lanchat/models/app_model.dart';
import 'package:lanchat/models/text_message_model.dart';
import 'package:lanchat/models/file_message_model.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class TextComposer extends StatefulWidget {
  final String ip;
  const TextComposer({Key? key, required this.ip}) : super(key: key);

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final _textEditingComposer = TextEditingController();
  final _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _handleFileSubmitted(widget.ip, FileType.any),
            icon: const Icon(Icons.file_upload),
          ),
          IconButton(
            onPressed: () => _handleFileSubmitted(widget.ip, FileType.image),
            icon: const Icon(Icons.image),
          ),
          Flexible(
            child: TextField(
              controller: _textEditingComposer,
              focusNode: _focusNode,
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                _handleTextSubmitted(widget.ip, text);
              },
            ),
          ),
          IconButton(
            onPressed: _isComposing
                ? () =>
                    _handleTextSubmitted(widget.ip, _textEditingComposer.text)
                : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _handleFileSubmitted(String ip, FileType type) {
    FilePicker.platform.pickFiles(withData: true, type: type).then((result) {
      if (result != null) {
        context.read<AppModel>().sendMessage(
            ip,
            FileMessageModel(
                isMe: true, time: DateTime.now(), file: result.files[0]));
      }
    });
  }

  void _handleTextSubmitted(String ip, String text) {
    if (text.isEmpty) return;

    _textEditingComposer.clear();
    _focusNode.requestFocus();
    _isComposing = false;
    context.read<AppModel>().sendMessage(
        ip, TextMessageModel(isMe: true, time: DateTime.now(), text: text));
  }
}
