import { MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

export class CreateActiveStorageVariantRecordsTable1716258586094 implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.createTable(new Table({
            name: 'active_storage_variant_records',
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
                },
                {
                    name: 'variation_digest',
                    type: 'varchar',
                },
                {
                    name: 'blob_id',
                    type: 'int',
                },
            ],
        }));

        await queryRunner.createForeignKey('active_storage_variant_records', new TableForeignKey({
            columnNames: ['blob_id'],
            referencedColumnNames: ['id'],
            referencedTableName: 'active_storage_blobs',
            onDelete: 'CASCADE',
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropTable('active_storage_variant_records');
    }
}