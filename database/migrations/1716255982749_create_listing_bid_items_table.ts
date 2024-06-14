import { MigrationInterface, QueryRunner, Table } from 'typeorm';

export class createListingBidItemsTable1716255982749 implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.createTable(new Table({
            name: 'listing_bid_items',
            columns: [
                {
                    name: 'id',
                    type: 'int',
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: 'increment',
                },
                {
                    name: 'created_at',
                    type: 'timestamp',
                    default: 'now()',
                },
                {
                    name: 'updated_at',
                    type: 'timestamp',
                    default: 'now()',
                },
                {
                    name: 'bid_item_id',
                    type: 'int',
                },
                {
                    name: 'listing_id',
                    type: 'int',
                },
            ],
            foreignKeys: [
                {
                    columnNames: ['bid_item_id'],
                    referencedTableName: 'bid_items',
                    referencedColumnNames: ['id'],
                },
                {
                    columnNames: ['listing_id'],
                    referencedTableName: 'listings',
                    referencedColumnNames: ['id'],
                },
            ],
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropTable('listing_bid_items');
    }
}