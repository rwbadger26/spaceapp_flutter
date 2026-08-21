import 'package:flutter/material.dart';
import '../models/apod.dart';
import '../services/bookmark_service.dart';

class ApodCard extends StatefulWidget {
  final Apod apod;

  const ApodCard({super.key, required this.apod});

  @override
  State<ApodCard> createState() => _ApodCardState();
}

class _ApodCardState extends State<ApodCard> {
  bool _isExpanded = false;

  void _openFullScreen() {
    final imageUrl = widget.apod.hdurl ?? widget.apod.url;
    if (imageUrl == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            _ApodFullScreen(title: widget.apod.title, imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        widget.apod.mediaType == 'image' && widget.apod.url != null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [if (hasImage) _buildImage(), _buildText()],
      ),
    );
  }

  final BookmarkService _bookmarks = BookmarkService();
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBookmark();
  }

  Future<void> _loadBookmark() async {
    final saved = await _bookmarks.isBookmarked(widget.apod.date);
    if (!mounted) return;
    setState(() {
      _isBookmarked = saved;
    });
  }

  Future<void> _toggleBookmark() async {
    await _bookmarks.toggle(widget.apod);
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  Widget _buildImage() {
    return GestureDetector(
      onTap: _openFullScreen,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.network(
          widget.apod.url!,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 180,
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 180,
              color: Colors.black26,
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.white38),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.apod.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _toggleBookmark,
                  icon: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: _isBookmarked
                        ? const Color(0xFF64B5F6)
                        : Colors.white54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              widget.apod.date,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Source: NASA APOD',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.apod.explanation,
              maxLines: _isExpanded ? null : 3,
              overflow: _isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isExpanded ? 'Tap to collapse' : 'Tap to expand',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApodFullScreen extends StatelessWidget {
  final String title;
  final String imageUrl;

  const _ApodFullScreen({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: Text(title)),
      body: Center(child: InteractiveViewer(child: Image.network(imageUrl))),
    );
  }
}
