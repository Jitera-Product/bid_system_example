import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Product } from './Product';
import { User } from './User';
import { ListingBidItem } from './ListingBidItem';

@Entity('bid_items')
export class BidItem {
  @PrimaryGeneratedColumn()
  id: number;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @Column('decimal', { precision: 10, scale: 2 })
  base_price: number;

  @Column('varchar')
  name: string;

  @Column('timestamp')
  expiration_time: Date;

  @Column('varchar')
  status: string;

  @Column()
  product_id: number;

  @Column()
  user_id: number;

  @ManyToOne(() => Product, product => product.bidItems)
  product: Product;

  @ManyToOne(() => User, user => user.bidItems)
  user: User;

  @OneToMany(() => ListingBidItem, listingBidItem => listingBidItem.bidItem)
  listingBidItems: ListingBidItem[];
}