import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../config/database';

class ActiveStorageBlobs extends Model {
  public id!: number;
  public created_at!: Date;
  public updated_at!: Date;
  public key!: string;
  public filename!: string;
  public content_type!: string | null;
  public metadata!: string | null;
  public service_name!: string;
  public byte_size!: number;
  public checksum!: string;

  // Define model associations here
  public readonly activeStorageAttachments?: ActiveStorageAttachments[];
  public readonly activeStorageVariantRecords?: ActiveStorageVariantRecords[];
}

ActiveStorageBlobs.init({
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
  key: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  filename: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  content_type: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  metadata: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  service_name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  byte_size: {
    type: DataTypes.BIGINT,
    allowNull: false,
  },
  checksum: {
    type: DataTypes.STRING,
    allowNull: false,
  },
}, {
  sequelize,
  tableName: 'active_storage_blobs',
  timestamps: true,
  updatedAt: 'updated_at',
  createdAt: 'created_at',
});

// Associations
ActiveStorageBlobs.hasMany(ActiveStorageAttachments, {
  foreignKey: 'blob_id',
  as: 'activeStorageAttachments',
});

ActiveStorageBlobs.hasMany(ActiveStorageVariantRecords, {
  foreignKey: 'blob_id',
  as: 'activeStorageVariantRecords',
});

export default ActiveStorageBlobs;