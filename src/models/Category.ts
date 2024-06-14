import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Admin } from './Admin';
import { ProductCategory } from './ProductCategory';

@Entity('categories')
export class Category {
  @PrimaryGeneratedColumn()
  id: number;

  @CreateDateColumn({ type: 'timestamp' })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updated_at: Date;

  @Column({ type: 'boolean' })
  disabled: boolean;

  @Column({ type: 'varchar' })
  name: string;

  @Column()
  admin_id: number;

  @ManyToOne(() => Admin, admin => admin.categories)
  admin: Admin;

  @OneToMany(() => ProductCategory, productCategory => productCategory.category)
  productCategories: ProductCategory[];
}