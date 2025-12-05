# User Management

This guide covers managing user accounts in the Berenike database system. User management features are **only available to administrators** (ROLE_ADMIN).

## Table of Contents

- [Overview](#overview)
- [Viewing All Users](#viewing-all-users)
- [Creating a New User](#creating-a-new-user)
- [Editing a User](#editing-a-user)
- [Viewing User Details](#viewing-user-details)
- [Deleting a User](#deleting-a-user)
- [User Profile Management](#user-profile-management)
- [Password Management](#password-management)
- [User Roles and Permissions](#user-roles-and-permissions)

## Overview

User management allows administrators to:
- Create new user accounts
- Assign roles and permissions
- Activate/deactivate accounts
- Edit user information
- Monitor user activity
- Reset passwords

**Required Permission**: `ROLE_ADMIN`

## Viewing All Users

### Accessing the User List

1. Log in with administrator credentials
2. Navigate to the **Dashboard**
3. Click **"Manage Users"** in the Admin Actions tile

   *Or directly navigate to `/user/list`*

### User List Features

The user list page displays all users in a searchable grid with:

- **Username**: Login name
- **Email**: User's email address
- **Name**: Full name
- **Last Login**: Last login timestamp
- **Active Status**: Whether the account is active

### Searching Users

You can filter users by:
- Username (partial match)
- Email (partial match)
- Name (partial match)
- Active status (true/false)

### Sorting Users

Click column headers to sort by:
- Username (alphabetically)
- Email (alphabetically)
- Name (alphabetically)
- Last login date
- Active status

## Creating a New User

### Step-by-Step Process

1. Navigate to the user list page
2. Click **"Create new User"** button or go to `/user/new`
3. Fill in the required fields:

#### Required Fields

- **Username**: Unique login identifier
  - Must be unique across all users
  - Recommended format: lowercase, no spaces
  - Example: `jsmith`, `archaeologist.john`

- **Password**: Initial password
  - Must be strong and secure
  - User should change it on first login
  - System will hash the password automatically

- **Email**: Valid email address
  - Used for notifications (if enabled)
  - Example: `john.smith@university.edu`

- **Name**: User's full name
  - Display name shown in the system
  - Example: `John Smith`

#### Optional Fields

- **Roles**: User permissions (select one or more)
  - `ROLE_USER`: Basic viewer access (always included)
  - `ROLE_EDITOR`: Can create and edit records
  - `ROLE_ADMIN`: Full administrative access

- **Is Active**: Account status
  - ✅ Checked: User can log in
  - ❌ Unchecked: Account is disabled

4. Click **"Create"** to save the new user

### Default Settings

When creating a user:
- `ROLE_USER` is automatically assigned
- Account is set to **Active** by default
- Password is hashed using secure algorithm
- Creation timestamp is recorded

### Success Message

After successful creation:
```
User "John Smith" (jsmith) was created successfully!
```

You will be redirected to the user's detail page.

## Editing a User

### Step-by-Step Process

1. Navigate to the user list
2. Click on a user to view details
3. Click **"Edit"** button or navigate to `/user/edit/{id}`
4. Modify the fields as needed:
   - Username
   - Email
   - Name
   - Roles
   - Active status
   - Password (optional - leave blank to keep existing)

5. Click **"Save"** to update

### Important Notes

- **Password Field**: Leave blank to keep the existing password
- **Password Change**: Only provide a new password if you want to change it
- **Username Changes**: Be careful changing usernames as users may have saved credentials
- **Role Changes**: Take effect immediately on next page load

### Success Message

```
User "John Smith" was updated successfully!
```

## Viewing User Details

### User Detail Page

The user detail page shows:

- **ID**: Internal database identifier
- **Username**: Login name
- **Email**: Contact email
- **Name**: Full name
- **Roles**: Assigned permissions
- **Active**: Current account status
- **Last Login**: Most recent login date/time
- **Created**: Account creation date
- **Modified**: Last modification date

### Actions Available

From the user detail page, administrators can:
- **Edit**: Modify user information
- **Delete**: Remove user account (with confirmation)
- **Back to List**: Return to user list

## Deleting a User

### ⚠️ Warning

Deleting a user is **permanent** and cannot be undone. The user will:
- Lose access to the system immediately
- Be removed from all records
- Not be able to log in

### Step-by-Step Process

1. Navigate to the user's detail page
2. Click **"Delete"** button
3. Confirm the deletion (if prompted)

### Success Message

```
User "John Smith" (jsmith) was deleted successfully!
```

### Best Practices

Instead of deleting users, consider:
- **Deactivating** the account (set "Is Active" to false)
- **Removing elevated roles** (change from ROLE_ADMIN to ROLE_USER)
- **Keeping accounts** for audit trail purposes

## User Profile Management

### Self-Service Profile Editing

All users can edit their own profile information:

1. Navigate to **Profile** or `/user/profile`
2. Update the following fields:
   - Username
   - Email
3. Enter your **current password** to confirm changes
4. Click **"Save"**

### Profile Edit Requirements

- Must provide current password for security
- Cannot change own roles
- Cannot deactivate own account
- Email must be valid format

### Success/Error Messages

- **Success**: `Perfect` (profile updated)
- **Error - Wrong Password**: `Wrong password`
- **Error - Invalid Form**: `Invalid form`

## Password Management

### Changing Your Own Password

Users can change their own password:

1. Navigate to **Change Password** or `/user/password`
2. Enter your **current password**
3. Enter your **new password** (twice for confirmation)
4. Click **"Change Password"**

### Password Requirements

While not enforced at database level, follow these best practices:
- Minimum 8 characters
- Mix of uppercase and lowercase letters
- Include numbers
- Include special characters
- Don't reuse old passwords
- Don't share passwords

### Admin Password Reset

Administrators can reset any user's password:

1. Edit the user account
2. Enter a **new temporary password**
3. Save the changes
4. Inform the user of their temporary password
5. User should change it on next login

## User Roles and Permissions

### Role Hierarchy

The system uses three main roles:

#### 1. ROLE_USER (Default)
- View all records (finds, buckets, loci, trenches)
- Search and filter data
- View images and links
- **Cannot** create, edit, or delete

#### 2. ROLE_EDITOR
- All ROLE_USER permissions
- Create new records
- Edit existing records
- Upload/link images
- Import data
- **Cannot** delete records or manage users

#### 3. ROLE_ADMIN (Highest)
- All ROLE_EDITOR permissions
- Delete any record
- Manage all users
- Access admin dashboard
- View system logs (if enabled)
- Full database access

### Assigning Multiple Roles

Users can have multiple roles:
- `ROLE_USER` is always included automatically
- Select `ROLE_EDITOR` for editing permissions
- Select `ROLE_ADMIN` for administrative access

**Example**: A user with `ROLE_ADMIN` automatically has all lower role permissions.

### Role Changes Take Effect

- Immediately on next page load
- User may need to refresh browser
- No logout/login required

## Common Tasks

### Creating a Standard User Account

For a basic viewer account:
1. Username: `viewer.lastname`
2. Password: Generate secure password
3. Email: User's email
4. Name: Full name
5. Roles: `ROLE_USER` (default)
6. Is Active: ✅ Checked

### Creating an Editor Account

For someone who will add/edit data:
1. Username: `editor.lastname`
2. Password: Generate secure password
3. Email: User's email
4. Name: Full name
5. Roles: Select `ROLE_USER` + `ROLE_EDITOR`
6. Is Active: ✅ Checked

### Creating an Administrator Account

For full system access:
1. Username: `admin.lastname`
2. Password: Strong secure password
3. Email: User's email
4. Name: Full name
5. Roles: Select `ROLE_USER` + `ROLE_EDITOR` + `ROLE_ADMIN`
6. Is Active: ✅ Checked

### Deactivating a User Account

To temporarily disable access without deleting:
1. Edit the user
2. Uncheck **"Is Active"**
3. Save changes

The user will see a login error and cannot access the system.

### Reactivating a User Account

To restore access:
1. Edit the user
2. Check **"Is Active"**
3. Save changes

## Troubleshooting

### User Cannot Log In

Check:
1. ✅ Account is Active
2. ✅ Username is correct (case-sensitive)
3. ✅ Password is correct
4. ✅ User has at least ROLE_USER
5. ✅ Browser cookies/cache cleared

### User Cannot See Admin Features

Check:
1. ✅ User has `ROLE_ADMIN` assigned
2. ✅ Page has been refreshed
3. ✅ User logged out and back in

### User Cannot Edit Records

Check:
1. ✅ User has `ROLE_EDITOR` or `ROLE_ADMIN`
2. ✅ User is Active
3. ✅ Page has been refreshed

### Password Reset Not Working

For administrators:
1. Edit the user
2. Enter new password in password field
3. Save changes
4. Password is hashed automatically
5. Confirm with user

## Security Best Practices

### For Administrators

1. **Limit Admin Accounts**: Only grant ROLE_ADMIN to trusted users
2. **Regular Audits**: Review user list periodically
3. **Remove Unused Accounts**: Deactivate or delete inactive users
4. **Strong Passwords**: Enforce strong password policies
5. **Monitor Activity**: Check last login dates regularly

### For All Users

1. **Never Share Passwords**: Each user should have their own account
2. **Change Default Passwords**: Change temporary passwords immediately
3. **Log Out When Done**: Especially on shared computers
4. **Report Suspicious Activity**: Contact administrator immediately
5. **Keep Email Updated**: Ensure contact information is current

## Related Topics

- [Admin Dashboard](./Admin-Dashboard.md) - Overview of admin features
- [Adding New Records](./Adding-New-Records.md) - Creating finds, buckets, etc.
- [User Guide Home](./User-Guide.md) - Return to main guide

---

**Last Updated**: December 2025  
**Required Permission**: ROLE_ADMIN
