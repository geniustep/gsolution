import 'dart:typed_data';
import 'package:gsolution/common/config/import.dart';

Widget buildImage({dynamic image, double? width = 100, double? height = 200}) {
  if (image != null && image is String) {
    if (_isValidBase64(image)) {
      try {
        Uint8List imageBytes = base64.decode(image);
        return _buildImageWidget(
          widget: Image.memory(
            imageBytes,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) {
              return _errorWidget(height: height, width: width);
            },
          ),
          width: width,
          height: height,
        );
      } catch (e) {
        return _errorWidget(height: height, width: width);
      }
    } else if (_isAssetPath(image)) {
      return _buildImageWidget(
        widget: Image.asset(
          image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _errorWidget(height: height, width: width);
          },
        ),
        width: width,
        height: height,
      );
    }
  }
  return _errorWidget(height: height, width: width);
}

Widget _buildImageWidget({
  required Widget widget,
  double? width,
  double? height,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: height,
      width: width,
      child: widget,
    ),
  );
}

Widget _errorWidget({double? height, double? width}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: height,
      width: width,
      child: Image.asset("assets/images/other/empty_product.png"),
    ),
  );
}

bool _isValidBase64(String imageBase64) {
  try {
    base64.decode(imageBase64);
    return imageBase64.length % 4 == 0;
  } catch (e) {
    return false;
  }
}

bool _isAssetPath(String path) {
  // التحقق إذا كان المسار يبدأ بـ 'assets/'
  return path.startsWith('assets/');
}

class ImageTap extends StatelessWidget {
  final String mydata;
  const ImageTap(this.mydata, {super.key});

  @override
  Widget build(BuildContext context) {
    // التحقق من نوع الصورة
    final bool isBase64 = _isValidBase64(mydata);
    final bool isAsset = _isAssetPath(mydata);

    return Dialog(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullScreenImage(mydata),
            ),
          );
        },
        child: InteractiveViewer(
          child: isBase64
              ? Image.memory(
                  base64.decode(mydata),
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _errorWidget(); // في حالة الخطأ
                  },
                )
              : isAsset
                  ? Image.asset(
                      mydata,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _errorWidget(); // في حالة الخطأ
                      },
                    )
                  : _errorWidget(), // إذا كان النوع غير مدعوم
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String mydata;
  const FullScreenImage(this.mydata, {super.key});

  @override
  Widget build(BuildContext context) {
    // التحقق من نوع الصورة
    final bool isBase64 = _isValidBase64(mydata);
    final bool isAsset = _isAssetPath(mydata);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: isBase64
            ? InteractiveViewer(
                child: Image.memory(
                  base64.decode(mydata),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return _errorWidget(); // في حالة الخطأ
                  },
                ),
              )
            : isAsset
                ? InteractiveViewer(
                    child: Image.asset(
                      mydata,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _errorWidget(); // في حالة الخطأ
                      },
                    ),
                  )
                : _errorWidget(), // إذا كان النوع غير مدعوم
      ),
    );
  }
}
