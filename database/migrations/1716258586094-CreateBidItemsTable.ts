import {MigrationInterface, QueryRunner, Table, TableForeignKey} from "typeorm";

export class CreateBidItemsTable1716258586094 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.createTable(new Table({
            name: 'bid_items',
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
                    name: 'base_price',
                    type: 'decimal',
                    precision: 10,
                    scale: 2,
                },
                {
                    name: 'name',
                    type: 'varchar',
                },
                {
                    name: 'expiration_time',
                    type: 'timestamp',
                },
                {
                    name: 'status',
                    type: 'varchar',
                },
                {
                    name: 'product_id',
                    type: 'int',
                },
                {
                    name: 'user_id',
                    type: 'int',
                },
            ],
        }));

        await queryRunner.createForeignKey('bid_items', new TableForeignKey({
            columnNames: ['product_id'],
            referencedColumnNames: ['id'],
            referencedTableName: 'products',
            onDelete: 'CASCADE',
        }));

        await queryRunner.createForeignKey('bid_items', new TableForeignKey({
            columnNames: ['user_id'],
            referencedColumnNames: ['id'],
            referencedTableName: 'users',
            onDelete: 'CASCADE',
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        const table = await queryRunner.getTable('bid_items');
        const productForeignKey = table.foreignKeys.find(fk => fk.columnNames.indexOf('product_id') !== -1);
        const userForeignKey = table.foreignKeys.find(fk => fk.columnNames.indexOf('user_id') !== -1);
        await queryRunner.dropForeignKey('bid_items', productForeignKey);
        await queryRunner.dropForeignKey('bid_items', userForeignKey);
        await queryRunner.dropTable('bid_items');
    }

}