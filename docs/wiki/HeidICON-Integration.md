# HeidICON Integration

This guide explains how the Berenike database integrates with HeidICON, Heidelberg University's digital image repository, and how to link images to archaeological finds.

## Table of Contents

- [What is HeidICON?](#what-is-heidicon)
- [Understanding HeidICON Identifiers](#understanding-heidicon-identifiers)
- [Linking Images to Finds](#linking-images-to-finds)
- [Finding HeidICON Identifiers](#finding-heidicon-identifiers)
- [Viewing Images](#viewing-images)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## What is HeidICON?

**HeidICON** is Heidelberg University's image database and digital repository for archaeological, art historical, and cultural heritage images.

### Key Features

- 🖼️ **Digital Image Repository**: Store high-resolution archaeological photographs
- 🔗 **Permanent URLs**: Stable links to images
- 📊 **Metadata Management**: Rich descriptive information
- 🔍 **Search Capabilities**: Find images by various criteria
- 📱 **Public Access**: Share images with researchers worldwide
- 🏛️ **Long-term Preservation**: Institutional backup and archiving

### Website

Access HeidICON at: **https://heidicon.ub.uni-heidelberg.de/**

### Why Use HeidICON?

The Berenike database links to HeidICON rather than storing images directly because:

1. **Separation of Concerns**: Database manages data, HeidICON manages images
2. **Storage Efficiency**: No large image files in database
3. **Professional Image Management**: HeidICON provides proper IIIF standards
4. **Permanent Links**: URLs remain stable over time
5. **Institutional Support**: University maintains and backs up images
6. **Public Accessibility**: Images can be shared easily with researchers

## Understanding HeidICON Identifiers

The Berenike database uses **three types** of HeidICON identifiers to link to images:

### 1. HeidICON ID

- **Type**: Integer number
- **Example**: `12345`
- **Description**: Simple numeric identifier
- **Field**: `heidiconId`
- **Validation**: Must be positive integer or null

#### Usage Example
```
Find TM 70778
HeidICON ID: 12345
```

### 2. HeidICON UUID

- **Type**: Universally Unique Identifier (UUID)
- **Format**: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
- **Example**: `550e8400-e29b-41d4-a716-446655440000`
- **Description**: Globally unique identifier following UUID standard
- **Field**: `heidiconUuid`
- **Validation**: Must match UUID format pattern

#### UUID Format Rules

- 36 characters total
- 5 groups separated by hyphens: `8-4-4-4-12`
- Hexadecimal characters (0-9, a-f)
- Case-insensitive
- Example: `550e8400-e29b-41d4-a716-446655440000`

#### Usage Example
```
Find TM 70778
HeidICON UUID: 550e8400-e29b-41d4-a716-446655440000
```

### 3. HeidICON System Object ID

- **Type**: Integer number
- **Example**: `987654`
- **Description**: Internal system reference number
- **Field**: `heidiconSystemObjectId`
- **Validation**: Must be positive integer or null

#### Usage Example
```
Find TM 70778
HeidICON System Object ID: 987654
```

### Which Identifier to Use?

You can use **one, two, or all three** identifiers:

- **Minimum**: At least one identifier to link to HeidICON
- **Recommended**: Use UUID as it's globally unique and permanent
- **Best Practice**: Record all three when available for redundancy

### Identifier Relationships

These identifiers typically refer to the **same image** in HeidICON:
- They are different ways to reference the same digital object
- Having multiple identifiers provides backup if one changes
- Different HeidICON tools may use different identifier types

## Linking Images to Finds

### During Find Creation

When creating a new find:

1. Navigate to **Admin Dashboard**
2. Click **"Create new Find"**
3. Fill in basic find information
4. Scroll to **HeidICON section**
5. Enter one or more identifiers:
   - **HeidICON ID**: Enter numeric ID
   - **HeidICON UUID**: Enter UUID (with hyphens)
   - **HeidICON System Object ID**: Enter system ID
6. Save the find

### Adding Images to Existing Find

To add HeidICON links to existing finds:

1. **Find the record**: Navigate to find detail page
2. **Click "Edit"**: Access edit form
3. **Scroll to HeidICON fields**
4. **Enter identifiers**:
   ```
   HeidICON ID: 12345
   HeidICON UUID: 550e8400-e29b-41d4-a716-446655440000
   HeidICON System Object ID: 987654
   ```
5. **Save changes**

### Bulk Updates

For updating many finds at once:

See [FileMaker Integration](./FileMaker-Integration.md) for CSV/XML import with HeidICON fields.

#### CSV Example
```csv
"id","tm","heidiconId","heidiconUuid","heidiconSystemObjectId"
9,70778,12345,"550e8400-e29b-41d4-a716-446655440000",987654
44,70787,12346,"550e8400-e29b-41d4-a716-446655440001",987655
```

Use the command:
```bash
php bin/console find:update heidicon_links.csv
```

## Finding HeidICON Identifiers

### From HeidICON Website

1. **Navigate to HeidICON**: https://heidicon.ub.uni-heidelberg.de/
2. **Search for your images**: Use find number, excavation, etc.
3. **Open image detail page**
4. **Copy identifiers** from:
   - URL bar
   - Image metadata
   - Citation information

### From Image URL

HeidICON URLs typically contain identifiers:

**Example URL**:
```
https://heidicon.ub.uni-heidelberg.de/detail/12345
                                              ^^^^^
                                          HeidICON ID
```

### From Metadata Export

If images were batch uploaded:
1. Download HeidICON metadata export
2. Extract ID, UUID, and System Object ID columns
3. Match to your find records
4. Bulk import using CSV method

### From Image Filename

Sometimes identifiers are included in filenames:
```
BE23-045_12345.jpg
         ^^^^^
     HeidICON ID
```

Check your image naming conventions.

## Viewing Images

### From Find Detail Page

Once identifiers are linked:

1. Navigate to find detail page
2. Look for **HeidICON section**
3. Click on identifier links (if clickable)
4. Opens HeidICON page in new tab

### External Links

Images can be viewed at:
- Direct URL: `https://heidicon.ub.uni-heidelberg.de/detail/{ID}`
- IIIF viewer: If HeidICON provides IIIF endpoints
- Download: High-resolution images if permissions allow

### Image Display in Database

The Berenike database:
- **Does NOT** display images inline
- **Stores ONLY** identifiers (links)
- **Links TO** HeidICON for viewing
- **Shows** HeidICON identifiers on find pages

To see the actual image, you must visit HeidICON.

## Best Practices

### 1. Upload Images to HeidICON First

**Workflow**:
1. ✅ Take photographs of finds
2. ✅ Upload images to HeidICON
3. ✅ Record HeidICON identifiers
4. ✅ Link identifiers in Berenike database

### 2. Use Consistent Image Naming

Before uploading to HeidICON:
- Include find/inventory number in filename
- Example: `BE23-045_view01.jpg`
- Makes matching easier later

### 3. Add Metadata in HeidICON

In HeidICON, include:
- Find number / Inventory number
- Excavation context (trench, locus)
- Object type
- Photographer name
- Date photographed
- Copyright information

### 4. Record All Three Identifiers

When available, record:
- HeidICON ID
- HeidICON UUID (most important)
- HeidICON System Object ID

This provides redundancy if systems change.

### 5. Batch Process Images

For efficiency:
- Upload multiple images at once to HeidICON
- Export identifier list from HeidICON
- Import identifiers in bulk to Berenike database
- Reduces manual data entry

### 6. Verify Links Work

After linking:
- Click links to verify they open correctly
- Check images display in HeidICON
- Update if HeidICON URLs change

### 7. Document Image Details in Remarks

In the find's remarks field, note:
- Number of images available
- View types (profile, section, detail)
- Special photography (microscopy, etc.)
- Drawing numbers if applicable

**Example**:
```
3 images in HeidICON: general view, profile, rim detail
Drawing BE23-045/1
```

## Troubleshooting

### Invalid UUID Format Error

**Problem**: Form shows validation error for UUID.

**Solution**:
- Check UUID format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
- Must include hyphens in correct positions
- Use lowercase or uppercase (both accepted)
- Verify all characters are hexadecimal (0-9, a-f)

**Correct**:
```
550e8400-e29b-41d4-a716-446655440000
```

**Incorrect**:
```
550e8400e29b41d4a716446655440000  (missing hyphens)
550e8400-e29b-41d4-a716            (too short)
```

### HeidICON ID Must Be Positive Integer

**Problem**: Form won't accept HeidICON ID.

**Solution**:
- Must be positive number: `12345` ✅
- Cannot be negative: `-12345` ❌
- Cannot be zero: `0` ❌
- Cannot be text: `ID-12345` ❌
- Cannot be decimal: `12345.5` ❌
- Can be empty/null ✅

### Link Doesn't Work

**Problem**: Clicking identifier doesn't open image.

**Solution**:
1. Check identifier is correct
2. Verify image exists in HeidICON
3. Try manual URL: `https://heidicon.ub.uni-heidelberg.de/detail/{ID}`
4. Check HeidICON is accessible
5. Update identifier if changed

### Image Not in HeidICON

**Problem**: Have photograph but no HeidICON record.

**Solution**:
1. Upload image to HeidICON first
2. Wait for processing (may take time)
3. Record identifier once available
4. Then link in Berenike database

### Multiple Images for One Find

**Problem**: Find has 5 photos but only one HeidICON ID field.

**Solution**:

**Option 1: Primary Image**
- Link the most important/representative image
- Note other images in remarks field

**Option 2: Image Collection in HeidICON**
- Create image collection/set in HeidICON
- Link to collection ID

**Option 3: Multiple Image Records**
- Use Image entity if available
- Link multiple images to find

**Option 4: Document in Remarks**
```
HeidICON images:
- General view: ID 12345
- Profile: ID 12346  
- Detail: ID 12347
- Microscopy: ID 12348
```

### Changed HeidICON Identifiers

**Problem**: HeidICON changed image IDs.

**Solution**:
1. Export list of new identifiers from HeidICON
2. Create CSV with old and new mappings
3. Use bulk update command
4. Verify links work

**CSV Example**:
```csv
"id","heidiconId","heidiconUuid"
9,99999,"new-uuid-here"
44,99998,"new-uuid-here"
```

## Validation Rules

### HeidICON ID
```php
- Type: integer
- Must be: >= 0 (positive or zero)
- Can be: null (empty)
- Cannot be: negative, text, decimal
```

### HeidICON UUID
```php
- Type: string (36 characters)
- Format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
- Characters: 0-9, a-f (hexadecimal)
- Case: insensitive
- Can be: null (empty)
- Cannot be: wrong format, too short, missing hyphens
```

### HeidICON System Object ID
```php
- Type: integer  
- Must be: >= 0 (positive or zero)
- Can be: null (empty)
- Cannot be: negative, text, decimal
```

## Advanced Topics

### IIIF Integration

If HeidICON provides IIIF endpoints:
- IIIF = International Image Interoperability Framework
- Allows advanced image viewing
- Can zoom, rotate, compare images
- Check HeidICON documentation for IIIF URLs

### API Access

HeidICON may provide API access:
- Programmatic image retrieval
- Batch metadata export
- Automatic synchronization
- Contact HeidICON administrators for API documentation

### Future Enhancements

Potential improvements:
- Inline image preview in database
- Automated identifier lookup
- Multiple images per find
- Image gallery view
- IIIF viewer integration

## Related Topics

- [Adding New Records](./Adding-New-Records.md) - Create finds with images
- [FileMaker Integration](./FileMaker-Integration.md) - Bulk import HeidICON IDs
- [Viewing Finds](./Viewing-Finds.md) - See images on find pages
- [User Guide Home](./User-Guide.md) - Return to main guide

## External Resources

- **HeidICON Website**: https://heidicon.ub.uni-heidelberg.de/
- **UUID Standard**: https://en.wikipedia.org/wiki/Universally_unique_identifier
- **IIIF Standard**: https://iiif.io/

---

**Last Updated**: December 2025  
**Required Permission**: ROLE_EDITOR or ROLE_ADMIN (for editing)
