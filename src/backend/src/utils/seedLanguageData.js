const { sequelize } = require('../database/init.database');
const { Category, Deck, Card } = require('../models');

async function seedLanguageData() {
  try {
    await sequelize.transaction(async (t) => {
      // Tạo category
      const languageCategory = await Category.create({
        name: 'Ngôn ngữ'
      }, { transaction: t });

      // Tạo English Vocabulary deck
      const englishDeck = await Deck.create({
        user_id: 1,
        name: 'English Vocabulary',
        description: 'Basic English vocabulary for beginners',
        category_id: languageCategory.id,
        is_published: true,
        deck_cards_count: 5
      }, { transaction: t });

      // Tạo Vietnamese Phrases deck
      const vietnameseDeck = await Deck.create({
        user_id: 1,
        name: 'Vietnamese Phrases',
        description: 'Common Vietnamese phrases for travelers',
        category_id: languageCategory.id,
        is_published: true,
        deck_cards_count: 5,
      }, { transaction: t });

      // Tạo cards cho English Vocabulary deck
      const englishCards = [
        { deck_id: englishDeck.id, question: 'Hello', answer: 'A common greeting' },
        { deck_id: englishDeck.id, question: 'Goodbye', answer: 'A parting phrase' },
        { deck_id: englishDeck.id, question: 'Thank you', answer: 'An expression of gratitude' },
        { deck_id: englishDeck.id, question: 'Please', answer: 'Used when making a polite request' },
        { deck_id: englishDeck.id, question: 'Sorry', answer: 'Used to express apology or regret' }
      ];

      await Card.bulkCreate(englishCards, { transaction: t });

      // Tạo cards cho Vietnamese Phrases deck
      const vietnameseCards = [
        { deck_id: vietnameseDeck.id, question: 'Xin chào', answer: 'Hello' },
        { deck_id: vietnameseDeck.id, question: 'Tạm biệt', answer: 'Goodbye' },
        { deck_id: vietnameseDeck.id, question: 'Cảm ơn', answer: 'Thank you' },
        { deck_id: vietnameseDeck.id, question: 'Làm ơn', answer: 'Please' },
        { deck_id: vietnameseDeck.id, question: 'Xin lỗi', answer: 'Sorry' }
      ];

      await Card.bulkCreate(vietnameseCards, { transaction: t });

      console.log('Seed data inserted successfully');
    });
  } catch (error) {
    console.error('Error seeding data:', error);
  }
}

module.exports = seedLanguageData;
