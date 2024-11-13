const { User } = require('../models');
const {sequelize} = require('../database/init.database');

const seedUserData = async () => {
  try {
    await sequelize.transaction(async (t) => {
      const user = await User.create({
        name: 'admin',
        password: 'admin',
        email: 'admin@gmail.com',
        role_system: 'admin',
      }, { transaction: t });
      console.log(`User data seeded successfully\nemail: ${user.email}\npassword: ${user.password}`);
    });
  } catch (error) {
    console.error('Error seeding user data:', error);
  }
}

module.exports = seedUserData;