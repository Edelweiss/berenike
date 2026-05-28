# heidICON XML Import — Technical Specification

## Overview

This document specifies the import of image metadata from heidICON (easydb) XML export files into the Berenike.project database (`berenike` schema, MariaDB).

The Symfony console command to be implemented is:

```
src/Command/HeidIconImportCommand.php
```

Invoked as:

```bash
php bin/console heidicon:import [<directory>]
```

The optional `<directory>` argument is scanned **recursively** for all `*.xml` files. Defaults to `data/heidICON` (relative to project root).

---

## 1. Source Data

### Location

```
data/heidICON/
  <export-folder>/
    <subfolder>/
      <name>.xml    ← one XML file per heidICON object
```

Real example:

```
data/heidICON/2026-05-27 09_09 easydb FULL Berenike.project/
  folder24093704-24195771/
    24093704-24195771@2cb291dc-94d3-482f-9630-a3943ebb1006.xml
```

### XML Namespace

**All elements are in the default namespace:**

```
https://schema.easydb.de/EASYDB/1.0/objects/
```

Register this namespace when using XPath (e.g. as prefix `eb`):

```php
$xpath->registerNamespace('eb', 'https://schema.easydb.de/EASYDB/1.0/objects/');
```

### Root Structure

Each XML file has exactly **one `<objekte>`** (the heidICON object, linked to one berenike find) and **one or more `<ressourcen>`** (one per image file). **`<ressourcen>` elements are siblings of `<objekte>` under `<objects>`, not nested inside `<objekte>`.**

```xml
<objects xmlns="https://schema.easydb.de/EASYDB/1.0/objects/" …>
  <objekte>…</objekte>
  <ressourcen>…</ressourcen>   <!-- one per image -->
  <ressourcen>…</ressourcen>
  …
</objects>
```

---

## 2. Find Identification

### Extract find ID from XML

XPath to the link URL (relative to `eb:objects`):

```
eb:objekte/eb:custom[@name='obj_beschreibung_link']/eb:string[@name='url']
```

The value is a URL of the form:

```
https://berenike.zaw.uni-heidelberg.de/find/20742
```

Extract the integer at the end with:

```php
preg_match('/\/find\/(\d+)$/', $url, $m);
$findId = (int) $m[1];
```

### Error handling

If no URL is found, the regex fails, or `$findId` does not exist in `berenike.find`:

- **Skip this XML file entirely**
- Log: `[WARNING] Skipping <filename>: find ID <id> not found in database`

---

## 3. Updating `berenike.find`

XPaths relative to `eb:objekte`:

| DB field | XPath | Example |
|---|---|---|
| `find.heidicon_id` | `eb:_id` | `942472` |
| `find.heidicon_uuid` | `eb:_uuid` | `b17bf1dd-a7e7-42c2-b441-8f57cbd9e20e` |
| `find.heidicon_system_object_id` | `eb:_system_object_id` | `24093704` |

**Action:** Update the existing `berenike.find` row with all three fields.

---

## 4. Linking `<objekte>` to `<ressourcen>`

The link is via **`eas-id`** values shared between `<objekte>` and `<ressourcen>`.

- `<objekte>/<_standard-eas>/files/file/eas-id` — lists all eas-ids belonging to this object
- `<ressourcen>/<_standard-eas>/files/file/eas-id` — the eas-id of that resource

Since each XML file contains exactly one `<objekte>` and all its associated `<ressourcen>`, all `<ressourcen>` elements in one file belong to the one `<objekte>` in that file. No filtering by eas-id is necessary.

---

## 5. Importing `berenike.image`

For each `<ressourcen>` element, insert or update one row in `berenike.image`.

### Duplicate handling

Look up by `heidicon_id` (= `ressourcen/_id`). If a row with that `heidicon_id` already exists: **update it**. Otherwise: **insert**.

### Field mapping

XPaths are relative to `eb:ressourcen`:

| DB field | Source | Notes |
|---|---|---|
| `id` | auto-increment | set by DB |
| `find_id` | — | integer ID of the matched `berenike.find` |
| `type` | constant | always `'photo'` |
| `number` | — | leave `NULL` |
| `size` | `eb:asset/eb:files/eb:file/eb:technical_metadata/eb:width` + `','` + `…/eb:height` | e.g. `4037,6896` |
| `file` | `eb:asset/eb:files/eb:file/eb:original_filename` | e.g. `ID20742 .tiff` |
| `path` | — | leave `NULL` |
| `heidicon_id` | `eb:_id` | e.g. `1039117` |
| `heidicon_uuid` | `eb:_uuid` | e.g. `b3e5d221-727a-478a-a7c1-aeca569010aa` |
| `heidicon_system_object_id` | `eb:_system_object_id` | e.g. `24101279` |

> `eb:asset/eb:files/eb:file` contains exactly one `<file>` element per `<ressourcen>`.

---

## 6. Importing `berenike.image_specialist`

After inserting/updating the `image` row, handle the photographer credit.

### Photographer GND lookup

XPath relative to `eb:ressourcen`:

```
eb:_nested__ressourcen__res_autoren/eb:ressourcen__res_autoren
  /eb:custom[@name='res_autor_gnd']/eb:string[@name='conceptURI']
```

This yields a full GND URL, e.g.:

```
https://d-nb.info/gnd/1020326514
```

Look up the specialist:

```sql
SELECT id FROM berenike.specialist WHERE gnd = '<conceptURI>'
```

> `berenike.specialist.gnd` stores the **full GND URL** (matching the XML value exactly).

### Field mapping

| DB field | Source |
|---|---|
| `id` | auto-increment |
| `image_id` | id of the `berenike.image` row just inserted/updated |
| `specialist_id` | id from `berenike.specialist` matched by GND |
| `speciality` | constant `'photographer'` |
| `year` | first 4 characters of `eb:asset/eb:files/eb:file/eb:date_created`, cast to int; `NULL` if element is empty |

### Duplicate handling

Before inserting, delete any existing `image_specialist` row with the same `image_id` and `speciality = 'photographer'`.

### Edge cases

| Situation | Action |
|---|---|
| No `_nested__ressourcen__res_autoren` element present | Skip `image_specialist`; log `[WARNING] No GND author for ressourcen _id=<id>; plain-text author: <res_autor_lok value if present>` |
| GND URI not found in `berenike.specialist` | Skip `image_specialist`; log `[WARNING] Specialist not found for GND <uri> (ressourcen _id=<id>)` |
| `date_created` element is empty (`<date_created/>`) | Set `year = NULL` |

---

## 7. Console Command Specification

**Class:** `src/Command/HeidIconImportCommand.php`
**Command name:** `heidicon:import`

```bash
php bin/console heidicon:import [<directory>]
```

| Argument | Type | Default | Description |
|---|---|---|---|
| `directory` | optional string | `data/heidICON` (project root relative) | Directory scanned recursively for `*.xml` files |

### Processing order (per XML file)

1. Parse XML with `DOMDocument`; register namespace prefix `eb` = `https://schema.easydb.de/EASYDB/1.0/objects/`
2. Extract find ID from `obj_beschreibung_link` URL → look up `berenike.find` → skip + warn if not found
3. Update `find.heidicon_id`, `find.heidicon_uuid`, `find.heidicon_system_object_id`
4. For each `<ressourcen>`:
   - Extract image fields → upsert `berenike.image` (keyed on `heidicon_id`)
   - Extract photographer GND → upsert `berenike.image_specialist`
5. Flush Doctrine entity manager (batch every 50 records)

### Output

Use `SymfonyStyle` (same pattern as existing commands). Print a final summary:

```
Processed: 47 files | Images upserted: 183 | Warnings: 5
```

---

## 8. Known Data Quirks

- Some `<date_created>` elements are self-closing (`<date_created/>`): treat as `NULL`
- Some `<ressourcen>` have only `_nested__ressourcen__res_autoren_lok` (plain-text name, no GND): skip `image_specialist`
- UUID in original spec had a typo (missing trailing `e`); correct value from real data: `b17bf1dd-a7e7-42c2-b441-8f57cbd9e20e`
