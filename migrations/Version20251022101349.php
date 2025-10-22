<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20251022101349 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add inventoryNumber and tm fields to find table';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE find ADD inventory_number VARCHAR(255) DEFAULT NULL, ADD tm INT DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE find DROP inventory_number, DROP tm');
    }
}
