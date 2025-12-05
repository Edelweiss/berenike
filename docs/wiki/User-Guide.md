# Berenike Database User Guide

Welcome to the Berenike Archaeological Resources Database user guide. This documentation will help you navigate and use the database system effectively for managing archaeological finds, buckets, loci, and excavation data from the Berenike site.

## Table of Contents

### Getting Started
- [**About the Berenike Database**](#about-the-berenike-database)
- [**System Requirements**](#system-requirements)
- [**Logging In**](#logging-in)
- [**User Roles and Permissions**](#user-roles-and-permissions)

### Core Topics

1. **[User Management](./User-Management.md)**
   - Creating and managing user accounts
   - User roles and permissions
   - Password management
   - Profile settings

2. **[Adding New Records](./Adding-New-Records.md)**
   - Creating new trenches/excavations
   - Adding loci
   - Creating buckets
   - Adding finds
   - Relationships between entities

3. **[Adding Images to HeidICON](./HeidICON-Integration.md)**
   - Understanding HeidICON integration
   - Image identifiers (ID, UUID, System Object ID)
   - Linking images to finds
   - Best practices for image management

4. **[Viewing and Searching Finds](./Viewing-Finds.md)**
   - Browse finds database
   - Search and filter options
   - Viewing find details
   - Understanding find relationships
   - Export options

5. **[FileMaker Data Integration](./FileMaker-Integration.md)**
   - Importing FileMaker data
   - Field mappings
   - Data synchronization
   - Bulk updates from CSV/XML

6. **[Admin Dashboard](./Admin-Dashboard.md)**
   - Dashboard overview
   - Quick actions
   - Statistics and reports
   - Administrative functions

## About the Berenike Database

The Berenike Archaeological Resources Database is a Symfony 5 web application designed to manage and organize archaeological data from the Berenike excavation site. The system provides a structured way to document and track:

- **Trenches/Excavations**: Physical areas where archaeological work is conducted
- **Loci**: Specific archaeological contexts within trenches
- **Buckets**: Containers used to collect finds from specific loci
- **Finds**: Individual archaeological artifacts and objects
- **Images**: Digital photographs linked to HeidICON repository
- **Users**: Team members with different access levels

### Key Features

- ✅ **Hierarchical Data Organization**: Trenches → Loci → Buckets → Finds
- ✅ **Role-Based Access Control**: Different permissions for viewers, editors, and administrators
- ✅ **HeidICON Integration**: Direct linking to image repository
- ✅ **FileMaker Import**: Bulk data import from legacy FileMaker databases
- ✅ **Advanced Search**: Powerful filtering and search capabilities
- ✅ **Data Validation**: Ensures data integrity and consistency
- ✅ **Audit Trail**: Track creation and modification dates

## System Requirements

### Browser Requirements
- Modern web browser (Chrome, Firefox, Safari, Edge)
- JavaScript enabled
- Cookies enabled for session management

### User Account
- Active user account with appropriate permissions
- Valid username and password
- Email address for notifications (optional)

## Logging In

1. Navigate to the Berenike database URL
2. Click on "Login" or navigate to `/login`
3. Enter your **username** and **password**
4. Click "Sign in"

If you've forgotten your password, contact your system administrator.

## User Roles and Permissions

The Berenike database uses three permission levels:

### 👤 ROLE_USER (Viewer)
Basic read-only access to the database:
- ✅ View finds, buckets, loci, and trenches
- ✅ Search and filter data
- ✅ View images and HeidICON links
- ❌ Cannot create or edit records
- ❌ Cannot delete records
- ❌ Cannot manage users

### ✏️ ROLE_EDITOR
All viewer permissions, plus:
- ✅ Create new finds, buckets, loci, and trenches
- ✅ Edit existing records
- ✅ Update images and metadata
- ✅ Import data from FileMaker
- ❌ Cannot delete records (except own)
- ❌ Cannot manage users

### 🔑 ROLE_ADMIN (Administrator)
Full system access:
- ✅ All editor permissions
- ✅ Delete any record
- ✅ Create and manage user accounts
- ✅ Assign user roles and permissions
- ✅ Access admin dashboard
- ✅ System configuration

## Quick Navigation

Once logged in, you can access different sections from:

- **Navigation Menu**: Main menu at the top of each page
- **Dashboard**: Central hub with quick links and featured finds (accessible from `/dashboard`)
- **Home Page**: Welcome page with overview and links
- **Breadcrumbs**: Navigation trail showing your current location

## Getting Help

If you need assistance:

1. **Check the relevant topic page** in this user guide
2. **Contact your system administrator** for account issues
3. **Report bugs** via the GitHub Issues page (administrators only)
4. **Consult the Wiki** for detailed technical documentation

## Next Steps

Choose a topic from the Table of Contents above to learn more about specific features and workflows.

### Recommended Reading Order

For new users, we recommend reading the topics in this order:

1. Start with **[Viewing and Searching Finds](./Viewing-Finds.md)** to understand how to navigate the data
2. Move to **[Adding New Records](./Adding-New-Records.md)** if you have editor permissions
3. Review **[FileMaker Data Integration](./FileMaker-Integration.md)** for bulk data operations
4. Explore **[HeidICON Integration](./HeidICON-Integration.md)** for image management
5. Consult **[User Management](./User-Management.md)** if you're an administrator

---

**Last Updated**: December 2025  
**Database Version**: Symfony 5  
**Maintained by**: Berenike Project Team
