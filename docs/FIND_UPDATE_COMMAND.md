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
- Optionally append a `+` sign to field names to append values instead of replacing them

Example CSV structure:
```csv
"tm","inventory_number","special_publication_notes","id","material"
70778,19002,,9,"pottery"
70787,19032,,44,"pottery"
```

#### Append Mode with `+` Sign

Add a `+` sign after a column name to append the value to existing content instead of replacing it:

```csv
"id","publications","remarks+"
9,"Smith 2020","Additional note"
44,"Jones 2019","Updated information"
```

In this example:
- `publications` will **replace** the existing value with "Smith 2020" or "Jones 2019"
- `remarks+` will **append** "Additional note" or "Updated information" to the existing remarks field
  - If the new value is not already part of the existing content, it will be appended with "; " as separator
  - If the new value is already present in the existing content, no change is made
  - If the field is empty, the new value becomes the field content

### FileMaker XML Format

The command supports standard FileMaker Pro XML export format (FMPXMLRESULT). The XML must:
- Include a `METADATA` section defining field names
- Include a `RESULTSET` section with `ROW` and `COL` elements
- Have an `id` field to identify which find record to update
- Field names can end with `+` to enable append mode (same as CSV)

### Data Sanitization

The command automatically sanitizes messy data from FileMaker exports:

**Date Fields:**
- Converts underscores to hyphens: `2009_01_29` → `2009-01-29`
- Converts European format: `22.1.2023` → `2023-01-22`
- Converts slash format: `15/06/2020` → `2020-06-15`

**Text Fields:**
- Removes leading/trailing whitespace
- Removes leading/trailing apostrophes and quotes: `'text'` → `text`
- Normalizes multiple spaces and tabs to single space
- Normalizes multiple newlines to single newline (preserves line breaks)
- Example: `"  'intaglio'  "` → `intaglio`
- Example: `"text    with    spaces"` → `text with spaces`
- Example: `"line1\n\n\nline2"` → `"line1\nline2"`

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

### Append Values to Existing Content
Use the `+` sign after column names to append values instead of replacing:
```bash
php bin/console find:update find_append.csv --dry-run
```

Example CSV with append mode:
```csv
"id","publications+","remarks+"
9,"New Publication 2025","Additional research findings"
44,"Updated Study","Corrected measurements"
```

**Behavior Examples:**

| Existing Value | CSV Column | CSV Value | Result After Update |
|---------------|------------|-----------|---------------------|
| "Smith 2020" | `publications` | "Jones 2019" | "Jones 2019" (replaced) |
| "Smith 2020" | `publications+` | "Jones 2019" | "Smith 2020; Jones 2019" (appended) |
| "Smith 2020; Jones 2019" | `publications+` | "Jones 2019" | "Smith 2020; Jones 2019" (no duplicate) |
| "" (empty) | `publications+` | "Jones 2019" | "Jones 2019" (becomes new value) |
| "Smith 2020" | `publications+` | "" (empty) | "Smith 2020" (unchanged) |

**Important Notes:**
- Duplicate detection is case-insensitive
- The separator "; " is automatically added between values
- The `+` suffix works with both CSV and XML files
- Works with any text field (publications, remarks, description, etc.)

## Field Name Mapping

The command automatically converts field names to match the Find entity:

### General Mappings
- `inventory_number` → `inventoryNumber`
- `tm` → `tm`
- `special_publication_notes` → `specialPublicationNotes`
- `material` → `material`

### FileMaker-Specific Mappings
The following FileMaker field names are automatically mapped to database fields:
- `trench2` → `trench`
- `object id` → `object`
- `object no` → `objectNo`
- `material remarks` → `material_remarks`
- `typology reference` → `typology_reference`
- `dating absolute` → `dating_absolute`
- `SCA Register No` → `sca_register`
- `category no` → `category_no`

### Date Field Synchronization
The `date`, `year`, and `month` fields are automatically synchronized:
- When you set `date`, the `year` and `month` fields are automatically updated
- When you set `year` or `month`, the `date` field is automatically created (using the 1st day of the month)
- Example: Setting `year=2025` and `month=11` automatically creates `date=2025-11-01`

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

## Advanced Usage Scenarios

### Combining Features

You can combine multiple features in a single import:

**Example CSV combining replace, append, and empty fields:**
```csv
"id","tm","publications","remarks+","material"
9,70778,"New Publication 2025","Archive verified",
44,70787,,"Field note added","pottery"
```

**With command:**
```bash
php bin/console find:update combined.csv --set-empty-to-null
```

**Results:**
- Record 9:
  - `tm` = 70778 (replaced)
  - `publications` = "New Publication 2025" (replaced)
  - `remarks` = existing value + "; Archive verified" (appended)
  - `material` = NULL (empty field set to null)
  
- Record 44:
  - `tm` = 70787 (replaced)
  - `publications` = NULL (empty field set to null)
  - `remarks` = existing value + "; Field note added" (appended)
  - `material` = "pottery" (replaced)
