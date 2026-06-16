import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note note;
  const NoteEditorScreen({super.key, required this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isSaving = false;
  DateTime? _lastSaved;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() => _isSaving = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        widget.note.title = _titleController.text;
        widget.note.content = _contentController.text;
        context.read<NoteProvider>().updateNote(widget.note);
        setState(() {
          _isSaving = false;
          _lastSaved = DateTime.now();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            widget.note.title = _titleController.text;
            widget.note.content = _contentController.text;
            context.read<NoteProvider>().updateNote(widget.note);
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _isSaving
                ? const Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white54,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'সেভ হচ্ছে...',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  )
                : Text(
                    _lastSaved != null
                        ? 'সেভ হয়েছে ${DateFormat('hh:mm a').format(_lastSaved!)}'
                        : '',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              onChanged: (_) => _onTextChanged(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'শিরোনাম',
                hintStyle: TextStyle(color: Colors.white24, fontSize: 22),
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
            const Divider(color: Colors.white10),
            const SizedBox(height: 8),
            Text(
              'সর্বশেষ পরিবর্তন: ${DateFormat('dd MMM yyyy, hh:mm a').format(widget.note.updatedAt)}',
              style: const TextStyle(color: Colors.white24, fontSize: 11),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController,
                onChanged: (_) => _onTextChanged(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
                ),
                decoration: const InputDecoration(
                  hintText: 'এখানে লিখুন...',
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 16),
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
}