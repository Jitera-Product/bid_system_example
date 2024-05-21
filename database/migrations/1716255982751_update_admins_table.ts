import { QueryInterface, DataTypes } from 'sequelize';

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    await queryInterface.addColumn('admins', 'current_sign_in_at', {
      type: DataTypes.DATE,
      allowNull: true,
    });
    // ... Add other new columns here
    // Remember to follow the updated table schema
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.removeColumn('admins', 'current_sign_in_at');
    // ... Revert other changes here
  },
};