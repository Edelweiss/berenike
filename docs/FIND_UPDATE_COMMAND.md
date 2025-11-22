# Find Update Command

## Overview

The `find:update` command allows you to bulk update find records in the database from CSV or FileMaker XML export files.

## Usage

```bash
php bin/console find:update <filename> [options]
```

### Arguments

- `filename` - The name of the file (CSV or XML) located in the `/data` directory

### Options

- `--dry-run` - Run the command without persisting changes to the database (useful for testing)
- `-b, --batch-size=N` - Number of records to process before flushing to database (default: 20)
- `--set-empty-to-null` - Set empty fields in the CSV/XML to null in the database (by default, empty values are ignored and existing data is preserved)

## File Formats

### CSV Format

The CSV file must:
- Have a header row with column names matching database field names
- Contain an `id` column to identify which find record to update
- Use snake_case or camelCase field names (both are supported)

Example CSV structure:
```csv
"tm","inventory_number","special_publication_notes","id","material"
70778,19002,,9,"pottery"
70787,19032,,44,"pottery"
```

### FileMaker XML Format

The command supports standard FileMaker Pro XML export format (FMPXMLRESULT). The XML must:
- Include a `METADATA` section defining field names
- Include a `RESULTSET` section with `ROW` and `COL` elements
- Have an `id` field to identify which find record to update

## Examples

### Dry Run (Test Mode)
Test the update without making changes to the database:
```bash
php bin/console find:update find_update.csv --dry-run
```

### Update from CSV
```bash
php bin/console find:update find_update.csv
```

### Update from FileMaker XML
```bash
php bin/console find:update finds_export.xml
```

### Update with Custom Batch Size
Process 50 records at a time (useful for large files):
```bash
php bin/console find:update find_update.csv --batch-size=50
```

### Set Empty Fields to Null
Update records and set empty fields to null in the database:
```bash
php bin/console find:update find_update.csv --set-empty-to-null
```

This is useful when you want to clear existing data. For example, if the CSV contains:
```csv
"id","tm","material"
9,70778,
```
- Without `--set-empty-to-null`: The `material` field will keep its existing value
- With `--set-empty-to-null`: The `material` field will be set to NULL

## Field Name Mapping

The command automatically converts field names to match the Find entity:

- `inventory_number` → `inventoryNumber`
- `tm` → `tm`
- `special_publication_notes` → `specialPublicationNotes`
- `material` → `material`

## Special Values and Validation

The command recognizes and handles special values:
- Records with `tm` values that are not valid positive integers are automatically skipped (e.g., "NN", "SKIPPED", "NOT FOUND", "FILE_NOT_FOUND")
- The `tm` field must be a positive integer or empty
- Empty values are ignored by default (existing database values are preserved)
- Use `--set-empty-to-null` to explicitly set empty fields to NULL in the database

## Output

The command displays:
- Progress bar during processing
- Warnings for skipped or not-found records
- Final statistics showing:
  - Total records processed
  - Records successfully updated
  - Records not found in database
  - Records skipped
  - Errors encountered

Example output:
```
 ------------------------- ------- 
  Metric                    Count  
 ------------------------- ------- 
  Total records processed   204    
  Records updated           203    
  Records not found         0      
  Records skipped           1      
  Errors                    0      
 ------------------------- -------
```

## Supported Fields

All fields defined in the Find entity can be updated, including:
- `tm` - Trismegistos number (integer)
- `inventoryNumber` - String
- `material` - String
- `heidiconId`, `heidiconUuid`, `heidiconSystemObjectId` - HeidICON identifiers
- `trench`, `scaRegister`, `object`, `category` - String fields
- `weight`, `quantity`, `dimensions` - Text fields
- `preservation`, `description`, `remarks` - Text fields
- `datingAbsolute`, `typologyReference`, `publications` - Text fields
- And more...

## Type Conversions

The command automatically handles type conversions:
- Numeric fields (`tm`, `year`, `month`) are converted to integers
- Date fields are converted to DateTime objects
- All other fields are treated as strings

## Error Handling

- Invalid file paths result in an error message
- Missing `id` column/field causes the command to fail
- Individual record errors are logged but don't stop processing
- Use `--dry-run` to validate your data before committing changes

## Performance Tips

1. Use larger `--batch-size` values for large files (e.g., 100 or 200)
2. Always test with `--dry-run` first
3. Monitor the output for "not found" or "error" messages
4. Keep CSV/XML files in the `/data` directory for easy access
