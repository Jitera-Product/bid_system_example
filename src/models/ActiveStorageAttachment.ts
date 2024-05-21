import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../sequelize';
import ActiveStorageBlob from './ActiveStorageBlob';

class ActiveStorageAttachment extends Model {
  public id!: number;
  public createdAt!: Date;
  public updatedAt!: Date;
  public name!: string;
  public recordType!: string;
  public recordId!: number;
  public blobId!: number;

  public static associations: {
    blob: Association<ActiveStorageAttachment, ActiveStorageBlob>;
  };
}

ActiveStorageAttachment.init({
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
}, {
  tableName: 'active_storage_attachments',
  sequelize,
});

ActiveStorageAttachment.belongsTo(ActiveStorageBlob, {
  foreignKey: 'blobId',
  as: 'blob',
});

export default ActiveStorageAttachment;