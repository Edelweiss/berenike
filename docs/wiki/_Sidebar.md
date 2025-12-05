## Berenike Database Wiki

### Getting Started
- [**User Guide Home**](User-Guide)
- [Quick Index](INDEX)

### Core Topics

#### 1. User Management
- [User Management Guide](User-Management)
  - Creating Users
  - Editing Accounts
  - Roles & Permissions
  - Password Management

#### 2. Working with Data
- [Adding New Records](Adding-New-Records)
  - Creating Trenches
  - Adding Loci
  - Creating Buckets
  - Adding Finds
  
- [Viewing & Searching Finds](Viewing-Finds)
  - Browse Lists
  - Search & Filter
  - View Details
  - Navigate Relationships

#### 3. Images
- [HeidICON Integration](HeidICON-Integration)
  - Understanding Identifiers
  - Linking Images
  - Validation Rules
  - Troubleshooting

#### 4. Bulk Operations
- [FileMaker Data Integration](FileMaker-Integration)
  - CSV Import
  - XML Import
  - Field Mappings
  - Update Modes
  - Command Reference

#### 5. Dashboard
- [Admin Dashboard Guide](Admin-Dashboard)
  - Dashboard Overview
  - Quick Links
  - Role-Based Features
  - Navigation Tips

### Quick Reference

#### By Role
- **Viewers** (ROLE_USER)
  - [Viewing Finds](Viewing-Finds)
  - [Admin Dashboard](Admin-Dashboard)

- **Editors** (ROLE_EDITOR)
  - [Adding New Records](Adding-New-Records)
  - [HeidICON Integration](HeidICON-Integration)
  - [FileMaker Integration](FileMaker-Integration)

- **Administrators** (ROLE_ADMIN)
  - [User Management](User-Management)
  - All Editor Features

#### Common Tasks
- [Create User](User-Management#creating-a-new-user)
- [Create Find](Adding-New-Records#adding-a-new-find)
- [Link Image](HeidICON-Integration#linking-images-to-finds)
- [Import CSV](FileMaker-Integration#import-process)
- [Search Finds](Viewing-Finds#searching-finds)

#### Commands
```bash
# Import finds
php bin/console find:update file.csv

# Test import
php bin/console find:update file.csv --dry-run
```

#### URLs
- Dashboard: `/dashboard`
- All Finds: `/find/list`
- User Management: `/user/list`
- New Find: `/admin/find/new`

### Resources
- [GitHub Repository](https://github.com/Edelweiss/berenike)
- [HeidICON](https://heidicon.ub.uni-heidelberg.de/)
- [Berenike PCMA](https://berenike.pcma.uw.edu.pl/)
