import 'package:braille_app/utils/database/database_helper.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListHistoryDocument extends StatefulWidget {
  const ListHistoryDocument({super.key});

  @override
  State<ListHistoryDocument> createState() => _ListHistoryDocumentState();
}

class _ListHistoryDocumentState extends State<ListHistoryDocument> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _historyItems = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final items = await _dbHelper.getAllTextBraille();
      final startIndex = _currentPage * _pageSize;
      final endIndex = startIndex + _pageSize;
      
      if (startIndex >= items.length) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      final newItems = items.sublist(
        startIndex,
        endIndex > items.length ? items.length : endIndex,
      );

      setState(() {
        _historyItems.addAll(newItems);
        _currentPage++;
        _isLoading = false;
        _hasMore = endIndex < items.length;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error appropriately
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreItems();
    }
  }

  Future<void> _deleteItem(int id) async {
    await _dbHelper.deleteTextBraille(id);
    setState(() {
      _historyItems.removeWhere((item) => item['id'] == id);
    });
  }

  void _onItemTap(Map<String, dynamic> item) {
    Navigator.pop(context, {
      'text': item['text'],
      'braille': item['text_braille'],
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_historyItems.isEmpty && !_isLoading) {
      return const Center(
        child: Text('No history items found'),
      );
    }

    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _historyItems.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _historyItems.length) {
            return _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink();
          }

          final item = _historyItems[index];
          return Dismissible(
            key: Key(item['id'].toString()),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteItem(item['id']);
            },
            child: InkWell(
              onTap: () => _onItemTap(item),
              child: Card(
                
                margin: EdgeInsets.symmetric(vertical: 8.h),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Original Text:',
                          style: AppTextStyle.mediumBlackBold,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item['text'],
                          style: AppTextStyle.mediumBlack,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Braille Text:',
                          style: AppTextStyle.mediumBlackBold,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item['text_braille'],
                          style: AppTextStyle.mediumBlack,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
