import 'package:FatCat/constants/card_data_test.dart';
import 'package:FatCat/constants/deck_data_test.dart';
import 'package:FatCat/models/card_model.dart';
import 'package:FatCat/models/card_provider.dart';
import 'package:FatCat/models/deck_model.dart';
import 'package:FatCat/views/screens/cards_screen.dart';
import 'package:FatCat/views/widgets/card_item_widget.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DeckCartWidget extends StatelessWidget {
  final DeckModel deck;
  const DeckCartWidget({
    super.key,
    required this.deck,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.cards, extra: {
          'deck': deck,
        });
      },
      child: Card(
        elevation: 6,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(8),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(10),
          //   border: Border.all(
          //     width: 2,
          //     color: Color.fromRGBO(49, 58, 89, 1),
          //   ),
          // ),
          child: Column(
            children: [
              Text(
                deck.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                deck.description,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                deck.deck_cards_count,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                deck.createdAt.toString(),
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
