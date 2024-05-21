import { MigrationInterface, QueryRunner, Table } from 'typeorm';

export class createPaymentMethodsTable1716255982751 implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.createTable(new Table({
            name: 'payment_methods',
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
                    name: 'primary',
                    type: 'boolean',
                    default: false,
                },
                {
                    name: 'method',
                    type: 'varchar',
                },
                {
                    name: 'user_id',
                    type: 'int',
                },
            ],
            foreignKeys: [
                {
                    columnNames: ['user_id'],
                    referencedTableName: 'users',
                    referencedColumnNames: ['id'],
                    onDelete: 'CASCADE',
                },
            ],
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropTable('payment_methods');
    }
}