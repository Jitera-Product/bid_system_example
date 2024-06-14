import { Model, DataTypes, Association } from 'sequelize';
import { ActiveStorageBlob } from './ActiveStorageBlob';

export class ActiveStorageAttachment extends Model {
  public id!: number;
  public created_at!: Date;
  public updated_at!: Date;
  public name!: string;
  public record_type!: string;
  public record_id!: number;
  public blob_id!: number;

  public readonly blob?: ActiveStorageBlob;

  public static associations: {
    blob: Association<ActiveStorageAttachment, ActiveStorageBlob>;
  };
}

ActiveStorageAttachment.init(
  {
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
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    record_type: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    record_id: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: false,
    },
    blob_id: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: false,
    },
  },
  {
    tableName: 'active_storage_attachments',
    sequelize: database, // This is the connection instance
    timestamps: true,
  }
);

ActiveStorageAttachment.belongsTo(ActiveStorageBlob, {
  foreignKey: 'blob_id',
  as: 'blob',
});