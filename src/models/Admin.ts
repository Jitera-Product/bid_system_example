import { Model, DataTypes } from 'sequelize';
import { Category, Product, Withdrawal } from './';

class Admin extends Model {
  static init(sequelize) {
    super.init({
      // Assuming other fields are already defined above the patch
      current_sign_in_at: DataTypes.DATE,
      unlock_token: DataTypes.STRING,
      locked_at: DataTypes.DATE,
      failed_attempts: DataTypes.INTEGER,
      unconfirmed_email: DataTypes.STRING,
      encrypted_password: DataTypes.STRING,
      sign_in_count: DataTypes.INTEGER,
      last_sign_in_at: DataTypes.DATE,
      last_sign_in_ip: DataTypes.STRING,
      confirmation_sent_at: DataTypes.DATE,
      current_sign_in_ip: DataTypes.STRING,
      confirmation_token: DataTypes.STRING,
      confirmed_at: DataTypes.DATE,
      reset_password_token: DataTypes.STRING,
      remember_created_at: DataTypes.DATE,
      password_confirmation: DataTypes.STRING,
    }, {
      sequelize,
      modelName: 'Admin',
    });
  }

  static associate(models) {
    this.hasMany(models.Category, { foreignKey: 'admin_id' });
    this.hasMany(models.Product, { foreignKey: 'admin_id' });
    this.hasMany(models.Withdrawal, { foreignKey: 'admin_id' });
  }
}

module.exports = Admin;