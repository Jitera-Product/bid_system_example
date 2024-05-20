import { Model, DataTypes, Association } from 'sequelize';
import { Admin } from './admins';
import { ProductCategory } from './product_categories';

export class Category extends Model {
  public id!: number;
  public createdAt!: Date;
  public updatedAt!: Date;
  public disabled!: boolean;
  public name!: string;
  public adminId!: number;

  public readonly admin?: Admin;
  public readonly productCategories?: ProductCategory[];

  public static associations: {
    admin: Association<Category, Admin>;
    productCategories: Association<Category, ProductCategory>;
  };
}

Category.init(
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
    disabled: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    adminId: {
      type: DataTypes.INTEGER.UNSIGNED,
      allowNull: false,
      references: {
        model: 'admins',
        key: 'id',
      },
    },
  },
  {
    tableName: 'categories',
    sequelize: database, // This is the connection instance
  }
);

Category.belongsTo(Admin, { foreignKey: 'adminId', as: 'admin' });
Admin.hasMany(Category, { foreignKey: 'adminId', as: 'categories' });

Category.hasMany(ProductCategory, { foreignKey: 'categoryId', as: 'productCategories' });
ProductCategory.belongsTo(Category, { foreignKey: 'categoryId', as: 'category' });