import 'package:FatCat/constants/colors.dart';
import 'package:FatCat/models/card_edit_model.dart';
import 'package:flutter/material.dart';

class CardEditWidget extends StatefulWidget {
  final CardEditModel card;
  final VoidCallback onRemove;
  final Function(CardEditModel) onCardChanged;

  const CardEditWidget({
    Key? key,
    required this.card,
    required this.onRemove,
    required this.onCardChanged,
  }) : super(key: key);

  @override
  State<CardEditWidget> createState() => _CardEditWidgetState();
}

class _CardEditWidgetState extends State<CardEditWidget> {
  late TextEditingController frontController;
  late TextEditingController backController;
  late FocusNode frontFocusNode;
  late FocusNode backFocusNode;

  @override
  void initState() {
    super.initState();
    frontController = TextEditingController(text: widget.card.question);
    backController = TextEditingController(text: widget.card.answer);
    frontFocusNode = FocusNode();
    backFocusNode = FocusNode();

    frontController.addListener(_onCardChanged);
    backController.addListener(_onCardChanged);
  }

  void _onCardChanged() {
    widget.onCardChanged(
      CardEditModel(
        id: widget.card.id,
        question: frontController.text,
        answer: backController.text,
      ),
    );
  }

  @override
  void dispose() {
    frontController.dispose();
    backController.dispose();
    frontFocusNode.dispose();
    backFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Card(
        color: Colors.white.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'THUẬT NGỮ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: widget.onRemove,
                  ),
                ],
              ),
              TextField(
                controller: frontController,
                focusNode: frontFocusNode,
                cursorColor: Colors.brown,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 3.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 4.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ĐỊNH NGHĨA',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: backController,
                focusNode: backFocusNode,
                cursorColor: Colors.brown,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 3.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 4.0),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
