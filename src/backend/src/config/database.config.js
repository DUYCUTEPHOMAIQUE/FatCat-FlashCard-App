module.exports = {
  host: process.env.DB_HOST || "localhost",
  dialect: process.env.DB_DIALECT || "mysql",
  database: process.env.DB_NAME || "fatcat",
  username: process.env.DB_USERNAME || "root",
  password: process.env.DB_PASSWORD || "passroot",
  port: process.env.DB_PORT || 3306,
  define: {
    timestamps: true,
    underscored: true,
  },
  logging: false,
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000,
  },
};
