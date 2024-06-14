import { QueryInterface, DataTypes } from 'sequelize';

module.exports = {
  up: async (queryInterface: QueryInterface): Promise<void> => {
    await queryInterface.createTable('active_storage_attachments', {
      id: {
        type: DataTypes.INTEGER.UNSIGNED,
        autoIncrement: true,
        primaryKey: true,
      },
      createdAt: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
      updatedAt: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
      name: {
        type: new DataTypes.STRING(255),
        allowNull: false,
      },
      recordType: {
        type: new DataTypes.STRING(255),
        allowNull: false,
      },
      recordId: {
        type: DataTypes.INTEGER.UNSIGNED,
        allowNull: false,
      },
      blobId: {
        type: DataTypes.INTEGER.UNSIGNED,
        allowNull: false,
        references: {
          model: 'active_storage_blobs',
          key: 'id',
        },
      },
    });
  },

  down: async (queryInterface: QueryInterface): Promise<void> => {
    await queryInterface.dropTable('active_storage_attachments');
  },
};