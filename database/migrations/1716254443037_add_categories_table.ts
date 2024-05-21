import {MigrationInterface, QueryRunner, Table, TableForeignKey} from "typeorm";

export class addCategoriesTable1716254443037 implements MigrationInterface {

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
                    default: 'now()',
                },
                {
                    name: 'updated_at',
                    type: 'timestamp',
                    default: 'now()',
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
            ]
        }), true);

        await queryRunner.createForeignKey('categories', new TableForeignKey({
            columnNames: ['admin_id'],
            referencedColumnNames: ['id'],
            referencedTableName: 'admins',
            onDelete: 'CASCADE'
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        const table = await queryRunner.getTable('categories');
        const foreignKey = table.foreignKeys.find(fk => fk.columnNames.indexOf('admin_id') !== -1);
        await queryRunner.dropForeignKey('categories', foreignKey);
        await queryRunner.dropTable('categories');
    }

}