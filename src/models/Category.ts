import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Admin } from './Admin';
import { ProductCategory } from './ProductCategory';

@Entity('categories')
export class Category {
  @PrimaryGeneratedColumn()
  id: number;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @Column({ default: false })
  disabled: boolean;

  @Column()
  name: string;

  @ManyToOne(() => Admin, admin => admin.categories)
  admin: Admin;

  @OneToMany(() => ProductCategory, productCategory => productCategory.category)
  productCategories: ProductCategory[];
}
