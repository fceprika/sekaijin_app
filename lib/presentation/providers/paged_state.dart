import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failures.dart';
import '../../data/models/api_response.dart';

typedef PageFetcher<T> = Future<(Failure?, ApiResponse<List<T>>?)> Function(int page);

class PagedState<T> {
  final List<T> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final int total;
  final String? error;

  const PagedState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.total = 0,
    this.error,
  });
}

class PagedNotifier<T> extends StateNotifier<PagedState<T>> {
  final PageFetcher<T> _fetchPage;

  PagedNotifier(this._fetchPage) : super(const PagedState());

  Future<void> loadInitial() async {
    if (state.isLoading) return;

    state = PagedState(
      items: state.items,
      isLoading: true,
      isLoadingMore: false,
      hasMore: state.hasMore,
      currentPage: state.currentPage,
      total: state.total,
    );

    final (failure, response) = await _fetchPage(1);

    if (failure != null) {
      state = PagedState(
        items: state.items,
        isLoading: false,
        isLoadingMore: false,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
        total: state.total,
        error: failure.userMessage,
      );
      return;
    }

    final items = response?.data ?? <T>[];
    state = PagedState(
      items: items,
      isLoading: false,
      isLoadingMore: false,
      hasMore: response?.pagination?.hasMorePages ?? false,
      currentPage: response?.pagination?.currentPage ?? 1,
      total: response?.pagination?.total ?? 0,
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = PagedState(
      items: state.items,
      isLoading: false,
      isLoadingMore: true,
      hasMore: state.hasMore,
      currentPage: state.currentPage,
      total: state.total,
    );

    final nextPage = state.currentPage + 1;
    final (failure, response) = await _fetchPage(nextPage);

    if (failure != null) {
      state = PagedState(
        items: state.items,
        isLoading: false,
        isLoadingMore: false,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
        total: state.total,
        error: failure.userMessage,
      );
      return;
    }

    final newItems = <T>[...state.items, ...(response?.data ?? <T>[])];
    state = PagedState(
      items: newItems,
      isLoading: false,
      isLoadingMore: false,
      hasMore: response?.pagination?.hasMorePages ?? false,
      currentPage: response?.pagination?.currentPage ?? nextPage,
      total: response?.pagination?.total ?? state.total,
    );
  }

  Future<void> refresh() async {
    state = const PagedState();
    await loadInitial();
  }
}
