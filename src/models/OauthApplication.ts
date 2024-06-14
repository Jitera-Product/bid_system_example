import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { OauthAccessGrant } from './OauthAccessGrant';
import { OauthAccessToken } from './OauthAccessToken';

@Entity('oauth_applications')
export class OauthApplication {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  created_at: Date;

  @Column()
  updated_at: Date;

  @Column()
  name: string;

  @Column()
  uid: string;

  @Column()
  secret: string;

  @Column()
  redirect_uri: string;

  @Column()
  scopes: string;

  @Column()
  confidential: boolean;

  @OneToMany(() => OauthAccessGrant, oauthAccessGrant => oauthAccessGrant.application)
  oauthAccessGrants: OauthAccessGrant[];

  @OneToMany(() => OauthAccessToken, oauthAccessToken => oauthAccessToken.application)
  oauthAccessTokens: OauthAccessToken[];
}