import { Model, DataTypes } from 'sequelize';
import { Category, Product, Withdrawal } from './';

class Admin extends Model {
  static init(sequelize) {
    super.init({
      // Assuming existing columns are as follows:
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      name: DataTypes.STRING,
      email: DataTypes.STRING,
      encrypted_password: DataTypes.STRING,
      // ... other existing columns
      // Add new columns or modify existing ones as per the updated table schema
    }, {
      sequelize,
      modelName: 'Admin',
    });
  }

  static associate(models) {
    // Define one-to-many relationship to categories
    this.hasMany(models.Category, {
      foreignKey: 'admin_id',
    });
    // Define one-to-many relationship to products
    this.hasMany(models.Product, {
      foreignKey: 'admin_id',
    });
    // Define one-to-many relationship to withdrawals
    this.hasMany(models.Withdrawal, {
      foreignKey: 'admin_id',
    });
    // Assuming there might be other associations, they would be included here as well
  }

  // Any additional methods or logic for the Admin model would go here
}

export default Admin;