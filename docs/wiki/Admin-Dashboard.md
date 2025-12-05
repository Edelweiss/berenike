# Admin Dashboard

This guide explains the Berenike database Admin Dashboard, your central hub for navigation, management, and quick access to key features.

**Required Permission**: `ROLE_USER` (basic access), `ROLE_EDITOR` or `ROLE_ADMIN` (full features)

## Table of Contents

- [Overview](#overview)
- [Accessing the Dashboard](#accessing-the-dashboard)
- [Dashboard Layout](#dashboard-layout)
- [Quick Links Section](#quick-links-section)
- [Featured Finds Section](#featured-finds-section)
- [Edit Actions Section](#edit-actions-section)
- [Admin Actions Section](#admin-actions-section)
- [External Resources Section](#external-resources-section)
- [Statistics Section](#statistics-section)
- [Role-Based Visibility](#role-based-visibility)
- [Customization](#customization)

## Overview

The **Dashboard** is your central command center in the Berenike database system. It provides:

- 🔗 **Quick Links**: Fast access to common pages
- 🏺 **Featured Finds**: Highlighted archaeological finds
- ⭐ **Edit Actions**: Create new records (editors only)
- 👥 **Admin Actions**: User management (administrators only)
- 🌐 **External Resources**: Links to related websites
- 📊 **Statistics**: Database overview

### Purpose

The dashboard helps you:
- Navigate efficiently
- Access frequently used features
- See featured content
- Perform administrative tasks
- Monitor database status

## Accessing the Dashboard

### From Navigation Menu

1. Log in to Berenike database
2. Click **"Dashboard"** in the main navigation menu

### Direct URL

Navigate to: `/dashboard`

### From Home Page

Click **"Go to Dashboard"** or similar link on the home page

### Default Landing

Depending on configuration, the dashboard may be:
- Your default landing page after login
- Accessible from any page via menu
- Bookmarkable for quick access

## Dashboard Layout

The dashboard uses a **tile-based grid layout** that adapts to your screen size.

### Visual Organization

```
┌─────────────────┬─────────────────┬─────────────────┐
│  Quick Links    │ Featured Finds  │ Edit Actions    │
├─────────────────┼─────────────────┼─────────────────┤
│ External Res.   │ Admin Actions   │  Statistics     │
└─────────────────┴─────────────────┴─────────────────┘
```

### Tile Components

Each tile includes:
- **Header Bar**: Tile title in colored bar
- **Content Area**: Links, information, or data
- **Styled Borders**: Visual separation

### Responsive Design

On smaller screens:
- Tiles stack vertically
- Single column layout
- Maintains all functionality
- Scrollable content

## Quick Links Section

**Visible to**: All users (ROLE_USER)

Provides fast access to main listing pages.

### Available Links

- 📋 **All Finds**: View complete list of finds (`/find/list`)
- 🪣 **All Buckets**: Browse all buckets (`/bucket/list`)
- 📍 **All Loci**: See all loci (`/locus/list`)
- 🏗️ **All Trenches**: View excavation areas (`/excavation/list`)

### Usage

Click any link to navigate directly to that section.

### Purpose

- Quick browsing of different record types
- Starting point for searches
- Overview of database contents

## Featured Finds Section

**Visible to**: All users (ROLE_USER)

Displays highlighted or recently added archaeological finds.

### Display Format

Each featured find shows:
- **Find ID**: Database identifier (clickable)
- **Inventory Number**: Find reference
- **Object Type**: What the artifact is
- **Context**: Trench, locus information

### Example Display

```
ID 45 - BE23-045
Amphora body sherd
Trench: BE23-01 | Locus: 023
```

### Empty State

If no finds are featured:
```
No featured finds available
```

### Purpose

- Highlight important discoveries
- Showcase recent additions
- Provide example records for new users
- Quick access to key finds

### Customization

Featured finds may be:
- Randomly selected
- Recently added
- Manually curated by administrators
- Based on specific criteria

## Edit Actions Section

**Visible to**: Editors and Administrators (`ROLE_EDITOR`, `ROLE_ADMIN`)

Provides quick access to record creation forms.

### Available Actions

- ⭐ **Create new Find**: Add individual find record
- ⭐ **Create new Bucket**: Add collection container
- ⭐ **Create new Locus**: Add archaeological context
- ⭐ **Create new Trench**: Add excavation area

### Navigation

Each link takes you directly to the creation form:
- `/admin/find/new`
- `/admin/bucket/new`
- `/admin/locus/new`
- `/admin/trench/new`

### Usage Tips

1. Create records in hierarchical order:
   - Trench → Locus → Bucket → Find
2. Start at the highest level needed
3. Link new records to existing parents

### Not Visible If...

You only have `ROLE_USER`:
- Cannot create records
- Tile is hidden
- Contact administrator for editor access

## Admin Actions Section

**Visible to**: Administrators only (`ROLE_ADMIN`)

Provides access to user management and administrative functions.

### Available Actions

- 👥 **Manage Users**: View and edit all user accounts (`/user/list`)
- ➕ **Create new User**: Add user account (`/user/new`)

### User Management

Click **"Manage Users"** to:
- View list of all users
- Search and filter users
- Edit user accounts
- Activate/deactivate accounts
- Assign roles and permissions

See [User Management](./User-Management.md) for details.

### Create User

Click **"Create new User"** to:
- Add new user account
- Set username and password
- Assign roles
- Configure account settings

### Security Note

Only administrators can:
- See this tile
- Access user management
- Create/edit/delete users
- View user details

## External Resources Section

**Visible to**: Administrators only (`ROLE_ADMIN`)

Provides links to external websites and tools related to the Berenike project.

### Available Resources

- 🐛 **GitHub Issues**: Bug tracking and feature requests
  - `https://github.com/Edelweiss/berenike/issues`
  - Report bugs, request features
  - Opens in new tab

- 📖 **GitHub Wiki**: Project documentation
  - `https://github.com/Edelweiss/berenike/wiki`
  - Technical documentation
  - Development guides

- 📊 **Google Spreadsheet**: Project data sheets
  - Collaborative data management
  - Supplementary information

- 🖼️ **HeidICON**: Image repository
  - `https://heidicon.ub.uni-heidelberg.de/`
  - View archaeological photographs
  - See [HeidICON Integration](./HeidICON-Integration.md)

- 🌐 **Berenike PCMA**: Official project website
  - `https://berenike.pcma.uw.edu.pl/`
  - Excavation information
  - Publications and news

### Purpose

- Quick access to related tools
- Reference resources
- Project context
- External documentation

### Link Behavior

All external links:
- Open in new browser tab/window
- Include `rel="noopener noreferrer"` for security
- Maintain your database session

## Statistics Section

**Visible to**: All users (ROLE_USER)

Displays database statistics and activity information.

### Current Information

- **Total Featured Finds**: Count of highlighted finds
- **🔗 Go to Home**: Return to home page link

### Potential Statistics

Future enhancements may include:
- Total finds in database
- Recent additions (last 7 days)
- User activity metrics
- Excavation season summaries
- Popular searches
- Data quality indicators

### Purpose

- Quick overview of database status
- Recent activity monitoring
- Data growth tracking

## Role-Based Visibility

Different users see different dashboard tiles based on their permissions.

### ROLE_USER (Basic User)

**Visible Tiles**:
- ✅ Quick Links
- ✅ Featured Finds
- ✅ Statistics

**Hidden Tiles**:
- ❌ Edit Actions
- ❌ Admin Actions
- ❌ External Resources

### ROLE_EDITOR

**Visible Tiles**:
- ✅ Quick Links
- ✅ Featured Finds
- ✅ Edit Actions (⭐ NEW)
- ✅ Statistics

**Hidden Tiles**:
- ❌ Admin Actions
- ❌ External Resources

### ROLE_ADMIN (Administrator)

**Visible Tiles**:
- ✅ Quick Links
- ✅ Featured Finds
- ✅ Edit Actions
- ✅ Admin Actions (⭐ NEW)
- ✅ External Resources (⭐ NEW)
- ✅ Statistics

**All Features Available**

### Permission Checking

The dashboard automatically:
- Checks your user role
- Shows appropriate tiles
- Hides unauthorized features
- Updates when roles change

## Customization

### Personalizing Your Dashboard

Depending on system configuration, you may be able to:
- Bookmark favorite tiles
- Rearrange tile order
- Customize featured finds
- Set default landing page

### For Administrators

Administrators can customize:
- Featured finds selection
- External resource links
- Statistics displayed
- Tile visibility rules

### Configuration Files

Dashboard behavior is controlled by:
- `HomeController.php`: Dashboard logic
- `dashboard.html.twig`: Template layout
- Database queries: Featured finds selection

## Tips for Effective Use

### 1. Bookmark the Dashboard

Add to browser bookmarks:
```
Name: Berenike Dashboard
URL: https://your-domain.com/dashboard
```

### 2. Use as Home Base

Start and end each session at the dashboard:
- Get oriented
- Access frequently used features
- Check featured finds
- Navigate efficiently

### 3. Keyboard Navigation

Navigate quickly:
- **Tab**: Move between links
- **Enter**: Follow link
- **Ctrl/Cmd + Click**: Open in new tab

### 4. Open Multiple Tabs

Work efficiently:
1. Start at dashboard
2. Right-click links → "Open in new tab"
3. Work in multiple tabs
4. Keep dashboard tab open for reference

### 5. Learn the Patterns

Memorize common workflows:
- **View data**: Quick Links → List → Detail
- **Add records**: Edit Actions → Form → Save
- **Manage users**: Admin Actions → User List → Edit

### 6. Monitor Featured Finds

Check regularly for:
- New important discoveries
- Example records
- Quality data entry examples
- Training materials

## Troubleshooting

### Dashboard Won't Load

**Solutions**:
1. Check login status
2. Refresh page (F5 or Cmd+R)
3. Clear browser cache
4. Try different browser
5. Contact administrator

### Missing Tiles

**Problem**: Expected tiles don't appear

**Causes**:
- Insufficient permissions
- Role not assigned correctly
- Display rules changed

**Solutions**:
1. Check your user role
2. Log out and back in
3. Ask administrator about permissions
4. Verify role assignments

### Broken Links

**Problem**: Links don't work

**Solutions**:
1. Check URL in browser
2. Verify page exists
3. Check permissions for target page
4. Report to administrator

### Featured Finds Not Showing

**Problem**: "No featured finds available"

**Possible Reasons**:
- No finds in database yet
- Selection criteria not met
- Database query error
- Configuration issue

**Not necessarily a problem**:
- Normal for new installations
- Resolves as finds are added

### External Links Don't Open

**Problem**: External resource links fail

**Solutions**:
1. Check internet connection
2. Try copying URL to new tab
3. Verify external site is online
4. Check browser popup blocker
5. Check firewall settings

## Related Topics

- [User Management](./User-Management.md) - Admin Actions details
- [Adding New Records](./Adding-New-Records.md) - Edit Actions details
- [Viewing Finds](./Viewing-Finds.md) - Quick Links destinations
- [HeidICON Integration](./HeidICON-Integration.md) - External resource
- [User Guide Home](./User-Guide.md) - Return to main guide

## Keyboard Shortcuts

### General Navigation

- **Tab**: Move forward through links
- **Shift + Tab**: Move backward
- **Enter**: Activate link
- **Spacebar**: Scroll down
- **Home**: Scroll to top
- **End**: Scroll to bottom

### Browser Shortcuts

- **Ctrl/Cmd + R**: Refresh page
- **Ctrl/Cmd + T**: New tab
- **Ctrl/Cmd + W**: Close tab
- **Ctrl/Cmd + L**: Focus address bar
- **Ctrl/Cmd + Click**: Open link in new tab

## Best Practices

### For All Users

1. **Start at Dashboard**: Begin each session here
2. **Explore Systematically**: Click through tiles to learn
3. **Use Quick Links**: Faster than menu navigation
4. **Check Featured Finds**: See example records
5. **Bookmark Dashboard**: Quick access

### For Editors

1. **Use Edit Actions**: Faster than menu → admin → new
2. **Plan Before Creating**: Have data ready
3. **Create Top-Down**: Trench → Locus → Bucket → Find
4. **Save Dashboard Tab**: Keep open while working

### For Administrators

1. **Monitor Statistics**: Check database health
2. **Update Featured Finds**: Keep content fresh
3. **Use Admin Actions**: Central user management
4. **Check External Links**: Verify they work
5. **Document Changes**: Track dashboard customizations

## Future Enhancements

Potential dashboard improvements:

- **User Preferences**: Customizable tile layout
- **More Statistics**: Detailed database metrics
- **Activity Feed**: Recent changes log
- **Notifications**: System alerts and messages
- **Search Widget**: Quick search from dashboard
- **Favorites**: Personal bookmark tiles
- **Theme Options**: Color scheme choices
- **Mobile Optimization**: Better mobile experience

Contact administrators with suggestions!

---

**Last Updated**: December 2025  
**Required Permission**: ROLE_USER (basic), ROLE_EDITOR, or ROLE_ADMIN (full features)  
**URL**: `/dashboard`
