import { Model, DataTypes } from 'sequelize';
import { PaymentMethod } from './payment_methods';
import { Wallet } from './wallets';
import { User } from './users';

export class Deposit extends Model {
  public id!: number;
  public createdAt!: Date;
  public updatedAt!: Date;
  public value!: number;
  public status!: string;
  public paymentMethodId!: number;
  public walletId!: number;
  public userId!: number;

  public static associations: {
    paymentMethod: Association<Deposit, PaymentMethod>;
    wallet: Association<Deposit, Wallet>;
    user: Association<Deposit, User>;
  };
}

Deposit.init({
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
  value: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
  },
  status: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  paymentMethodId: {
    type: DataTypes.INTEGER.UNSIGNED,
    allowNull: false,
    references: {
      model: 'payment_methods',
      key: 'id',
    },
  },
  walletId: {
    type: DataTypes.INTEGER.UNSIGNED,
    allowNull: false,
    references: {
      model: 'wallets',
      key: 'id',
    },
  },
  userId: {
    type: DataTypes.INTEGER.UNSIGNED,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id',
    },
  },
}, {
  sequelize,
  tableName: 'deposits',
});

Deposit.belongsTo(PaymentMethod, { foreignKey: 'paymentMethodId', as: 'paymentMethod' });
Deposit.belongsTo(Wallet, { foreignKey: 'walletId', as: 'wallet' });
Deposit.belongsTo(User, { foreignKey: 'userId', as: 'user' });