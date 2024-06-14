import {MigrationInterface, QueryRunner, Table, TableForeignKey} from "typeorm";

export class CreateBidsTable1716258586094 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.createTable(new Table({
            name: 'bids',
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
                    onUpdate: 'CURRENT_TIMESTAMP',
                },
                {
                    name: 'status',
                    type: 'varchar',
                },
                {
                    name: 'item_id',
                    type: 'int',
                },
                {
                    name: 'price',
                    type: 'decimal',
                    precision: 10,
                    scale: 2,
                },
                {
                    name: 'user_id',
                    type: 'int',
                },
            ]
        }), true);

        await queryRunner.createForeignKey('bids', new TableForeignKey({
            columnNames: ['user_id'],
            referencedColumnNames: ['id'],
            referencedTableName: 'users',
            onDelete: 'CASCADE'
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        const table = await queryRunner.getTable('bids');
        const foreignKey = table.foreignKeys.find(fk => fk.columnNames.indexOf('user_id') !== -1);
        await queryRunner.dropForeignKey('bids', foreignKey);
        await queryRunner.dropTable('bids');
    }

}