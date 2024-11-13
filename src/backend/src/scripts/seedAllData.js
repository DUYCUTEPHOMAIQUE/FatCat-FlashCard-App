const { sequelize } = require('../database/init.database');
const { User, Category, Deck, Card, Class, ClassMember, ClassDeck, Token } = require('../models');

const seedAllData = async () => {
  try {
    await sequelize.transaction(async (t) => {
      // Seed Users
      const adminUser = await User.create({
        name: 'Admin',
        email: 'admin@gmail.com',
        password: 'admin',
        role_system: 'admin',
        isVerified: true,
      }, { transaction: t });
      // Token
      if(adminUser) {
        const newToken = await Token.create({
          userId: adminUser.id,
          accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImVtYWlsIjoiYWRtaW5AZ21haWwuY29tIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzMxMzc5MDA2LCJleHAiOjE3MzkxNTUwMDZ9.UCUJ512XTdkciDexOcNRzRQ6SStmlSju9IdtFbyYdEk",
        }, { transaction: t });
        console.log(`adminEmail:: ${adminUser.email}\npassword:: ${adminUser.password}\nadminRole:: ${adminUser.role_system}\nadminToken:: ${newToken.accessToken}`)
      }

      const regularUser = await User.create({
        name: 'User',
        email: 'user@gmail.com',
        password: 'user',
        role_system: 'user',
        isVerified: true,
      }, { transaction: t });
      if (regularUser) {
        const userToken = await Token.create({  
          userId: regularUser.id,
          accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImVtYWlsIjoidXNlckBnbWFpbC5jb20iLCJyb2xlIjoidXNlciIsImlhdCI6MTczMTQ3MDI5MiwiZXhwIjoxNzM5MjQ2MjkyfQ.5xB0SWzFFVVpz7yXYbiBdNycBLfxkKggdB_qncvKF3A",
        }, { transaction: t });
        console.log(`userEmail:: ${regularUser.email}\npassword:: ${regularUser.password}\nuserRole:: ${regularUser.role_system}\nuserToken:: ${userToken.accessToken}`)
      }

      // Seed Categories
      const unknownCategory = await Category.create({
        name: 'Không xác định',
      }, { transaction: t }); 
      const languageCategory = await Category.create({
        name: 'Ngôn ngữ',
      }, { transaction: t });

      const mathCategory = await Category.create({
        name: 'Toán học',
      }, { transaction: t });

      const scienceCategory = await Category.create({
        name: 'Khoa học',
      }, { transaction: t });

      const artCategory = await Category.create({
        name: 'Nghệ thuật',
      }, { transaction: t });

      const literatureCategory = await Category.create({
        name: 'Văn học',
      }, { transaction: t });

      // Seed Decks for Language
      const englishDeck = await Deck.create({
        user_id: adminUser.id,
        name: 'English Vocabulary',
        description: 'Basic English vocabulary for beginners',
        category_id: languageCategory.id,
        is_published: true,
        deck_cards_count: 7,
        question_language: 'English',
        answer_language: 'English',
      }, { transaction: t });

      const vietnameseDeck = await Deck.create({
        user_id: regularUser.id,
        name: 'Vietnamese Phrases',
        description: 'Common Vietnamese phrases for travelers',
        category_id: languageCategory.id,
        is_published: true,
        deck_cards_count: 6,
        question_language: 'Vietnamese',
        answer_language: 'Vietnamese',
      }, { transaction: t });

      // Thêm deck mới cho Language category
      const businessEnglishDeck = await Deck.create({
        user_id: adminUser.id,
        name: 'Business English',
        description: 'Essential vocabulary and phrases for business communication',
        category_id: languageCategory.id,
        is_published: true,
        deck_cards_count: 5,
        question_language: 'English',
        answer_language: 'English',
      }, { transaction: t });

      // Seed Decks for Mathematics
      const mathDeck = await Deck.create({
        user_id: adminUser.id,
        name: 'Basic Mathematics',
        description: 'Fundamentals of mathematics including addition, subtraction, multiplication, and division.',
        category_id: mathCategory.id,
        is_published: true,
        deck_cards_count: 7,
        question_language: 'Mathematics',
        answer_language: 'Mathematics',
      }, { transaction: t });

      // Seed Decks for Science
      const scienceDeck = await Deck.create({
        user_id: regularUser.id,
        name: 'Introduction to Science',
        description: 'Basic concepts in science including physics, chemistry, and biology.',
        category_id: scienceCategory.id,
        is_published: true,
        deck_cards_count: 6,
        question_language: 'Science',
        answer_language: 'Science',
      }, { transaction: t });

      // Seed Decks for Art
      const artDeck = await Deck.create({
        user_id: adminUser.id,
        name: 'Art Fundamentals',
        description: 'Basic principles of art including color theory and composition.',
        category_id: artCategory.id,
        is_published: true,
        deck_cards_count: 6,
        question_language: 'Art',
        answer_language: 'Art',
      }, { transaction: t });

      // Seed Decks for Literature
      const literatureDeck = await Deck.create({
        user_id: regularUser.id,
        name: 'Literature Classics',
        description: 'Famous works of literature and their authors.',
        category_id: literatureCategory.id,
        is_published: true,
        deck_cards_count: 7,
        question_language: 'Literature',
        answer_language: 'Literature',
      }, { transaction: t });

      // Seed Cards for English Deck
      const englishCards = [
        { deck_id: englishDeck.id, question: 'Hello', answer: 'A common greeting' },
        { deck_id: englishDeck.id, question: 'Goodbye', answer: 'A parting phrase' },
        { deck_id: englishDeck.id, question: 'Thank you', answer: 'An expression of gratitude' },
        { deck_id: englishDeck.id, question: 'How are you?', answer: 'A question to inquire about someone\'s well-being' },
        { deck_id: englishDeck.id, question: 'Nice to meet you', answer: 'A polite greeting when meeting someone for the first time' },
        { deck_id: englishDeck.id, question: 'See you later', answer: 'A casual way to say goodbye' },
        { deck_id: englishDeck.id, question: 'Have a good day', answer: 'A friendly farewell wish' },
      ];
      await Card.bulkCreate(englishCards, { transaction: t });

      // Seed Cards for Vietnamese Deck
      const vietnameseCards = [
        { deck_id: vietnameseDeck.id, question: 'Xin chào', answer: 'Hello' },
        { deck_id: vietnameseDeck.id, question: 'Tạm biệt', answer: 'Goodbye' },
        { deck_id: vietnameseDeck.id, question: 'Cảm ơn', answer: 'Thank you' },
        { deck_id: vietnameseDeck.id, question: 'Rất vui được gặp bạn', answer: 'Nice to meet you' },
        { deck_id: vietnameseDeck.id, question: 'Chúc ngon miệng', answer: 'Enjoy your meal' },
        { deck_id: vietnameseDeck.id, question: 'Xin chỉ đường', answer: 'Could you give me directions?' },
      ];
      await Card.bulkCreate(vietnameseCards, { transaction: t });

      // Seed Cards for Math Deck
      const mathCards = [
        { deck_id: mathDeck.id, question: '2 + 2', answer: '4' },
        { deck_id: mathDeck.id, question: '5 - 3', answer: '2' },
        { deck_id: mathDeck.id, question: '3 x 3', answer: '9' },
        { deck_id: mathDeck.id, question: 'What is the square root of 16?', answer: '4' },
        { deck_id: mathDeck.id, question: 'What is 15% of 200?', answer: '30' },
        { deck_id: mathDeck.id, question: 'What is the formula for the area of a circle?', answer: 'πr²' },
        { deck_id: mathDeck.id, question: 'What is 7 x 8?', answer: '56' },
      ];
      await Card.bulkCreate(mathCards, { transaction: t });

      // Seed Cards for Science Deck
      const scienceCards = [
        { deck_id: scienceDeck.id, question: 'What is H2O?', answer: 'Water' },
        { deck_id: scienceDeck.id, question: 'What is the chemical symbol for gold?', answer: 'Au' },
        { deck_id: scienceDeck.id, question: 'What is the speed of light?', answer: '299,792 km/s' },
        { deck_id: scienceDeck.id, question: 'What is photosynthesis?', answer: 'The process by which plants convert light energy into chemical energy' },
        { deck_id: scienceDeck.id, question: 'What is Newton\'s First Law?', answer: 'An object will remain at rest or in motion unless acted upon by an external force' },
        { deck_id: scienceDeck.id, question: 'What is the largest planet in our solar system?', answer: 'Jupiter' },
      ];
      await Card.bulkCreate(scienceCards, { transaction: t });

      // Seed Cards for Art Deck
      const artCards = [
        { deck_id: artDeck.id, question: 'What are primary colors?', answer: 'Red, Blue, Yellow' },
        { deck_id: artDeck.id, question: 'What is a canvas?', answer: 'A surface for painting' },
        { deck_id: artDeck.id, question: 'What is perspective in art?', answer: 'A technique to represent three-dimensional objects on a two-dimensional surface' },
        { deck_id: artDeck.id, question: 'Who painted the Mona Lisa?', answer: 'Leonardo da Vinci' },
        { deck_id: artDeck.id, question: 'What is chiaroscuro?', answer: 'The use of strong contrasts between light and dark in artwork' },
        { deck_id: artDeck.id, question: 'What art movement did Vincent van Gogh belong to?', answer: 'Post-Impressionism' },
      ];
      await Card.bulkCreate(artCards, { transaction: t });

      // Seed Cards for Literature Deck
      const literatureCards = [
        { deck_id: literatureDeck.id, question: 'Who wrote "Romeo and Juliet"?', answer: 'William Shakespeare' },
        { deck_id: literatureDeck.id, question: 'What is a haiku?', answer: 'A form of Japanese poetry' },
        { deck_id: literatureDeck.id, question: 'Who is the author of "1984"?', answer: 'George Orwell' },
        { deck_id: literatureDeck.id, question: 'What is the theme of "Animal Farm"?', answer: 'A satire of totalitarianism and social revolution' },
        { deck_id: literatureDeck.id, question: 'Who wrote "The Great Gatsby"?', answer: 'F. Scott Fitzgerald' },
        { deck_id: literatureDeck.id, question: 'What is a sonnet?', answer: 'A 14-line poem with a specific rhyme scheme' },
        { deck_id: literatureDeck.id, question: 'Who is the author of "To Kill a Mockingbird"?', answer: 'Harper Lee' },
      ];
      await Card.bulkCreate(literatureCards, { transaction: t });

      // Thêm cards cho Business English
      const businessEnglishCards = [
        { deck_id: businessEnglishDeck.id, question: 'Could you please clarify?', answer: 'A polite way to ask for more explanation' },
        { deck_id: businessEnglishDeck.id, question: 'I look forward to hearing from you', answer: 'A formal way to end a business email' },
        { deck_id: businessEnglishDeck.id, question: 'Let\'s schedule a meeting', answer: 'A common phrase to arrange a business appointment' },
        { deck_id: businessEnglishDeck.id, question: 'Please find attached', answer: 'Used when sending documents in an email' },
        { deck_id: businessEnglishDeck.id, question: 'Best regards', answer: 'A professional email closing' },
      ];
      await Card.bulkCreate(businessEnglishCards, { transaction: t });

      console.log('All seed data inserted successfully');
    });
  } catch (error) {
    console.error('Error seeding data:', error);
  }
};

module.exports = seedAllData;