# Berenike Database Wiki - Quick Index

Quick reference index for the Berenike Archaeological Resources Database documentation.

## Documentation Pages

| Page | Topics Covered | Required Role |
|------|---------------|---------------|
| [User Guide](./User-Guide.md) | Main landing page, overview, getting started | All users |
| [User Management](./User-Management.md) | Creating users, roles, permissions, passwords | ROLE_ADMIN |
| [Adding New Records](./Adding-New-Records.md) | Creating trenches, loci, buckets, finds | ROLE_EDITOR |
| [HeidICON Integration](./HeidICON-Integration.md) | Linking images, identifiers, validation | ROLE_EDITOR |
| [Viewing Finds](./Viewing-Finds.md) | Browsing, searching, filtering, viewing | ROLE_USER |
| [FileMaker Integration](./FileMaker-Integration.md) | CSV/XML import, bulk updates, field mapping | ROLE_EDITOR |
| [Admin Dashboard](./Admin-Dashboard.md) | Dashboard features, navigation, tiles | All users |

## By User Role

### For Viewers (ROLE_USER)

Start here:
1. [User Guide](./User-Guide.md) - Overview
2. [Viewing Finds](./Viewing-Finds.md) - Browse and search
3. [Admin Dashboard](./Admin-Dashboard.md) - Navigation

### For Editors (ROLE_EDITOR)

Essential reading:
1. [User Guide](./User-Guide.md) - Overview
2. [Adding New Records](./Adding-New-Records.md) - Create data
3. [HeidICON Integration](./HeidICON-Integration.md) - Link images
4. [FileMaker Integration](./FileMaker-Integration.md) - Bulk import
5. [Viewing Finds](./Viewing-Finds.md) - Verify your work

### For Administrators (ROLE_ADMIN)

Complete documentation:
1. [User Guide](./User-Guide.md) - Overview
2. [User Management](./User-Management.md) - Manage accounts
3. All editor documentation (above)
4. [Admin Dashboard](./Admin-Dashboard.md) - Admin features

## By Task

### Account Management
- [Create user account](./User-Management.md#creating-a-new-user)
- [Edit user roles](./User-Management.md#editing-a-user)
- [Reset password](./User-Management.md#password-management)
- [Deactivate account](./User-Management.md#deactivating-a-user-account)

### Data Entry
- [Create trench](./Adding-New-Records.md#adding-a-new-trench-excavation)
- [Create locus](./Adding-New-Records.md#adding-a-new-locus)
- [Create bucket](./Adding-New-Records.md#adding-a-new-bucket)
- [Create find](./Adding-New-Records.md#adding-a-new-find)

### Image Management
- [Link HeidICON image](./HeidICON-Integration.md#linking-images-to-finds)
- [Find HeidICON identifiers](./HeidICON-Integration.md#finding-heidicon-identifiers)
- [Validate UUID format](./HeidICON-Integration.md#understanding-heidicon-identifiers)

### Data Import
- [Import CSV file](./FileMaker-Integration.md#import-process)
- [Import FileMaker XML](./FileMaker-Integration.md#supported-file-formats)
- [Field mapping reference](./FileMaker-Integration.md#field-mappings)
- [Append vs replace data](./FileMaker-Integration.md#update-modes)

### Searching
- [Basic search](./Viewing-Finds.md#searching-finds)
- [Filter results](./Viewing-Finds.md#searchable-fields)
- [Browse lists](./Viewing-Finds.md#browsing-finds)
- [View details](./Viewing-Finds.md#viewing-find-details)

## Common Commands

### Find Import Command

```bash
# Basic import
php bin/console find:update filename.csv

# Test without saving
php bin/console find:update filename.csv --dry-run

# Large batch processing
php bin/console find:update filename.csv --batch-size=100

# Clear empty fields
php bin/console find:update filename.csv --set-empty-to-null
```

## Common URLs

### Public Pages
- Home: `/`
- Login: `/login`
- Dashboard: `/dashboard`

### Browse Lists
- All Finds: `/find/list`
- All Buckets: `/bucket/list`
- All Loci: `/locus/list`
- All Trenches: `/excavation/list`

### View Details
- Find: `/find/show/{id}`
- Bucket: `/bucket/show/{id}`
- Locus: `/locus/show/{id}`
- Trench: `/excavation/show/{id}`

### Create New (Editor/Admin)
- New Find: `/admin/find/new`
- New Bucket: `/admin/bucket/new`
- New Locus: `/admin/locus/new`
- New Trench: `/admin/trench/new`

### User Management (Admin Only)
- User List: `/user/list`
- New User: `/user/new`
- Edit User: `/user/edit/{id}`
- View User: `/user/show/{id}`

### Profile
- Edit Profile: `/user/profile`
- Change Password: `/user/password`

## Quick Reference Tables

### User Roles

| Role | Can View | Can Create | Can Edit | Can Delete | Can Manage Users |
|------|----------|------------|----------|------------|------------------|
| ROLE_USER | ✅ | ❌ | ❌ | ❌ | ❌ |
| ROLE_EDITOR | ✅ | ✅ | ✅ | ❌ | ❌ |
| ROLE_ADMIN | ✅ | ✅ | ✅ | ✅ | ✅ |

### Data Hierarchy

```
Excavation (Trench)
  └── Locus
      └── Bucket
          └── Find
```

### HeidICON Identifiers

| Type | Format | Example |
|------|--------|---------|
| ID | Integer | `12345` |
| UUID | 36-char UUID | `550e8400-e29b-41d4-a716-446655440000` |
| System Object ID | Integer | `987654` |

### Find Command Options

| Option | Purpose | Example |
|--------|---------|---------|
| `--dry-run` | Test without saving | `--dry-run` |
| `--batch-size=N` | Records per batch | `--batch-size=50` |
| `--set-empty-to-null` | Clear empty fields | `--set-empty-to-null` |

### CSV Append Mode

| Column Name | Mode | Behavior |
|-------------|------|----------|
| `publications` | Replace | Overwrites existing value |
| `publications+` | Append | Adds to existing value with `;` separator |

## External Resources

- **HeidICON**: https://heidicon.ub.uni-heidelberg.de/
- **GitHub Repository**: https://github.com/Edelweiss/berenike
- **GitHub Wiki**: https://github.com/Edelweiss/berenike/wiki
- **Berenike PCMA**: https://berenike.pcma.uw.edu.pl/

## Support

### Getting Help

1. Check relevant documentation page
2. Search for your topic in this index
3. Contact system administrator
4. Report bugs via GitHub Issues (admin)

### Documentation Feedback

To suggest improvements:
- Note unclear sections
- Identify missing topics
- Report broken links
- Share with administrators

---

**Last Updated**: December 2025  
**Total Pages**: 7  
**Format**: GitHub-flavored Markdown
