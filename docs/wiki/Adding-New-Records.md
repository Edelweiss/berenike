# Adding New Records

This guide covers how to create new trenches, loci, buckets, and finds in the Berenike database system.

**Required Permission**: `ROLE_EDITOR` or `ROLE_ADMIN`

## Table of Contents

- [Overview](#overview)
- [Understanding the Data Hierarchy](#understanding-the-data-hierarchy)
- [Adding a New Trench (Excavation)](#adding-a-new-trench-excavation)
- [Adding a New Locus](#adding-a-new-locus)
- [Adding a New Bucket](#adding-a-new-bucket)
- [Adding a New Find](#adding-a-new-find)
- [Workflow Best Practices](#workflow-best-practices)
- [Common Issues and Solutions](#common-issues-and-solutions)

## Overview

The Berenike database organizes archaeological data in a hierarchical structure. Before adding finds, you typically need to establish the context through trenches, loci, and buckets.

### Prerequisites

- Active account with `ROLE_EDITOR` or `ROLE_ADMIN` permissions
- Understanding of the excavation context
- Necessary information about the record you're creating

### Quick Access

Create new records from the **Dashboard** or navigate directly to:
- `/admin/trench/new` - New Trench
- `/admin/locus/new` - New Locus
- `/admin/bucket/new` - New Bucket
- `/admin/find/new` - New Find

## Understanding the Data Hierarchy

The Berenike database follows this organizational structure:

```
🏗️ EXCAVATION (Trench)
    ├── 📍 LOCUS (Archaeological context)
    │   ├── 🪣 BUCKET (Collection container)
    │   │   ├── 🏺 FIND (Individual artifact)
    │   │   ├── 🏺 FIND
    │   │   └── 🏺 FIND
    │   └── 🪣 BUCKET
    │       └── 🏺 FIND
    └── 📍 LOCUS
        └── 🪣 BUCKET
            └── 🏺 FIND
```

### Relationships

- **One Excavation** can have **many Loci**
- **One Locus** can have **many Buckets**
- **One Bucket** can have **many Finds**
- **Each Find** belongs to **one Bucket**

### Typical Workflow Order

1. ✅ Create **Excavation/Trench** (if new excavation area)
2. ✅ Create **Locus** (for each archaeological context)
3. ✅ Create **Bucket** (for each collection from a locus)
4. ✅ Create **Find** (for each individual artifact)

## Adding a New Trench (Excavation)

### When to Create a New Trench

Create a new trench when:
- Starting excavation in a new area
- Opening a new excavation unit
- Expanding to a new sector

### Step-by-Step Process

1. **Navigate to Admin Dashboard**
   - Click **Dashboard** from the menu
   - In the "Edit Actions" tile, click **"Create new Trench"**
   
   *Or navigate directly to `/admin/trench/new`*

2. **Fill in Trench Information**

   #### Required Fields
   
   - **Trench/Area Name**: Identifier for the excavation area
     - Example: `BE20-01`, `Trench A`, `BE-S21-Textiles`
     - Use consistent naming conventions
   
   #### Optional Fields
   
   - **Description**: Details about the trench
     - Location description
     - Size and dimensions
     - Excavation purpose
   
   - **Years**: Excavation years
     - Example: `2020-2021`, `2023`
   
   - **Director**: Person in charge
     - Example: `Dr. John Smith`
   
   - **Notes**: Additional information
     - Special conditions
     - References to reports
     - Related trenches

3. **Submit the Form**
   - Review all information
   - Click **"Create"** or **"Save"**

4. **Confirmation**
   - System redirects to the new trench's detail page
   - Trench is now available for linking to loci

### Example: Creating Trench BE23-01

```
Trench Name: BE23-01
Description: Eastern sector, textile workshop area
Years: 2023
Director: Dr. Jane Wilson
Notes: Focus on Late Roman period remains
```

## Adding a New Locus

A **locus** represents a specific archaeological context within a trench (e.g., a layer, feature, or architectural element).

### When to Create a New Locus

Create a new locus for:
- Each stratigraphic layer
- Architectural features (walls, floors)
- Pits, fills, or deposits
- Any distinct archaeological context

### Step-by-Step Process

1. **Navigate to New Locus Form**
   - Dashboard → **"Create new Locus"**
   - Or navigate to `/admin/locus/new`

2. **Fill in Locus Information**

   #### Required Fields
   
   - **Excavation/Trench**: Select from dropdown
     - Choose the trench this locus belongs to
     - Must create trench first if not available
   
   - **Locus Number**: Unique identifier within the trench
     - Example: `001`, `023`, `L-045`
     - Follow your excavation's numbering system
   
   #### Optional Fields
   
   - **Description**: Nature of the locus
     - Example: `Sandy deposit with pottery sherds`
     - Example: `Stone floor surface`
     - Example: `Fill of pit feature`
   
   - **Type**: Category of locus
     - Examples: `layer`, `floor`, `wall`, `pit`, `fill`
   
   - **Date/Period**: Chronological information
     - Example: `Late Roman`, `1st century CE`
   
   - **Level**: Depth or elevation
     - Example: `3.45m below datum`
   
   - **Dimensions**: Size measurements
     - Example: `2m x 3m, 15cm thick`
   
   - **Soil Description**: Soil characteristics
     - Example: `Light brown sandy loam with gravel`
   
   - **Notes**: Additional observations
     - Relationships to other loci
     - Special findings
     - References to drawings/photos

3. **Submit the Form**
   - Review all information
   - Click **"Create"** or **"Save"**

4. **Confirmation**
   - Redirected to locus detail page
   - Locus is now available for linking to buckets

### Example: Creating Locus 023

```
Excavation: BE23-01
Locus Number: 023
Description: Occupation layer with pottery and bone
Type: layer
Period: Late Roman (4th-5th century CE)
Level: 2.85-3.15m below datum
Dimensions: 2.5m x 2.0m, 30cm thick
Soil: Dark brown silty loam with ash inclusions
Notes: Overlies L-022 floor surface, cut by L-024 pit
```

## Adding a New Bucket

A **bucket** represents a collection container used to gather finds from a specific locus during excavation.

### When to Create a New Bucket

Create a new bucket for:
- Each physical bucket/bag used in excavation
- Different material types from same locus
- Different excavation days/sessions
- Bulk collections before sorting

### Step-by-Step Process

1. **Navigate to New Bucket Form**
   - Dashboard → **"Create new Bucket"**
   - Or navigate to `/admin/bucket/new`

2. **Fill in Bucket Information**

   #### Required Fields
   
   - **Locus**: Select from dropdown
     - Choose the locus this bucket is from
     - Must create locus first if not available
   
   - **Bucket Number**: Identifier
     - Example: `B-001`, `23-001`, `Bucket 45`
     - Use consistent numbering system
   
   #### Optional Fields
   
   - **Date**: Collection date
     - When the bucket was filled
     - Example: `2023-06-15`
   
   - **Description**: Contents description
     - Example: `Pottery sherds and bone fragments`
     - Example: `Textile fragments from northern corner`
   
   - **Material Type**: Primary material category
     - Examples: `pottery`, `bone`, `metal`, `textiles`, `glass`
   
   - **Processor**: Person who processed the bucket
     - Example: `J. Smith`
   
   - **Processing Date**: When sorted/analyzed
     - Example: `2023-07-10`
   
   - **Weight**: Total weight of contents
     - Example: `2.5 kg`
   
   - **Notes**: Additional information
     - Sorting notes
     - Special handling requirements
     - Conservation needs

3. **Submit the Form**
   - Review all information
   - Click **"Create"** or **"Save"**

4. **Confirmation**
   - Redirected to bucket detail page
   - Bucket is now available for linking to finds

### Example: Creating Bucket B-045

```
Locus: BE23-01 / L-023
Bucket Number: B-045
Date: 2023-06-15
Description: Mixed pottery sherds, predominantly body sherds
Material Type: pottery
Processor: J. Smith
Processing Date: 2023-07-10
Weight: 3.2 kg
Notes: Includes 2 rim sherds requiring drawing
```

## Adding a New Find

A **find** represents an individual archaeological artifact or object.

### When to Create a New Find

Create a find record for:
- Individual artifacts requiring documentation
- Special finds (complete vessels, tools, inscriptions)
- Objects for publication
- Items requiring photography
- Materials needing specialist analysis

### Step-by-Step Process

1. **Navigate to New Find Form**
   - Dashboard → **"Create new Find"**
   - Or navigate to `/admin/find/new`

2. **Fill in Find Information**

   The find form has many fields. Focus on the most important ones first.

   #### Essential Fields
   
   - **Bucket**: Select from dropdown
     - Links find to its collection context
   
   - **Inventory Number**: Unique identifier
     - Example: `BE23-001`, `19002`
     - Follow your numbering system
   
   - **Object**: What it is
     - Example: `Amphora body sherd`, `Bronze coin`, `Linen textile fragment`
   
   - **Material**: Primary material
     - Examples: `pottery`, `bronze`, `glass`, `textile`, `bone`, `stone`
   
   #### Context Fields
   
   - **Trench**: Auto-filled from bucket's locus
     - Can override if needed
   
   - **Date**: Find date (usually from bucket)
   
   - **Year/Month**: Temporal information
     - Automatically synced with date field
   
   #### Identification Fields
   
   - **TM (Trismegistos) Number**: Database identifier
     - For published finds
     - Example: `70778`
   
   - **Category**: Functional category
     - Examples: `vessel`, `tool`, `ornament`, `architectural`
   
   - **Object Type**: Specific type
     - Example: `cooking pot`, `strigil`, `bead`, `roof tile`
   
   #### Physical Description
   
   - **Dimensions**: Measurements
     - Example: `L: 5.2cm, W: 3.1cm, Th: 0.4cm`
     - Example: `Diam: 12cm`
   
   - **Weight**: Mass
     - Example: `45.3g`, `120g`
   
   - **Quantity**: Number of fragments/items
     - Example: `1` (complete), `3` (joining fragments)
   
   - **Preservation**: Condition
     - Examples: `complete`, `fragmentary`, `worn`, `excellent`
   
   - **Description**: Detailed description
     - Physical characteristics
     - Decoration
     - Manufacturing technique
     - Surface treatment
   
   #### Dating and Interpretation
   
   - **Dating Absolute**: Chronological date
     - Example: `1st century CE`, `50-100 CE`, `Late Roman`
   
   - **Typology Reference**: Published type references
     - Example: `Hayes Form 3B`, `Robinson Type M42`
   
   #### Documentation
   
   - **Publications**: Bibliography
     - List publications where find is mentioned
     - Example: `Smith 2020, p. 45, Fig. 12`
   
   - **Remarks**: Additional notes
     - Comparanda
     - Special observations
     - Conservation needs
   
   - **Special Publication Notes**: Publication-specific information
   
   #### HeidICON Integration
   
   - **HeidICON ID**: Image identifier
   - **HeidICON UUID**: Universal unique identifier
   - **HeidICON System Object ID**: System reference
   
   See [HeidICON Integration](./HeidICON-Integration.md) for details.
   
   #### Administrative Fields
   
   - **SCA Register**: Egyptian antiquities register number
   - **Storage Location**: Where the object is stored
   - **Current Location**: Current physical location
   
   #### Specialists
   
   - Link to specialist records if needed
   - Multiple specialists can be associated

3. **Submit the Form**
   - Review all information
   - Click **"Create"** or **"Save"**
   - System automatically sets:
     - `created` timestamp
     - `modified` timestamp

4. **Confirmation**
   - Redirected to find detail page
   - Find is now in the database
   - Can add images, edit, or continue adding finds

### Example: Creating Find BE23-045

```
Bucket: B-045 (Locus 023, Trench BE23-01)
Inventory Number: BE23-045
TM: 70778

Object: Body sherd of transport amphora
Material: pottery
Category: vessel
Object Type: amphora

Dimensions: L: 8.5cm, W: 6.2cm, Th: 1.1cm
Weight: 85g
Quantity: 1
Preservation: fragmentary

Description: Body sherd from a large transport amphora. 
Fabric is hard-fired, orange-pink (Munsell 5YR 7/6) with 
frequent small white and dark inclusions. External surface 
shows traces of white slip. Ridge on interior from wheel 
throwing visible.

Dating Absolute: 1st century CE
Typology Reference: Peacock & Williams Class 10

Publications: Preliminary report 2023

Remarks: Similar sherds found in L-022 below. Fabric 
suggests Egyptian manufacture.

HeidICON ID: 12345
```

## Workflow Best Practices

### 1. Plan Your Structure First

Before adding data:
- ✅ Review excavation records
- ✅ Understand the stratigraphic sequence
- ✅ Establish numbering conventions
- ✅ Check if trenches/loci already exist

### 2. Work Top-Down

Create records in hierarchical order:
1. **Trench** (if new)
2. **Locus** (if new)
3. **Bucket** (if new)
4. **Find**

### 3. Use Consistent Naming

- Establish conventions for your project
- Example trench format: `BE[Year]-[Number]`
- Example locus format: `L-[###]`
- Example bucket format: `B-[###]`
- Example find format: `BE[Year]-[###]`

### 4. Start with Essential Fields

Don't try to complete everything at once:
1. Create record with essential fields
2. Save the record
3. Return later to add details
4. Update as analysis progresses

### 5. Link Records Properly

Always link records to their parent:
- Loci to trenches
- Buckets to loci
- Finds to buckets

This maintains the data hierarchy and enables proper browsing.

### 6. Document As You Go

- Add notes about relationships between contexts
- Record excavation decisions
- Include references to drawings, photos, field notebooks
- Note conservation needs immediately

### 7. Bulk Import When Appropriate

For large numbers of finds:
- Consider using FileMaker import
- See [FileMaker Integration](./FileMaker-Integration.md)
- Saves time on repetitive data entry

## Common Issues and Solutions

### Issue: Can't Find Parent Record

**Problem**: Dropdown doesn't show the trench/locus/bucket you need.

**Solution**:
1. Check if parent record exists
2. Create parent record first
3. Refresh page to see new options
4. Use search function in dropdown

### Issue: Duplicate Numbers

**Problem**: Inventory number or locus number already exists.

**Solution**:
1. Check existing records
2. Use unique identifiers
3. Include year in numbering (e.g., `BE23-001`)
4. Follow established conventions

### Issue: Form Validation Error

**Problem**: Form won't submit, shows error message.

**Solution**:
1. Check required fields are filled
2. Verify data format (numbers in numeric fields)
3. Check for special characters in text fields
4. Ensure selections are made from dropdowns

### Issue: Lost Work After Browser Crash

**Problem**: Entered data lost due to browser closing.

**Solution**:
- Save frequently while entering data
- Use "Save and Continue Editing" if available
- Keep notes in external document
- Consider using bulk import for large datasets

### Issue: Can't Find Created Record

**Problem**: Record was created but can't be found.

**Solution**:
1. Check success message for ID number
2. Use search function with inventory number
3. Browse parent record's list (e.g., all finds in a bucket)
4. Check spelling of search terms

### Issue: Need to Change Parent Record

**Problem**: Find linked to wrong bucket/locus.

**Solution**:
1. Edit the find record
2. Change the bucket/locus selection
3. Save changes
4. System updates relationships automatically

## Tips for Efficient Data Entry

### Keyboard Shortcuts

- `Tab`: Move to next field
- `Shift + Tab`: Move to previous field
- `Enter`: Submit form (in some fields)

### Copy Previous Record

When entering similar records:
1. View previous record
2. Copy relevant information
3. Paste into new record form
4. Modify as needed

### Use Template Records

For repetitive finds:
1. Create a "template" find with common fields filled
2. Copy information to new records
3. Update specific details

### Prepare Data Offline

Before data entry:
- Create spreadsheet with all information
- Review and clean data
- Import in bulk if possible
- Or use as reference while entering manually

## Related Topics

- [Viewing and Searching Finds](./Viewing-Finds.md) - Find records after creation
- [FileMaker Integration](./FileMaker-Integration.md) - Bulk imports
- [HeidICON Integration](./HeidICON-Integration.md) - Adding images
- [Admin Dashboard](./Admin-Dashboard.md) - Quick access to creation forms
- [User Guide Home](./User-Guide.md) - Return to main guide

---

**Last Updated**: December 2025  
**Required Permission**: ROLE_EDITOR or ROLE_ADMIN
