const { sequelize } = require('../database/init.database');
const { ClassModel, User, ClassMember } = require('../models');

const seedClassData = async () => {
  try {
    await sequelize.transaction(async (t) => {
      // Fetch an existing user to associate with the class
      const adminUser = await User.findOne({ where: { email: 'admin@gmail.com' } });

      if (!adminUser) {
        throw new Error('Admin user not found. Please ensure user data is seeded first.');
      }

      // Seed Classes
      const mathClass = await ClassModel.create({
        name: 'Advanced Mathematics',
        description: 'A class for advanced mathematics topics.',
        host_user_id: adminUser.id,
        code_invite: 'MATH1234',
      }, { transaction: t });

      const scienceClass = await ClassModel.create({
        name: 'Science Explorations',
        description: 'Exploring the wonders of science.',
        host_user_id: adminUser.id,
        code_invite: 'SCIENCE5678',
      }, { transaction: t });

      // Seed Literature Class
      const literatureClass = await ClassModel.create({
        name: 'Literature Studies',
        description: 'Exploring classic and modern literature.',
        host_user_id: adminUser.id,
        code_invite: 'LIT7890',
      }, { transaction: t });

      await ClassMember.create({
        user_id: adminUser.id,
        class_id: mathClass.id,
        role: "manager"
      }, { transaction: t })
      await mathClass.update({member_count: mathClass.member_count + 1}, {transaction: t})

      await ClassMember.create({
        user_id: adminUser.id,
        class_id: scienceClass.id,
        role: "manager"
      }, { transaction: t })
      await scienceClass.update({member_count: scienceClass.member_count + 1}, {transaction: t})

      await ClassMember.create({
        user_id: adminUser.id,
        class_id: literatureClass.id,
        role: "manager"
      }, { transaction: t })
      await literatureClass.update({member_count: literatureClass.member_count + 1}, {transaction: t})
      // Seed additional users
      const users = [];
      for (let i = 1; i <= 5; i++) {
        const user = await User.create({
          name: `User${i}`,
          email: `user${i}@example.com`,
          password: 'password',
          role_system: 'user',
          isVerified: true,
        }, { transaction: t });
        users.push(user);
      }

      // Add users to math class
      for (const user of users) {
        await ClassMember.create({
          user_id: user.id,
          class_id: mathClass.id,

        }, { transaction: t });
        await mathClass.update({member_count: mathClass.member_count + 1}, {transaction: t})
      }

      // Add users to science class
      for (let i = 0; i < users.length-2; i++) {
        await ClassMember.create({
          user_id: users[i].id,
          class_id: scienceClass.id,
        }, { transaction: t });
        await scienceClass.update({member_count: scienceClass.member_count + 1}, {transaction: t})
      }

      // Add two users to literature class
      for (let i = 2; i < 4; i++) {
        await ClassMember.create({
          user_id: users[i].id,
          class_id: literatureClass.id,
        }, { transaction: t });
        await literatureClass.update({member_count: literatureClass.member_count + 1}, {transaction: t})
      }

      console.log('Class and user data seeded successfully');
    });
  } catch (error) {
    console.error('Error seeding class data:', error);
  }
};

module.exports = seedClassData;