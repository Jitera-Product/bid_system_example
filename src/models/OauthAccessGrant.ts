import { Model, DataTypes, Association } from 'sequelize';
import { OauthApplication } from './OauthApplication';

export class OauthAccessGrant extends Model {
  public id!: number;
  public createdAt!: Date;
  public updatedAt!: Date;
  public resourceOwnerId!: number;
  public token!: string;
  public expiresIn!: number;
  public redirectUri!: string;
  public revokedAt!: Date | null;
  public scopes!: string;
  public resourceOwnerType!: string;
  public applicationId!: number;

  public readonly application?: OauthApplication;

  public static associations: {
    application: Association<OauthAccessGrant, OauthApplication>;
  };
}

OauthAccessGrant.init(
  {
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
    resourceOwnerId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: false,
    },
    token: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    expiresIn: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: false,
    },
    redirectUri: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    revokedAt: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    scopes: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    resourceOwnerType: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    applicationId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: false,
      references: {
        model: 'oauth_applications',
        key: 'id',
      },
    },
  },
  {
    tableName: 'oauth_access_grants',
    sequelize: database, // This is the connection instance
  }
);

OauthAccessGrant.belongsTo(OauthApplication, {
  foreignKey: 'applicationId',
  as: 'application',
});