import { QueryInterface, DataTypes } from 'sequelize';

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    await queryInterface.createTable('transactions', {
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
      },
      updated_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
      },
      reference_type: {
        type: DataTypes.STRING,
        allowNull: false
      },
      status: {
        type: DataTypes.STRING,
        allowNull: false
      },
      transaction_type: {
        type: DataTypes.STRING,
        allowNull: false
      },
      reference_id: {
        type: DataTypes.INTEGER,
        allowNull: false
      },
      value: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
      },
      wallet_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'wallets',
          key: 'id'
        }
      }
    });
  },
  down: async (queryInterface: QueryInterface) => {
    await queryInterface.dropTable('transactions');
  }
};