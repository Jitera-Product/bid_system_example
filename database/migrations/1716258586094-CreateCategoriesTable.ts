import { MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

export class CreateCategoriesTable1716258586094 implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.createTable(new Table({
            name: 'categories',
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
                    default: 'CURRENT_TIMESTAMP',
                },
                {
                    name: 'updated_at',
                    type: 'timestamp',
                    default: 'CURRENT_TIMESTAMP',
                    onUpdate: 'CURRENT_TIMESTAMP',
                },
                {
                    name: 'disabled',
                    type: 'boolean',
                    default: false,
                },
                {
                    name: 'name',
                    type: 'varchar',
                },
                {
                    name: 'admin_id',
                    type: 'int',
                },
            ],
        }));

        await queryRunner.createForeignKey('categories', new TableForeignKey({
            columnNames: ['admin_id'],
            referencedColumnNames: ['id'],
            referencedTableName: 'admins',
            onDelete: 'CASCADE',
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropTable('categories');
    }
}