import {MigrationInterface, QueryRunner, TableColumn} from "typeorm";

export class updateCategoriesTable1716255982752 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.addColumns('categories', [
            new TableColumn({
                name: 'disabled',
                type: 'boolean',
                isNullable: false,
                default: false,
            }),
            new TableColumn({
                name: 'name',
                type: 'varchar',
                isNullable: false
            }),
            new TableColumn({
                name: 'admin_id',
                type: 'int',
                isNullable: true
            })
        ]);

        await queryRunner.createForeignKey('categories', new TableForeignKey({
            columnNames: ['admin_id'],
            referencedColumnNames: ['id'],
            referencedTableName: 'admins',
            onDelete: 'SET NULL'
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropColumn('categories', 'disabled');
        await queryRunner.dropColumn('categories', 'name');
        await queryRunner.dropColumn('categories', 'admin_id');
    }

}