import 'package:flutter/material.dart';
import '../models/apod.dart';

class ApodCard extends StatefulWidget {
  final Apod apod;

  const ApodCard({super.key, required this.apod});

  @override
  State<ApodCard> createState() => _ApodCardState();
}

class _ApodCardState extends State<ApodCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.apod.mediaType == 'image' && widget.apod.url != null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (only if available)
            if (hasImage)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  widget.apod.url!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Show a loading placeholder while the image downloads
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
                  // Fallback if the image fails to load
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

            // Text content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.apod.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
                    overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}