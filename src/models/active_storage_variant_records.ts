import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../config/database';
import { ActiveStorageBlob } from './active_storage_blobs';

export class ActiveStorageVariantRecord extends Model {
  public id!: number;
  public created_at!: Date;
  public updated_at!: Date;
  public variation_digest!: string;
  public blob_id!: number;

  public readonly blob?: ActiveStorageBlob;
}

ActiveStorageVariantRecord.init({
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
  variation_digest: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  blob_id: {
    type: DataTypes.INTEGER.UNSIGNED,
    allowNull: false,
  },
}, {
  tableName: 'active_storage_variant_records',
  sequelize: sequelize,
});

ActiveStorageVariantRecord.belongsTo(ActiveStorageBlob, {
  foreignKey: 'blob_id',
  as: 'blob',
});