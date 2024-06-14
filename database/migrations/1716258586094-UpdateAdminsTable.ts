import { QueryInterface, DataTypes } from 'sequelize';

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    await queryInterface.addColumn('admins', 'current_sign_in_at', {
      type: DataTypes.DATE,
      allowNull: true,
    });
    await queryInterface.addColumn('admins', 'unlock_token', {
      type: DataTypes.STRING,
      allowNull: true,
    });
    // ... Add other new columns here ...
    await queryInterface.addColumn('admins', 'password_confirmation', {
      type: DataTypes.STRING,
      allowNull: true,
    });
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.removeColumn('admins', 'current_sign_in_at');
    await queryInterface.removeColumn('admins', 'unlock_token');
    // ... Remove other new columns here ...
    await queryInterface.removeColumn('admins', 'password_confirmation');
  }
};
