import { Model, DataTypes } from 'sequelize';
import { Wallet } from './wallets';

export class Transaction extends Model {
  static init(sequelize) {
    return super.init({
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
      },
      updated_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
      },
      reference_type: {
        type: DataTypes.STRING,
        allowNull: false
      },
      status: {
        type: DataTypes.STRING,
        allowNull: false
      },
      transaction_type: {
        type: DataTypes.STRING,
        allowNull: false
      },
      reference_id: {
        type: DataTypes.INTEGER,
        allowNull: false
      },
      value: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
      },
      wallet_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: Wallet,
          key: 'id'
        }
      }
    }, {
      sequelize,
      modelName: 'Transaction',
      tableName: 'transactions',
      timestamps: true,
      updatedAt: 'updated_at',
      createdAt: 'created_at'
    });
  }

  static associate(models) {
    this.belongsTo(models.Wallet, { foreignKey: 'wallet_id', as: 'wallet' });
  }
}