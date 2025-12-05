# FileMaker Data Integration

This guide explains how to import and synchronize data from FileMaker Pro databases into the Berenike system using CSV and XML formats.

**Required Permission**: `ROLE_EDITOR` or `ROLE_ADMIN`

## Table of Contents

- [Overview](#overview)
- [Supported File Formats](#supported-file-formats)
- [The find:update Command](#the-findupdate-command)
- [Preparing Your Data](#preparing-your-data)
- [Field Mappings](#field-mappings)
- [Import Process](#import-process)
- [Update Modes](#update-modes)
- [Advanced Features](#advanced-features)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## Overview

The Berenike database includes a powerful command-line tool for importing and updating find records from FileMaker Pro databases. This tool supports:

- ✅ **CSV imports**: Simple spreadsheet format
- ✅ **FileMaker XML exports**: Native FileMaker format
- ✅ **Bulk updates**: Process hundreds of records efficiently
- ✅ **Field mapping**: Automatic translation between FileMaker and database fields
- ✅ **Update modes**: Replace or append data
- ✅ **Dry run**: Test imports without making changes
- ✅ **Date synchronization**: Automatic date field coordination

### Why Use Bulk Import?

Bulk import is ideal for:
- Migrating legacy FileMaker data
- Annual data updates from field seasons
- Correcting systematic errors
- Adding new fields to many records
- Synchronizing with external databases

## Supported File Formats

### 1. CSV (Comma-Separated Values)

**Advantages**:
- Simple to create and edit
- Works with Excel, Google Sheets, Numbers
- Easy to review before import
- Lightweight files

**Requirements**:
- Must have header row with field names
- Must include `id` column to identify records
- Use commas as delimiters
- Quote text fields containing commas

**Example CSV**:
```csv
"id","tm","inventory_number","material","object"
9,70778,"BE23-045","pottery","Amphora body sherd"
44,70787,"BE23-046","bronze","Coin"
```

### 2. FileMaker XML (FMPXMLRESULT)

**Advantages**:
- Native FileMaker format
- Preserves data types
- Exports directly from FileMaker Pro
- Handles complex data structures

**Requirements**:
- Standard FMPXMLRESULT format
- Must include METADATA section
- Must include RESULTSET section
- Must have `id` field

**Example XML Structure**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<FMPXMLRESULT>
  <METADATA>
    <FIELD NAME="id"/>
    <FIELD NAME="tm"/>
    <FIELD NAME="inventory_number"/>
  </METADATA>
  <RESULTSET>
    <ROW>
      <COL><DATA>9</DATA></COL>
      <COL><DATA>70778</DATA></COL>
      <COL><DATA>BE23-045</DATA></COL>
    </ROW>
  </RESULTSET>
</FMPXMLRESULT>
```

## The find:update Command

### Basic Syntax

```bash
php bin/console find:update <filename> [options]
```

### Arguments

- **filename**: Name of file in `/data` directory
  - Example: `find_update.csv`
  - Example: `finds_export.xml`

### Options

#### --dry-run

Test the import without making changes:
```bash
php bin/console find:update find_update.csv --dry-run
```

**What it does**:
- Reads and validates file
- Shows what would be updated
- Reports any errors
- **Does NOT** save changes to database

**Use for**:
- Testing before actual import
- Validating data format
- Checking field mappings
- Identifying problems

#### -b, --batch-size=N

Number of records to process before saving:
```bash
php bin/console find:update find_update.csv --batch-size=50
```

**Default**: 20 records per batch

**Recommendations**:
- Small files: Use default (20)
- Large files: Increase to 50-100
- Very large files: Increase to 200+
- Adjust based on performance

**Why it matters**:
- Smaller batches: More frequent database saves, slower but safer
- Larger batches: Fewer database saves, faster but uses more memory

#### --set-empty-to-null

Set empty fields to NULL in database:
```bash
php bin/console find:update find_update.csv --set-empty-to-null
```

**Default behavior** (without this option):
- Empty values in CSV/XML are ignored
- Existing database values are preserved

**With this option**:
- Empty values clear the database field
- Field is set to NULL

**Example**:

CSV:
```csv
"id","tm","material"
9,70778,
```

**Without --set-empty-to-null**:
- `tm` = 70778 (updated)
- `material` = (unchanged, keeps existing value)

**With --set-empty-to-null**:
- `tm` = 70778 (updated)
- `material` = NULL (cleared)

### Command Location

Run from project root directory:
```bash
cd /path/to/berenike
php bin/console find:update filename.csv
```

## Preparing Your Data

### Step 1: Export from FileMaker

#### Using FileMaker Pro

1. Open your FileMaker database
2. Go to **File** → **Export Records**
3. Choose export format:
   - **CSV**: For simple data
   - **XML**: For complex data with FileMaker structure
4. Select fields to export:
   - Always include **id** field (required)
   - Include fields you want to update
   - Use appropriate field names (see mappings below)
5. Save file to `/data` directory

#### Field Selection Tips

Include:
- ✅ `id` field (REQUIRED)
- ✅ Fields you want to update
- ✅ Trismegistos numbers if updating
- ✅ Inventory numbers for reference
- ❌ Don't include fields you don't want to change

### Step 2: Clean Your Data

Before importing, review and clean:

#### Check Required Fields
- ✅ Every record has an `id`
- ✅ IDs match database records
- ✅ No duplicate IDs

#### Validate Data Types
- ✅ Numbers are numeric (not text)
- ✅ Dates are in correct format: `YYYY-MM-DD`
- ✅ TM numbers are positive integers
- ✅ No invalid characters

#### Review Special Values
- Records with invalid TM values are skipped:
  - `NN` (not numbered)
  - `SKIPPED`
  - `NOT FOUND`
  - `FILE_NOT_FOUND`
  - Negative numbers
  - Non-numeric text

#### Handle Empty Values
Decide for each field:
- Leave empty to preserve existing value
- Use `--set-empty-to-null` to clear fields

### Step 3: Save to Data Directory

Place file in:
```
/path/to/berenike/data/filename.csv
```

or

```
/path/to/berenike/data/filename.xml
```

## Field Mappings

The command automatically translates FileMaker field names to database fields.

### Automatic Conversions

#### Case Conversion
- `inventory_number` → `inventoryNumber` (snake_case to camelCase)
- `InventoryNumber` → `inventoryNumber` (PascalCase to camelCase)
- `INVENTORY_NUMBER` → `inventoryNumber` (UPPERCASE to camelCase)

#### FileMaker-Specific Mappings

These FileMaker field names are automatically mapped:

| FileMaker Field | Database Field | Description |
|----------------|----------------|-------------|
| `trench2` | `trench` | Excavation area |
| `object id` | `object` | Object description |
| `object no` | `objectNo` | Object number |
| `material remarks` | `materialRemarks` | Material notes |
| `typology reference` | `typologyReference` | Type citations |
| `dating absolute` | `datingAbsolute` | Chronological date |
| `SCA Register No` | `scaRegister` | Egyptian register |
| `category no` | `categoryNo` | Category number |

### Standard Field Names

Use these field names in your CSV/XML:

#### Core Identification
- `id` - Database ID (REQUIRED)
- `tm` - Trismegistos number
- `inventoryNumber` - Inventory/find number

#### Context
- `trench` - Excavation area
- `locus` - Locus number
- `bucket` - Bucket number
- `date` - Find date (YYYY-MM-DD)
- `year` - Year (integer)
- `month` - Month (1-12)

#### Description
- `object` - What it is
- `objectNo` - Object number
- `objectType` - Specific type
- `category` - Category
- `categoryNo` - Category number
- `material` - Material type
- `materialRemarks` - Material notes

#### Physical Properties
- `dimensions` - Measurements
- `weight` - Weight
- `quantity` - Number of pieces
- `preservation` - Condition
- `description` - Full description

#### Classification
- `datingAbsolute` - Date/period
- `typologyReference` - Type citations
- `publications` - Bibliography
- `remarks` - Notes
- `specialPublicationNotes` - Publication info

#### HeidICON
- `heidiconId` - HeidICON ID number
- `heidiconUuid` - HeidICON UUID
- `heidiconSystemObjectId` - System object ID

#### Administrative
- `scaRegister` - SCA register number
- `storageLocation` - Where stored
- `currentLocation` - Current location

### Date Field Synchronization

The system automatically synchronizes date fields:

**Setting date automatically updates year and month**:
```csv
"id","date"
9,"2023-06-15"
```
Results in:
- `date` = 2023-06-15
- `year` = 2023
- `month` = 6

**Setting year and month automatically creates date**:
```csv
"id","year","month"
9,2023,6
```
Results in:
- `year` = 2023
- `month` = 6
- `date` = 2023-06-01 (1st day of month)

## Import Process

### Standard Import Workflow

#### 1. Prepare File
```bash
# Place file in data directory
cp ~/Desktop/finds_update.csv /path/to/berenike/data/
```

#### 2. Test with Dry Run
```bash
php bin/console find:update finds_update.csv --dry-run
```

Review output for:
- ✅ Number of records to process
- ⚠️ Any warnings or errors
- 📊 Statistics

#### 3. Execute Import
```bash
php bin/console find:update finds_update.csv
```

Watch progress bar and output.

#### 4. Review Results

Check output statistics:
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

#### 5. Verify in Database

- Navigate to affected finds
- Check updated fields
- Verify data accuracy

### Example: CSV Import

**File**: `data/pottery_update.csv`
```csv
"id","tm","material","preservation","remarks"
9,70778,"pottery","fragmentary","Analysis complete"
44,70787,"pottery","good","Requires drawing"
67,70801,"pottery","fragmentary","Similar to L-022"
```

**Command**:
```bash
php bin/console find:update pottery_update.csv --dry-run
```

**Review output**, then:
```bash
php bin/console find:update pottery_update.csv
```

### Example: XML Import

**File**: `data/finds_from_filemaker.xml`

**Command**:
```bash
php bin/console find:update finds_from_filemaker.xml --batch-size=100
```

Processes 100 records at a time for efficiency.

## Update Modes

### Replace Mode (Default)

**Behavior**: Values in CSV/XML replace database values

**Example**:

Database before:
```
Find ID 9:
  material: "pottery"
  preservation: "fragmentary"
  remarks: "Old notes"
```

CSV:
```csv
"id","material","preservation"
9,"ceramic","good"
```

Database after:
```
Find ID 9:
  material: "ceramic" (replaced)
  preservation: "good" (replaced)
  remarks: "Old notes" (unchanged - not in CSV)
```

### Append Mode (+ suffix)

**Behavior**: Values in CSV/XML are appended to existing content

**Syntax**: Add `+` after column name

**Example**:

Database before:
```
Find ID 9:
  publications: "Smith 2020"
  remarks: "Pottery sherd"
```

CSV:
```csv
"id","publications+","remarks+"
9,"Jones 2021","Analysis by specialist"
```

Database after:
```
Find ID 9:
  publications: "Smith 2020; Jones 2021" (appended)
  remarks: "Pottery sherd; Analysis by specialist" (appended)
```

#### Append Mode Features

1. **Separator**: Automatically adds `; ` between values
2. **Duplicate Detection**: Won't add if value already exists
3. **Case-Insensitive**: Checks for duplicates regardless of case
4. **Empty Handling**: Empty new values don't add separators

#### Append Mode Examples

**No Duplicate**:
```
Existing: "Smith 2020"
New (with +): "Jones 2021"
Result: "Smith 2020; Jones 2021"
```

**Duplicate Detected**:
```
Existing: "Smith 2020; Jones 2021"
New (with +): "Jones 2021"
Result: "Smith 2020; Jones 2021" (unchanged)
```

**Empty Existing**:
```
Existing: ""
New (with +): "Jones 2021"
Result: "Jones 2021" (no leading separator)
```

**Empty New**:
```
Existing: "Smith 2020"
New (with +): ""
Result: "Smith 2020" (unchanged)
```

### Combining Modes

You can mix replace and append in one import:

```csv
"id","tm","publications","remarks+"
9,70778,"Smith 2020","Verified 2025"
44,70787,,"New photograph added"
```

Results:
- Record 9:
  - `tm`: replaced with 70778
  - `publications`: replaced with "Smith 2020"
  - `remarks`: appended "Verified 2025"
  
- Record 44:
  - `tm`: replaced with 70787
  - `publications`: set to NULL (if using --set-empty-to-null)
  - `remarks`: appended "New photograph added"

## Advanced Features

### Batch Processing

For very large files:

```bash
php bin/console find:update large_file.csv --batch-size=200
```

**Benefits**:
- Faster processing
- Lower memory usage
- Progress updates

**Considerations**:
- Larger batches = less frequent saves
- If error occurs, more records may be lost
- Balance speed vs. safety

### Progress Monitoring

The command shows:
- **Progress bar**: Visual progress indicator
- **Percentage**: Completion percentage
- **Time estimate**: Estimated time remaining
- **Current record**: What's being processed

### Error Handling

The command continues processing even with errors:
- Individual record errors don't stop the import
- Errors are logged and reported
- Statistics show error count
- Review errors after completion

### Warning Messages

Common warnings:
- `Record not found: ID 999` - Record doesn't exist in database
- `Skipping record with invalid TM` - Invalid TM value
- `Empty id field` - Record missing required ID

### Special Value Handling

Automatically skipped:
- TM values: `NN`, `SKIPPED`, `NOT FOUND`, `FILE_NOT_FOUND`
- Negative TM numbers
- Non-numeric TM values

These records are counted as "skipped" in statistics.

## Troubleshooting

### File Not Found

**Error**: `File not found: filename.csv`

**Solutions**:
1. Check file is in `/data` directory
2. Verify filename spelling
3. Check file extension (.csv or .xml)
4. Use correct path: just filename, not full path

### Missing ID Column

**Error**: `CSV must contain an 'id' column`

**Solutions**:
1. Add `id` column to CSV header
2. Ensure `id` field exists in XML METADATA
3. Check column name spelling (case-insensitive)
4. Export ID field from FileMaker

### Record Not Found

**Warning**: `Record not found: ID 999`

**Causes**:
- Record was deleted from database
- Wrong ID in CSV
- ID from different database

**Solutions**:
1. Verify IDs exist in database
2. Export current IDs from database
3. Cross-check CSV IDs with database
4. Remove non-existent IDs from import file

### Invalid TM Value

**Warning**: `Skipping record with invalid TM: NN`

**Causes**:
- TM value is not a number
- Special placeholder values
- Negative numbers

**Expected Behavior**:
- Records are automatically skipped
- Counted in "skipped" statistics
- Other fields not updated for these records

**Solutions**:
- Remove invalid TM values before import
- Or leave them - system handles automatically
- Or use separate import for TM values only

### Type Conversion Errors

**Error**: `Invalid value for field 'year': abc`

**Causes**:
- Non-numeric value in numeric field
- Wrong date format
- Invalid data type

**Solutions**:
1. Check data types match field requirements
2. Clean data before import:
   - Numbers: `12345` not `"12345"`
   - Dates: `2023-06-15` format
   - Boolean: `true`/`false` or `1`/`0`
3. Remove invalid values
4. Use --set-empty-to-null if appropriate

### Performance Issues

**Problem**: Import is very slow

**Solutions**:
1. Increase batch size:
   ```bash
   --batch-size=100
   ```
2. Check database performance
3. Close other applications
4. Split large files into smaller chunks
5. Run during off-peak hours

### Memory Errors

**Error**: `Out of memory`

**Solutions**:
1. Increase PHP memory limit
2. Reduce batch size
3. Split file into smaller parts
4. Process in stages

## Best Practices

### 1. Always Test First

```bash
# ALWAYS start with dry run
php bin/console find:update file.csv --dry-run

# Review output carefully

# Then execute
php bin/console find:update file.csv
```

### 2. Backup Before Large Imports

Before major data imports:
1. Backup database
2. Export current data
3. Document changes
4. Test on development copy first

### 3. Start Small

For new imports:
1. Create small test file (10-20 records)
2. Test import process
3. Verify results
4. Then process full dataset

### 4. Use Version Control for Data Files

Track your import files:
- Keep original exports
- Date your files: `finds_update_2025-12-05.csv`
- Document changes made
- Store in version control

### 5. Document Field Mappings

Create reference document:
```
FileMaker Field → Database Field
--------------------------------
Trench2        → trench
Object ID      → object
Material Notes → materialRemarks
```

### 6. Validate Data First

Before export from FileMaker:
- Fix data issues
- Remove test records
- Verify IDs
- Check required fields

### 7. Use Meaningful Filenames

Good:
- `pottery_tm_updates_2025-12-05.csv`
- `textiles_heidicon_ids.csv`
- `2023_excavation_finds.xml`

Bad:
- `update.csv`
- `file1.csv`
- `export.xml`

### 8. Monitor Results

After import:
- Check statistics output
- Verify sample records
- Review warnings/errors
- Test searches and displays

### 9. Keep Import Logs

Save command output:
```bash
php bin/console find:update file.csv > import_log_2025-12-05.txt 2>&1
```

Helps with:
- Troubleshooting issues
- Documentation
- Audit trail

### 10. Incremental Updates

For regular updates:
- Export only changed records
- Use smaller, frequent imports
- Less risk than large bulk imports
- Easier to verify and rollback

## Related Topics

- [Adding New Records](./Adding-New-Records.md) - Manual data entry
- [Viewing Finds](./Viewing-Finds.md) - Verify imported data
- [HeidICON Integration](./HeidICON-Integration.md) - Import image IDs
- [User Guide Home](./User-Guide.md) - Return to main guide

## External Resources

- **FileMaker Pro**: https://www.claris.com/filemaker/
- **CSV Format**: https://en.wikipedia.org/wiki/Comma-separated_values
- **FMPXMLRESULT**: FileMaker Pro XML export format documentation

---

**Last Updated**: December 2025  
**Required Permission**: ROLE_EDITOR or ROLE_ADMIN  
**Command**: `php bin/console find:update`
