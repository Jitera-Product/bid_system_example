import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { BidItem } from './BidItem';
import { Listing } from './Listing';

@Entity('listing_bid_items')
export class ListingBidItem {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  created_at: Date;

  @Column()
  updated_at: Date;

  @Column()
  bid_item_id: number;

  @Column()
  listing_id: number;

  @ManyToOne(() => BidItem, bidItem => bidItem.listingBidItems)
  bidItem: BidItem;

  @ManyToOne(() => Listing, listing => listing.listingBidItems)
  listing: Listing;
}