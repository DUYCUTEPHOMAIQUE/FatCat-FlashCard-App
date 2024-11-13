const { sequelize } = require('../database/init.database');
const { Category, User, Deck, Card } = require('../models');
const bcrypt = require('bcrypt');

async function seedData() {
    try {
        await sequelize.transaction(async (t) => {
            // Tạo admin user
            const hashedPassword = await bcrypt.hash('admin', 10);
            const adminUser = await User.create({
                email: 'admin@gmail.com',
                password: hashedPassword,
                name: 'Admin 00001',
                role: 'admin'
            }, { transaction: t });

            // Tạo categories và decks tương ứng
            // 1. Ngôn ngữ
            const languageCategory = await Category.create({ name: 'Ngôn ngữ' }, { transaction: t });
            const englishDeck = await Deck.create({
                user_id: adminUser.id,
                name: 'English Vocabulary',
                description: 'Basic English vocabulary for beginners',
                category_id: languageCategory.id,
                is_published: true,
                deck_cards_count: 5
            }, { transaction: t });

            await Card.bulkCreate([
                { deck_id: englishDeck.id, question: 'Hello', answer: 'Xin chào' },
                { deck_id: englishDeck.id, question: 'Thank you', answer: 'Cảm ơn' },
                { deck_id: englishDeck.id, question: 'Goodbye', answer: 'Tạm biệt' },
                { deck_id: englishDeck.id, question: 'How are you?', answer: 'Bạn khỏe không?' },
                { deck_id: englishDeck.id, question: 'Good morning', answer: 'Chào buổi sáng' }
            ], { transaction: t });

            // 2. Toán học
            const mathCategory = await Category.create({ name: 'Toán học' }, { transaction: t });
            const mathDeck = await Deck.create({
                user_id: adminUser.id,
                name: 'Phép cộng cơ bản',
                description: 'Học phép cộng cho trẻ em',
                category_id: mathCategory.id,
                is_published: true,
                deck_cards_count: 5
            }, { transaction: t });

            await Card.bulkCreate([
                { deck_id: mathDeck.id, question: '1 + 1 = ?', answer: '2' },
                { deck_id: mathDeck.id, question: '2 + 2 = ?', answer: '4' },
                { deck_id: mathDeck.id, question: '3 + 3 = ?', answer: '6' },
                { deck_id: mathDeck.id, question: '4 + 4 = ?', answer: '8' },
                { deck_id: mathDeck.id, question: '5 + 5 = ?', answer: '10' }
            ], { transaction: t });

            // 3. Khoa học
            const scienceCategory = await Category.create({ name: 'Khoa học' }, { transaction: t });
            const scienceDeck = await Deck.create({
                user_id: adminUser.id,
                name: 'Các hành tinh',
                description: 'Tìm hiểu về các hành tinh trong hệ mặt trời',
                category_id: scienceCategory.id,
                is_published: true,
                deck_cards_count: 5
            }, { transaction: t });

            await Card.bulkCreate([
                { deck_id: scienceDeck.id, question: 'Hành tinh gần mặt trời nhất?', answer: 'Sao Thủy' },
                { deck_id: scienceDeck.id, question: 'Hành tinh nóng nhất trong hệ mặt trời?', answer: 'Sao Kim' },
                { deck_id: scienceDeck.id, question: 'Hành tinh đỏ?', answer: 'Sao Hỏa' },
                { deck_id: scienceDeck.id, question: 'Hành tinh lớn nhất hệ mặt trời?', answer: 'Sao Mộc' },
                { deck_id: scienceDeck.id, question: 'Hành tinh có vòng đai đẹp nhất?', answer: 'Sao Thổ' }
            ], { transaction: t });

            // 4. Nghệ thuật
            const artCategory = await Category.create({ name: 'Nghệ thuật' }, { transaction: t });
            const artDeck = await Deck.create({
                user_id: adminUser.id,
                name: 'Họa sĩ nổi tiếng',
                description: 'Tìm hiểu về các họa sĩ nổi tiếng thế giới',
                category_id: artCategory.id,
                is_published: true,
                deck_cards_count: 5
            }, { transaction: t });

            await Card.bulkCreate([
                { deck_id: artDeck.id, question: 'Ai vẽ Mona Lisa?', answer: 'Leonardo da Vinci' },
                { deck_id: artDeck.id, question: 'Ai vẽ The Starry Night?', answer: 'Vincent van Gogh' },
                { deck_id: artDeck.id, question: 'Ai vẽ Guernica?', answer: 'Pablo Picasso' },
                { deck_id: artDeck.id, question: 'Ai vẽ The Scream?', answer: 'Edvard Munch' },
                { deck_id: artDeck.id, question: 'Ai vẽ The Persistence of Memory?', answer: 'Salvador Dalí' }
            ], { transaction: t });

            // 5. Văn học
            const literatureCategory = await Category.create({ name: 'Văn học' }, { transaction: t });
            const literatureDeck = await Deck.create({
                user_id: adminUser.id,
                name: 'Tác phẩm văn học Việt Nam',
                description: 'Những tác phẩm văn học Việt Nam nổi tiếng',
                category_id: literatureCategory.id,
                is_published: true,
                deck_cards_count: 5
            }, { transaction: t });

            await Card.bulkCreate([
                { deck_id: literatureDeck.id, question: 'Ai là tác giả Truyện Kiều?', answer: 'Nguyễn Du' },
                { deck_id: literatureDeck.id, question: 'Ai là tác giả Số Đỏ?', answer: 'Vũ Trọng Phụng' },
                { deck_id: literatureDeck.id, question: 'Ai là tác giả Tắt Đèn?', answer: 'Ngô Tất Tố' },
                { deck_id: literatureDeck.id, question: 'Ai là tác giả Chí Phèo?', answer: 'Nam Cao' },
                { deck_id: literatureDeck.id, question: 'Ai là tác giả Vợ Nhặt?', answer: 'Kim Lân' }
            ], { transaction: t });

            // 6. Khác
            await Category.create({ name: 'Khác' }, { transaction: t });

            console.log('All data seeded successfully');
        });
    } catch (error) {
        console.error('Error seeding data:', error);
    }
}

module.exports = seedData;

