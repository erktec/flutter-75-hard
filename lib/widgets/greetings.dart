import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seventy_five_hard/utils/utils.dart';

class Greetings extends StatelessWidget {
  final String day;
  final String imageUrl;
  final String username;

  const Greetings({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: imageUrl.isNotEmpty
              ? FutureBuilder<bool>(
                  future: _isValidImageUrl(imageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      );
                    }
                    if (snapshot.hasData && snapshot.data == true) {
                      return SvgPicture.network(
                        imageUrl,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        placeholderBuilder: (BuildContext context) =>
                            const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        ),
                      );
                    } else {
                      return const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      );
                    }
                  },
                )
              : const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello", style: TextStyle(fontSize: 18)),
            Text(
              username,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Day: $day/75',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future<bool> _isValidImageUrl(String url) async {
    try {
      final response = await Uri.tryParse(url)?.resolve('').toString();
      return response != null && response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
