import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yd_app/data/repositories/message_repository.dart';
import 'package:yd_app/data/repositories/sales_repository.dart';
import 'package:yd_app/domain/entities/message.dart';
import 'package:yd_app/domain/entities/sales_record.dart';

class SalesAddState {
  final String title;
  final String content;
  final bool isLoading;
  final String? errorMessage;

  const SalesAddState({
    this.title = '',
    this.content = '',
    this.isLoading = false,
    this.errorMessage,
  });

  SalesAddState copyWith({
    String? title,
    String? content,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SalesAddState(
      title: title ?? this.title,
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class SalesAddViewModel extends Notifier<SalesAddState> {
  @override
  SalesAddState build() => const SalesAddState();

  void setTitle(String value) {
    state = state.copyWith(title: value);
  }

  void setContent(String value) {
    state = state.copyWith(content: value);
  }

  Future<bool> add() async {
    final repo = ref.read(salesRepositoryProvider);
    final sales = SalesRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: '9999',
      quantity: 9999,
      sellerId: 'current_user',
      soldAt: DateTime.now(),
    );
    return  true;
  }

  Future<bool> submitMessage() async {
    if (state.title.isEmpty || state.content.isEmpty) {
      state = state.copyWith(errorMessage: 'タイトルと本文を入力してください');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final repo = ref.read(messageRepositoryProvider);
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: state.title,
      content: state.content,
      authorId: 'current_user',
      createdAt: DateTime.now(),
    );

    await repo.addMessage(message);
    state = state.copyWith(isLoading: false);
    return true;
  }
}

final salesAddViewModelProvider =
    NotifierProvider<SalesAddViewModel, SalesAddState>(SalesAddViewModel.new);
