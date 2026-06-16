import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/note_provider.dart';
import '../models/note_model.dart';

class TrashScreen extends StatelessWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ট্র্যাশ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Consumer<NoteProvider>(
            builder: (context, provider, child) {
              if (provider.trashedNotes.isEmpty) return const SizedBox();
              return TextButton(
                onPressed: () => _confirmEmptyTrash(context, provider),
                child: const Text(
                  'সব মুছো',
                  style: TextStyle(color: Colors.redAccent),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          if (provider.trashedNotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.delete_outline, size: 80, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text(
                    'ট্র্যাশ খালি',
                    style: TextStyle(color: Colors.white38, fontSize: 18),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.trashedNotes.length,
            itemBuilder: (context, index) {
              final note = provider.trashedNotes[index];
              return _buildTrashCard(context, note, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildTrashCard(
      BuildContext context, Note note, NoteProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        title: Text(
          note.title.isEmpty ? 'শিরোনাম নেই' : note.title,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              note.content.isEmpty ? 'খালি নোট' : note.content,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat('dd MMM yyyy').format(note.updatedAt),
              style: const TextStyle(color: Colors.white24, fontSize: 11),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.restore, color: Colors.greenAccent),
              onPressed: () => provider.restoreNote(note),
              tooltip: 'ফিরিয়ে আনো',
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () =>
                  _confirmDelete(context, note, provider),
              tooltip: 'চিরতরে মুছো',
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, Note note, NoteProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text(
          'চিরতরে মুছবে?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'এই নোট আর ফিরে পাবে না!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteNotePermanently(note);
            },
            child: const Text('মুছো', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _confirmEmptyTrash(BuildContext context, NoteProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text(
          'ট্র্যাশ খালি করবে?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'সব নোট চিরতরে মুছে যাবে!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.emptyTrash();
            },
            child: const Text('সব মুছো',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}