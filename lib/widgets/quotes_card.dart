import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:seventy_five_hard/services/api_services.dart';
import 'package:seventy_five_hard/utils/utils.dart';

class QuotesCard extends StatefulWidget {
  const QuotesCard({super.key});

  @override
  State<QuotesCard> createState() => _QuotesCardState();
}

class _QuotesCardState extends State<QuotesCard> {
  bool quotesLoading = true;
  List<String> quotes = [];

  @override
  void initState() {
    super.initState();
    _getQuotes();
  }

  Future<void> _getQuotes() async {
    try {
      APIServices apiServices = APIServices.instance;
      final fetchedQuotes = await apiServices.fetchQuotes();

      // Use fallback quotes if API response is empty or null
      setState(() {
        quotes = fetchedQuotes.isNotEmpty
            ? fetchedQuotes
            : [
                'Stay focused!',
                'Keep pushing!',
                'You can do it!',
                'Believe in yourself!',
                'Success is near!'
              ];
        quotesLoading = false;
      });
    } catch (e) {
      // Handle errors and provide fallback quotes
      setState(() {
        quotes = [
          'An error occurred.',
          'Stay strong!',
          'Keep going!',
          'Never give up!',
          'Focus on the goal!'
        ];
        quotesLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xB6626262),
        image: const DecorationImage(
          opacity: 0.4,
          fit: BoxFit.cover,
          image: AssetImage('assets/images/sunrise.jpg'),
        ),
      ),
      child: Center(
        child: quotesLoading
            ? const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              )
            : AnimatedTextKit(
                repeatForever: true,
                animatedTexts: quotes
                    .map((quote) => getQuoteText(quote))
                    .toList()
                    .take(5) // Limit to the first 5 quotes for safety
                    .toList(),
              ),
      ),
    );
  }

  FadeAnimatedText getQuoteText(String quote) {
    return FadeAnimatedText(
      quote,
      textAlign: TextAlign.center,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
