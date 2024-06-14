import { Model, DataTypes } from 'sequelize';
import { OauthAccessGrants } from './oauth_access_grants';
import { OauthAccessTokens } from './oauth_access_tokens';

export class OauthApplications extends Model {
  public id!: number;
  public createdAt!: Date;
  public updatedAt!: Date;
  public name!: string;
  public uid!: string;
  public secret!: string;
  public redirectUri!: string;
  public scopes!: string;
  public confidential!: boolean;

  public readonly oauthAccessGrants?: OauthAccessGrants[];
  public readonly oauthAccessTokens?: OauthAccessTokens[];
}

OauthApplications.init({
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
    type: DataTypes.STRING,
    allowNull: false,
  },
  uid: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  secret: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  redirectUri: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  scopes: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  confidential: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: true,
  },
}, {
  sequelize,
  tableName: 'oauth_applications',
});

OauthApplications.hasMany(OauthAccessGrants, {
  sourceKey: 'id',
  foreignKey: 'applicationId',
  as: 'oauthAccessGrants',
});

OauthApplications.hasMany(OauthAccessTokens, {
  sourceKey: 'id',
  foreignKey: 'applicationId',
  as: 'oauthAccessTokens',
});