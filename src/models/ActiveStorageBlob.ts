import { Model, DataTypes, HasMany } from 'sequelize';
import { ActiveStorageAttachment } from './ActiveStorageAttachment';
import { ActiveStorageVariantRecord } from './ActiveStorageVariantRecord';

export class ActiveStorageBlob extends Model {
  public id!: number;
  public createdAt!: Date;
  public updatedAt!: Date;
  public key!: string;
  public filename!: string;
  public contentType!: string;
  public metadata!: string;
  public serviceName!: string;
  public byteSize!: number;
  public checksum!: string;

  public readonly attachments?: ActiveStorageAttachment[];
  public readonly variantRecords?: ActiveStorageVariantRecord[];

  static associations: {
    attachments: HasMany<ActiveStorageBlob, ActiveStorageAttachment>;
    variantRecords: HasMany<ActiveStorageBlob, ActiveStorageVariantRecord>;
  };
}

ActiveStorageBlob.init({
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
  key: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  filename: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  contentType: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  metadata: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  serviceName: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  byteSize: {
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
});

ActiveStorageBlob.hasMany(ActiveStorageAttachment, {
  sourceKey: 'id',
  foreignKey: 'blob_id',
  as: 'attachments',
});

ActiveStorageBlob.hasMany(ActiveStorageVariantRecord, {
  sourceKey: 'id',
  foreignKey: 'blob_id',
  as: 'variantRecords',
});