# Viewing and Searching Finds

This guide explains how to browse, search, filter, and view archaeological finds in the Berenike database.

**Required Permission**: `ROLE_USER` (all users)

## Table of Contents

- [Overview](#overview)
- [Browsing Finds](#browsing-finds)
- [Searching Finds](#searching-finds)
- [Viewing Find Details](#viewing-find-details)
- [Understanding Find Relationships](#understanding-find-relationships)
- [Browsing Related Records](#browsing-related-records)
- [Export Options](#export-options)
- [Tips and Tricks](#tips-and-tricks)

## Overview

The Berenike database provides multiple ways to access and explore archaeological find data:

- 📋 **Browse Lists**: View all finds in paginated tables
- 🔍 **Search**: Find specific records by various criteria
- 🔗 **Navigate Relationships**: Follow links between trenches, loci, buckets, and finds
- 📊 **Filter**: Narrow results by material, date, etc.
- 📄 **Detail Views**: See complete information for individual finds

## Browsing Finds

### Accessing the Find List

1. Log in to the Berenike database
2. Click **"All Finds"** from the navigation menu or Dashboard
   
   *Or navigate directly to `/find/list`*

### Find List Interface

The find list displays finds in a **data grid** with:

#### Visible Columns

- **ID**: Internal database identifier
- **TM**: Trismegistos number (if assigned)
- **Inventory Number**: Find reference number
- **Object**: What the artifact is
- **Material**: Primary material type
- **Trench**: Excavation area
- **Date**: Find or excavation date
- **Actions**: View, Edit (if permitted), Delete (if permitted)

#### Grid Features

- **Pagination**: Navigate through multiple pages of results
- **Sorting**: Click column headers to sort ascending/descending
- **Rows per page**: Choose how many records to display (10, 25, 50, 100)
- **Page numbers**: Jump to specific page
- **Total count**: Shows total number of finds

### Sorting the List

Click any **column header** to sort:

1. **First Click**: Sort ascending (A→Z, 0→9)
2. **Second Click**: Sort descending (Z→A, 9→0)
3. **Third Click**: Remove sorting

**Examples**:
- Sort by **TM** to see finds numerically
- Sort by **Date** to see chronological order
- Sort by **Material** to group by material type
- Sort by **Inventory Number** for reference order

### Pagination Controls

At the bottom of the grid:

- **Previous/Next**: Navigate one page at a time
- **Page Numbers**: Click to jump to specific page
- **Rows Dropdown**: Select 10, 25, 50, or 100 rows per page
- **Total Records**: Shows "Showing 1-25 of 1,234 records"

## Searching Finds

### Basic Search

Use the **search toolbar** at the top of the find list:

1. Click **"Search"** or toggle search panel
2. Enter search criteria in one or more fields
3. Click **"Search"** button
4. Results update to match your criteria
5. Click **"Clear"** to reset search

### Searchable Fields

You can search by:

- **TM Number**: Exact or partial match
  - Example: `70778` or `707*`
  
- **Inventory Number**: Exact or partial match
  - Example: `BE23-045` or `19002`
  
- **Object**: Text search in object description
  - Example: `amphora` or `coin`
  
- **Material**: Filter by material type
  - Examples: `pottery`, `bronze`, `glass`, `textile`
  
- **Trench**: Filter by excavation area
  - Example: `BE23-01` or `Trench A`
  
- **Locus**: Filter by locus number
  - Example: `023` or `L-045`
  
- **Bucket**: Filter by bucket number
  - Example: `B-045`
  
- **Date Range**: Filter by date
  - Start date: `2023-01-01`
  - End date: `2023-12-31`
  
- **Category**: Functional category
  - Examples: `vessel`, `tool`, `ornament`
  
- **Preservation**: Condition
  - Examples: `complete`, `fragmentary`, `worn`

### Search Operators

#### Wildcard Search

Use `*` (asterisk) for partial matches:
- `pot*` finds: pottery, potsherd, pot
- `*coin` finds: coin, bronze coin, gold coin
- `*amp*` finds: amphora, lamp, stamp

#### Exact Match

Enclose in quotes for exact phrase:
- `"transport amphora"` finds only that exact phrase
- `transport amphora` (without quotes) finds both words anywhere

#### Multiple Criteria

Combine multiple search fields:
- **Material**: `pottery`
- **Trench**: `BE23-01`
- **Date**: `2023-06-15`

Results match **ALL** criteria (AND logic).

### Advanced Search Tips

#### Find All Objects of a Type
```
Object: amphora
Material: pottery
→ Lists all pottery amphora finds
```

#### Find Recent Excavations
```
Date From: 2023-01-01
Date To: 2023-12-31
→ Lists all 2023 finds
```

#### Find Specific Context
```
Trench: BE23-01
Locus: 023
→ Lists all finds from that specific locus
```

#### Find Catalog Numbers
```
TM: 70778
→ Finds the exact TM record
```

#### Find Incomplete Records
This requires more advanced queries, but you can:
- Search for empty fields (if supported)
- Export data and filter externally

## Viewing Find Details

### Opening a Find Record

From the find list:
1. **Click on the ID number** or **Object name**
2. Opens the **find detail page**

   *Or navigate directly to `/find/show/{id}`*

### Find Detail Page Layout

The find detail page displays complete information organized in sections:

#### Header Section
- **Find ID**: Database identifier
- **Inventory Number**: Reference number
- **TM Number**: Trismegistos identifier (if applicable)
- **Action Buttons**: Edit, Delete (if permitted)

#### Context Section
- **Excavation/Trench**: Link to trench record
- **Locus**: Link to locus record (via bucket)
- **Bucket**: Link to bucket record
- **Date**: Find or excavation date
- **Year/Month**: Temporal information

#### Identification Section
- **Object**: What it is
- **Object Type**: Specific type
- **Category**: Functional category
- **Material**: Primary material
- **TM**: Trismegistos number

#### Physical Description
- **Dimensions**: Measurements
- **Weight**: Mass
- **Quantity**: Number of pieces
- **Preservation**: Condition
- **Description**: Detailed description

#### Classification
- **Dating Absolute**: Chronological date
- **Typology Reference**: Published type citations
- **Category Number**: Classification number

#### Documentation
- **Publications**: Bibliography
- **Remarks**: Additional notes
- **Special Publication Notes**: Publication-specific info

#### Administrative
- **SCA Register**: Egyptian antiquities register
- **Storage Location**: Where stored
- **Current Location**: Current position

#### Images (HeidICON)
- **HeidICON ID**: Image identifier (clickable link)
- **HeidICON UUID**: Universal identifier
- **HeidICON System Object ID**: System reference

#### Specialists
- List of associated specialists (if any)
- Links to specialist records

#### Metadata
- **Created**: Record creation timestamp
- **Modified**: Last modification timestamp
- **Created By**: User who created (if tracked)
- **Modified By**: User who last edited (if tracked)

### Navigating from Find Details

From a find detail page, you can:

- **Click Bucket link**: View the bucket containing this find
- **Click Locus link**: View the locus (via bucket relationship)
- **Click Trench link**: View the excavation area (via locus relationship)
- **Click HeidICON links**: View images in HeidICON
- **Click Edit**: Modify the find (if permitted)
- **Click Back**: Return to find list

## Understanding Find Relationships

### Hierarchical Structure

Each find exists within a hierarchy:

```
🏗️ EXCAVATION (Trench)
    └── 📍 LOCUS
        └── 🪣 BUCKET
            └── 🏺 FIND ← You are here
```

### Viewing the Full Context

To understand a find's complete context:

1. **Start at Find Detail Page**
2. **Click Bucket**: See all finds from this bucket
3. **From Bucket, click Locus**: See all buckets from this locus
4. **From Locus, click Trench**: See all loci in this trench

This reveals:
- Other finds from the same context
- Stratigraphic relationships
- Excavation details
- Temporal information

### Example Navigation Path

**Find BE23-045 (Amphora sherd)**
↓ Click "Bucket B-045"
**Bucket B-045** (Contains 23 finds)
↓ Click "Locus 023"
**Locus 023** (Occupation layer, contains 5 buckets)
↓ Click "Trench BE23-01"
**Trench BE23-01** (Eastern sector, contains 47 loci)

## Browsing Related Records

### Browsing Buckets

1. Navigate to **"All Buckets"** (`/bucket/list`)
2. View list of all buckets
3. Sort by locus, date, number
4. Click bucket to see:
   - All finds in that bucket
   - Locus information
   - Collection details

### Browsing Loci

1. Navigate to **"All Loci"** (`/locus/list`)
2. View list of all loci
3. Sort by trench, number, type
4. Click locus to see:
   - All buckets from that locus
   - Excavation context
   - Stratigraphic information

### Browsing Trenches

1. Navigate to **"All Trenches"** (`/excavation/list`)
2. View list of all excavations/trenches
3. Sort by name, year, director
4. Click trench to see:
   - All loci in that trench
   - Excavation metadata
   - Temporal scope

### Cross-Reference Navigation

From any detail page:
- **Breadcrumb trail**: Shows navigation path
- **Related records**: Listed with links
- **Back button**: Return to previous view
- **Home/Dashboard**: Reset to starting point

## Export Options

### Current View

Some views may offer export options:

- **CSV**: Spreadsheet format
- **Excel**: Microsoft Excel format
- **PDF**: Printable document
- **XML**: Structured data format

### Export Process

1. **Apply filters**: Set up the view you want to export
2. **Click Export button**: Usually at top or bottom of list
3. **Choose format**: CSV, Excel, PDF, XML
4. **Download file**: Save to your computer

### What Gets Exported

Exports typically include:
- All visible columns
- Current filter/search criteria
- Current sort order
- All pages (not just current page)

### Export Limitations

- May not include all fields (only visible columns)
- Image links exported, not actual images
- Relationships may be represented as IDs
- Large exports may take time to generate

## Tips and Tricks

### Quick Find by ID

If you know the find ID:
- Navigate directly to `/find/show/{id}`
- Example: `/find/show/45` for find #45

### Bookmark Searches

Save useful searches:
1. Perform search with desired criteria
2. Bookmark the resulting URL
3. Return anytime by opening bookmark

### Compare Related Finds

To compare finds from same context:
1. Navigate to bucket or locus
2. Open multiple finds in new browser tabs
3. Switch between tabs to compare

### Use Browser Search

For quick text search on current page:
- **Mac**: `Cmd + F`
- **Windows/Linux**: `Ctrl + F`
- Finds text in currently visible data

### Print Find Details

To print a find record:
1. Navigate to find detail page
2. Use browser print function:
   - **Mac**: `Cmd + P`
   - **Windows/Linux**: `Ctrl + P`
3. Choose printer or "Save as PDF"

### Copy Find Information

To copy find data:
1. Select text on find detail page
2. **Mac**: `Cmd + C`
3. **Windows/Linux**: `Ctrl + C`
4. Paste into your document

### Mobile Access

The database should work on mobile devices:
- Use browser on phone/tablet
- Interface may be responsive
- Some features may be limited
- Best experience on desktop

### Keyboard Navigation

Speed up navigation:
- **Tab**: Move forward through links
- **Shift + Tab**: Move backward
- **Enter**: Follow link/submit form
- **Spacebar**: Scroll page down
- **Backspace**: Go back (some browsers)

## Common Questions

### How many finds are in the database?

Check the total count:
- Go to find list
- Look at bottom: "Showing 1-25 of 1,234 records"
- The last number is the total count

### Can I see deleted finds?

No, deleted finds are removed permanently:
- No "recycle bin" or trash
- Only users with delete permissions can remove finds
- Deletions should be rare and deliberate

### Why can't I see some fields?

Field visibility may depend on:
- Your user role/permissions
- Whether data exists in that field
- Display template configuration
- Mobile vs. desktop view

### How do I know when a find was added?

Check the find detail page:
- **Created**: Shows when record was first created
- **Modified**: Shows when last updated
- Timestamps include date and time

### Can I see who edited a find?

This depends on configuration:
- Some systems track user attribution
- Check "Created By" or "Modified By" fields
- May not be visible to all users
- Ask administrator if tracking is enabled

### How current is the data?

Data currency depends on:
- When excavation data was entered
- Frequency of updates
- Data import schedules
- Check "Modified" date on records

## Related Topics

- [Adding New Records](./Adding-New-Records.md) - Create new finds
- [FileMaker Integration](./FileMaker-Integration.md) - Bulk data import
- [HeidICON Integration](./HeidICON-Integration.md) - View images
- [Admin Dashboard](./Admin-Dashboard.md) - Quick navigation
- [User Guide Home](./User-Guide.md) - Return to main guide

---

**Last Updated**: December 2025  
**Required Permission**: ROLE_USER (all users can view)
