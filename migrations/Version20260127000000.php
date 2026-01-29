<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Add unique constraint on bucket.locus_id and bucket.number
 */
final class Version20260127000000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add unique constraint on bucket (locus_id, number)';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE UNIQUE INDEX unique_locus_number ON bucket (locus_id, number)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('DROP INDEX unique_locus_number ON bucket');
    }
}
