import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageViewerPage extends StatelessWidget {
  final String imageUrl;

  const ImageViewerPage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: imageUrl,
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.8,
                maxScale: 5.0,
                boundaryMargin: const EdgeInsets.all(80),
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade900,
                        highlightColor: Colors.grey.shade700,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_rounded,
                            color: Colors.white.withOpacity(0.8),
                            size: 70,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'تعذر تحميل الصورة',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}