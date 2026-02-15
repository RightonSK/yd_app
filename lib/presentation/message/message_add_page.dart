import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yd_app/presentation/home/home_viewmodel.dart';
import 'package:yd_app/presentation/message/message_add_viewmodel.dart';

class MessageAddPage extends ConsumerWidget {
  const MessageAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addState = ref.watch(messageAddViewModelProvider);
    final viewModel = ref.read(messageAddViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('メッセージ登録'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: viewModel.setTitle,
              decoration: const InputDecoration(
                labelText: 'タイトル',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: viewModel.setContent,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: '本文',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            if (addState.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                addState.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: addState.isLoading
                    ? null
                    : () async {
                        final success = await viewModel.submitMessage();
                        if (success && context.mounted) {
                          ref.invalidate(messagesProvider);
                          Navigator.of(context).pop();
                        }
                      },
                child: addState.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('登録', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
