import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from './User';
import { Deposit } from './Deposit';
import { Withdrawal } from './Withdrawal';

@Entity('payment_methods')
export class PaymentMethod {
  @PrimaryGeneratedColumn()
  id: number;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @Column({ default: false })
  primary: boolean;

  @Column()
  method: string;

  @Column()
  user_id: number;

  @ManyToOne(() => User, user => user.payment_methods)
  user: User;

  @OneToMany(() => Deposit, deposit => deposit.payment_method)
  deposits: Deposit[];

  @OneToMany(() => Withdrawal, withdrawal => withdrawal.payment_method)
  withdrawals: Withdrawal[];
}