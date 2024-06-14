import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../config/database';
import { Category } from './category';
import { Product } from './product';
import { Withdrawal } from './withdrawal';

export class Admin extends Model {
  public id!: number;
  public name!: string;
  public email!: string;
  public encrypted_password!: string;
  public password?: string;
  public password_confirmation?: string;
  public sign_in_count!: number;
  public current_sign_in_at?: Date;
  public last_sign_in_at?: Date;
  public current_sign_in_ip?: string;
  public last_sign_in_ip?: string;
  public confirmation_token?: string;
  public confirmed_at?: Date;
  public confirmation_sent_at?: Date;
  public reset_password_token?: string;
  public reset_password_sent_at?: Date;
  public remember_created_at?: Date;
  public unlock_token?: string;
  public locked_at?: Date;
  public failed_attempts!: number;
  public unconfirmed_email?: string;
  public created_at!: Date;
  public updated_at!: Date;

  // associations
  public getCategories!: HasManyGetAssociationsMixin<Category>;
  public addCategory!: HasManyAddAssociationMixin<Category, number>;
  public hasCategory!: HasManyHasAssociationMixin<Category, number>;
  public countCategories!: HasManyCountAssociationsMixin;
  public createCategory!: HasManyCreateAssociationMixin<Category>;

  public getProducts!: HasManyGetAssociationsMixin<Product>;
  public addProduct!: HasManyAddAssociationMixin<Product, number>;
  public hasProduct!: HasManyHasAssociationMixin<Product, number>;
  public countProducts!: HasManyCountAssociationsMixin;
  public createProduct!: HasManyCreateAssociationMixin<Product>;

  public getWithdrawals!: HasManyGetAssociationsMixin<Withdrawal>;
  public addWithdrawal!: HasManyAddAssociationMixin<Withdrawal, number>;
  public hasWithdrawal!: HasManyHasAssociationMixin<Withdrawal, number>;
  public countWithdrawals!: HasManyCountAssociationsMixin;
  public createWithdrawal!: HasManyCreateAssociationMixin<Withdrawal>;
}

Admin.init({
  id: {
    type: DataTypes.INTEGER.UNSIGNED,
    autoIncrement: true,
    primaryKey: true,
  },
  name: {
    type: new DataTypes.STRING(128),
    allowNull: false,
  },
  email: {
    type: new DataTypes.STRING(128),
    allowNull: false,
    unique: true,
  },
  encrypted_password: {
    type: new DataTypes.STRING(128),
    allowNull: false,
  },
  // ... other fields
  created_at: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  updated_at: {
    type: DataTypes.DATE,
    allowNull: false,
  },
}, {
  tableName: 'admins',
  sequelize,
});

// Relationships
Admin.hasMany(Category, { sourceKey: 'id', foreignKey: 'admin_id', as: 'categories' });
Admin.hasMany(Product, { sourceKey: 'id', foreignKey: 'admin_id', as: 'products' });
Admin.hasMany(Withdrawal, { sourceKey: 'id', foreignKey: 'admin_id', as: 'withdrawals' });