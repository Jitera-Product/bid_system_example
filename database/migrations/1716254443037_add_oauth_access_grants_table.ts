import { QueryInterface, DataTypes } from 'sequelize';

module.exports = {
  up: async (queryInterface: QueryInterface): Promise<void> => {
    await queryInterface.createTable('oauth_access_grants', {
      id: {
        type: DataTypes.INTEGER.UNSIGNED,
        autoIncrement: true,
        primaryKey: true,
      },
      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
      updated_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
      resource_owner_id: {
        type: DataTypes.INTEGER.UNSIGNED,
        allowNull: false,
      },
      token: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      expires_in: {
        type: DataTypes.INTEGER.UNSIGNED,
        allowNull: false,
      },
      redirect_uri: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      revoked_at: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      scopes: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      resource_owner_type: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      application_id: {
        type: DataTypes.INTEGER.UNSIGNED,
        allowNull: false,
        references: {
          model: 'oauth_applications',
          key: 'id',
        },
      },
    });
  },

  down: async (queryInterface: QueryInterface): Promise<void> => {
    await queryInterface.dropTable('oauth_access_grants');
  },
};