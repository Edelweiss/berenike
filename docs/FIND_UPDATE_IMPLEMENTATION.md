# Find Update Command - Implementation Summary

## Created Files

1. **`src/Command/FindUpdateCommand.php`** - Main command implementation
2. **`docs/FIND_UPDATE_COMMAND.md`** - Complete documentation
3. **`data/find_update_example.xml`** - Example FileMaker XML file for reference

## Features Implemented

### Core Functionality
- ✅ Reads CSV files with header row
- ✅ Reads FileMaker XML export files
- ✅ Uses `id` field to identify and update find records
- ✅ Updates all fields present in the import file
- ✅ Automatic field name normalization (snake_case → camelCase)
- ✅ Type conversion for integers, dates, and strings

### Command Options
- ✅ `--dry-run` - Test mode without database changes
- ✅ `--batch-size` - Configurable batch processing (default: 20)
- ✅ `--set-empty-to-null` - Set empty fields to NULL in database

### Data Handling
- ✅ Validates `tm` field as positive integer
- ✅ Skips records with invalid `tm` values (e.g., "NN", "SKIPPED", "NOT FOUND", "FILE_NOT_FOUND")
- ✅ Ignores empty values by default (preserves existing data)
- ✅ Optional mode to set empty fields to NULL with `--set-empty-to-null`
- ✅ Append mode with `+` suffix on column names (e.g., `remarks+`)
  - Appends new value to existing content with "; " separator
  - Prevents duplicate content (checks if value already exists)
- ✅ FileMaker-specific field mappings (`trench2` → `trench`, `object id` → `object`, `object no` → `objectNo`)
- ✅ Automatic date/year/month synchronization in Find entity
- ✅ Gracefully handles fields without corresponding entity setters
- ✅ Batch processing with periodic flush for performance

### Error Handling & Reporting
- ✅ Validates file existence
- ✅ Requires `id` column/field
- ✅ Reports records not found in database
- ✅ Detailed statistics output
- ✅ Progress bar during processing
- ✅ Individual error logging without stopping execution

## Usage Examples

### CSV Import
```bash
# Dry run
php bin/console find:update find_update.csv --dry-run

# Actual update
php bin/console find:update find_update.csv

# Custom batch size
php bin/console find:update find_update.csv --batch-size=50

# Set empty fields to NULL
php bin/console find:update find_update.csv --set-empty-to-null

# Append values to existing content using + suffix
php bin/console find:update find_append.csv --dry-run
```

### XML Import
```bash
# Dry run
php bin/console find:update finds_export.xml --dry-run

# Actual update
php bin/console find:update finds_export.xml

# Set empty fields to NULL
php bin/console find:update finds_export.xml --set-empty-to-null
```

## Supported Field Mappings

The command automatically maps field names:

| CSV/XML Field | Entity Property | Type |
|--------------|----------------|------|
| `id` | `id` | integer (identifier) |
| `tm` | `tm` | integer |
| `inventory_number` | `inventoryNumber` | string |
| `material` | `material` | string |
| `heidicon_id` | `heidiconId` | integer |
| `heidicon_uuid` | `heidiconUuid` | string |
| `heidicon_system_object_id` | `heidiconSystemObjectId` | integer |
| `trench` | `trench` | string |
| `date` | `date` | DateTime |
| `year` | `year` | integer |
| `month` | `month` | integer |
| And all other Find entity fields... |

## Testing Results

### CSV Test
- ✅ Successfully processed 204 records from `find_update.csv`
- ✅ Updated 203 records
- ✅ Correctly skipped 1 record marked as "SKIPPED/NOT FOUND"
- ✅ 0 errors

### XML Test
- ✅ Successfully parsed FileMaker XML format
- ✅ Processed 3 sample records
- ✅ Updated 2 records
- ✅ Correctly skipped 1 record marked as "SKIPPED/NOT FOUND"
- ✅ 0 errors

## Technical Details

### Dependencies
- Symfony Console Component
- Doctrine ORM
- Symfony SymfonyStyle for formatted output

### Performance
- Uses batch processing to minimize database transactions
- Clears entity manager periodically to prevent memory issues
- Default batch size: 20 records (configurable)

### XML Format Support
Supports standard FileMaker Pro XML export with:
- `FMPXMLRESULT` root element
- `METADATA/FIELD` for field definitions
- `RESULTSET/ROW/COL/DATA` structure

### Error Recovery
- Individual record errors don't stop processing
- All errors are logged with record ID
- Final statistics show all issues encountered

## Entity Modifications

### Find Entity (`src/Entity/Find.php`)

Modified the `Find` entity to automatically synchronize date-related fields:

**Date Setter (`setDate`)**:
- When a `DateTime` object is set, automatically updates `year` and `month` fields
- Example: `setDate(new DateTime('2025-11-15'))` sets `year=2025` and `month=11`

**Year/Month Setters (`setYear`, `setMonth`)**:
- When `year` or `month` is set, automatically creates/updates the `date` field
- Uses the 1st day of the month for the date
- Example: `setYear(2025)` and `setMonth(11)` creates `date=2025-11-01`

**Benefits**:
- Ensures data consistency between date, year, and month fields
- Prevents mismatches when updating these fields
- Works automatically with the import command

## Integration with Existing Code

The command integrates seamlessly with the existing Symfony application:
- Uses existing `FindRepository` for database operations
- Works with existing `Find` entity and its setters
- Respects Doctrine ORM mapping configuration
- Entity modifications are backward compatible

## Next Steps (Optional Enhancements)

Potential future improvements:
1. Add validation for required fields
2. Support for updating related entities (specialists, images)
3. Backup/rollback functionality
4. Email notifications on completion
5. Support for other file formats (JSON, Excel)
6. Field mapping configuration file for custom field names
