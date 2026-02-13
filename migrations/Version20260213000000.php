<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Update unique constraint on locus to include addendum field
 */
final class Version20260213000000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Update unique constraint on locus (excavation_id, number, addendum)';
    }

    public function up(Schema $schema): void
    {
        // Drop the old unique constraint
        $this->addSql('ALTER TABLE locus DROP INDEX unique_locus_excavation_number');
        
        // Add the new unique constraint including addendum
        $this->addSql('CREATE UNIQUE INDEX unique_locus_excavation_number_addendum ON locus (excavation_id, number, addendum)');
    }

    public function down(Schema $schema): void
    {
        // Drop the new unique constraint
        $this->addSql('ALTER TABLE locus DROP INDEX unique_locus_excavation_number_addendum');
        
        // Restore the old unique constraint
        $this->addSql('CREATE UNIQUE INDEX unique_locus_excavation_number ON locus (excavation_id, number)');
    }
}
