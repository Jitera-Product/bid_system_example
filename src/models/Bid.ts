import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from './User';
import { Shipping } from './Shipping';

@Entity()
export class Bid {
  @PrimaryGeneratedColumn()
  id: number;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @Column()
  status: string;

  @Column()
  item_id: number;

  @Column('decimal', { precision: 10, scale: 2 })
  price: number;

  @Column()
  user_id: number;

  @ManyToOne(() => User, user => user.bids)
  user: User;

  @OneToMany(() => Shipping, shipping => shipping.bid)
  shippings: Shipping[];
}