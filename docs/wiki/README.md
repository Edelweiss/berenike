# Berenike Database Wiki Documentation

This directory contains comprehensive user guide documentation for the Berenike Archaeological Resources Database.

## Documentation Files

### Main User Guide
- **[User-Guide.md](./User-Guide.md)** - Landing page with overview and table of contents

### Topic Guides

1. **[User-Management.md](./User-Management.md)** - Creating and managing user accounts (ROLE_ADMIN)
   - Creating users
   - Editing user accounts
   - Password management
   - Role assignment
   - User permissions

2. **[Adding-New-Records.md](./Adding-New-Records.md)** - Creating trenches, loci, buckets, and finds (ROLE_EDITOR)
   - Data hierarchy explanation
   - Step-by-step creation guides
   - Best practices
   - Common workflows

3. **[HeidICON-Integration.md](./HeidICON-Integration.md)** - Linking images to finds
   - Understanding HeidICON identifiers
   - Image linking process
   - Validation rules
   - Troubleshooting

4. **[Viewing-Finds.md](./Viewing-Finds.md)** - Browsing and searching the database (ROLE_USER)
   - Browse lists
   - Search and filter
   - View details
   - Navigate relationships

5. **[FileMaker-Integration.md](./FileMaker-Integration.md)** - Bulk data import from FileMaker (ROLE_EDITOR)
   - CSV and XML imports
   - Field mappings
   - Update modes (replace/append)
   - Command reference

6. **[Admin-Dashboard.md](./Admin-Dashboard.md)** - Using the dashboard
   - Dashboard overview
   - Quick links
   - Role-based features
   - Navigation tips

## Quick Reference

### User Roles

- **ROLE_USER**: View-only access
- **ROLE_EDITOR**: Create and edit records
- **ROLE_ADMIN**: Full administrative access

### Common URLs

- Dashboard: `/dashboard`
- Find List: `/find/list`
- User Management: `/user/list` (admin only)
- New Find: `/admin/find/new` (editor/admin)

### Key Commands

```bash
# Import finds from CSV
php bin/console find:update filename.csv

# Test import without changes
php bin/console find:update filename.csv --dry-run

# Import with batch processing
php bin/console find:update filename.csv --batch-size=50
```

## Usage

### For GitHub Wiki

These markdown files are designed to be used as GitHub Wiki pages:

1. Copy content to GitHub Wiki pages
2. Use the same filenames (without .md extension)
3. Cross-references will work automatically

### For Local Documentation

Files can also be:
- Viewed in any markdown viewer
- Converted to HTML/PDF
- Printed for reference
- Integrated into other documentation systems

## Documentation Standards

### Formatting

- **Headers**: Use H1 for title, H2 for main sections, H3+ for subsections
- **Code blocks**: Use fenced code blocks with language hints
- **Links**: Use relative links between pages
- **Icons**: Unicode emojis for visual interest
- **Examples**: Include practical examples throughout

### Structure

Each guide includes:
- Table of Contents
- Overview section
- Step-by-step instructions
- Examples
- Troubleshooting section
- Related topics links
- Last updated date
- Required permissions

## Maintenance

### Updating Documentation

When updating the application:
1. Review affected documentation pages
2. Update procedures and screenshots
3. Add new features to relevant guides
4. Update "Last Updated" date
5. Test all links and examples

### Version Control

- Store in `/docs/wiki/` directory
- Track changes in Git
- Tag releases with documentation versions
- Maintain changelog for major updates

## Contributing

To improve documentation:
1. Identify unclear or missing information
2. Draft improvements
3. Review with team
4. Update files
5. Commit with clear message

## Contact

For questions about documentation:
- Open GitHub issue with "documentation" label
- Contact system administrator
- Discuss in team meetings

---

**Directory**: `/docs/wiki/`  
**Created**: December 2025  
**Maintained by**: Berenike Project Team
