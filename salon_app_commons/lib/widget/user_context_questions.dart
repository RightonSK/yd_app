import 'package:flutter/material.dart';
import '../domain/user_context.dart';

/// ユーザーコンテキスト収集用の質問コンポーネント
class UserContextQuestions extends StatefulWidget {
  final UserContext? initialContext;
  final Function(UserContext) onContextChanged;

  const UserContextQuestions({
    super.key,
    this.initialContext,
    required this.onContextChanged,
  });

  @override
  State<UserContextQuestions> createState() => _UserContextQuestionsState();
}

class _UserContextQuestionsState extends State<UserContextQuestions> {
  late UserContext _context;

  @override
  void initState() {
    super.initState();
    _context = widget.initialContext ?? UserContext();
  }

  void _updateContext(UserContext newContext) {
    setState(() {
      _context = newContext;
    });
    widget.onContextChanged(newContext);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                size: 20,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                'より良いサポートのため、以下の情報を教えてください',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // OS選択
          _buildDropdownQuestion(
            label: 'OS',
            description: 'お使いのOSを選択してください',
            value: _context.os,
            items: const [
              DropdownMenuItem(value: 'mac', child: Text('Mac')),
              DropdownMenuItem(value: 'windows', child: Text('Windows')),
            ],
            onChanged: (value) {
              _updateContext(_context.copyWith(
                os: value,
                // Macでない場合はchipをクリア
                chip: value != 'mac' ? null : _context.chip,
              ));
            },
          ),
          
          // Macの場合のみチップ選択を表示
          if (_context.os == 'mac') ...[
            const SizedBox(height: 12),
            _buildDropdownQuestion(
              label: 'Macのプロセッサー',
              description: 'お使いのMacのプロセッサーを選択してください',
              value: _context.chip,
              items: const [
                DropdownMenuItem(value: 'M1~M4', child: Text('M1~M4')),
                DropdownMenuItem(value: 'Intel', child: Text('Intel')),
              ],
              onChanged: (value) {
                _updateContext(_context.copyWith(chip: value));
              },
            ),
          ],
          
          const SizedBox(height: 12),
          
          // IDE選択
          _buildDropdownQuestion(
            label: 'IDE',
            description: 'お使いの開発環境を選択してください',
            value: _context.ide,
            items: const [
              DropdownMenuItem(value: 'Android Studio', child: Text('Android Studio')),
              DropdownMenuItem(value: 'VSCode', child: Text('VSCode')),
              DropdownMenuItem(value: 'その他', child: Text('その他')),
            ],
            onChanged: (value) {
              _updateContext(_context.copyWith(ide: value));
            },
          ),
          
          if (_context.isComplete) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '基本情報が完了しました',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdownQuestion({
    required String label,
    required String description,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.blue.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              isExpanded: true,
              items: items,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}