import { MigrationInterface, QueryRunner, Table } from 'typeorm';

export class createOauthApplicationsTable1716255982749 implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.createTable(new Table({
            name: 'oauth_applications',
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
                    name: 'name',
                    type: 'varchar',
                },
                {
                    name: 'uid',
                    type: 'varchar',
                },
                {
                    name: 'secret',
                    type: 'varchar',
                },
                {
                    name: 'redirect_uri',
                    type: 'varchar',
                },
                {
                    name: 'scopes',
                    type: 'varchar',
                },
                {
                    name: 'confidential',
                    type: 'boolean',
                },
            ],
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropTable('oauth_applications');
    }
}