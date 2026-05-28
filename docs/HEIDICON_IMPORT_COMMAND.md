# heidICON Import Command

## Overview

The `heidicon:import` command synchronises image metadata and photographer credits
from heidICON (easydb) XML exports into the berenike database.

For each XML file it:

1. Iterates **every** `<objekte>` element (a file may hold one to several hundred) and finds the matching `find` record (by the URL in `obj_beschreibung_link`).
2. Stores `heidicon_id`, `heidicon_uuid` and `heidicon_system_object_id` on the find.
3. On the first encounter of a find within a run, deletes **all** existing
   `image` rows of that find (and their `image_specialist` rows via
   cascade-remove). The heidICON XML is the authoritative source: anything
   not described in the current export is removed.
4. Builds an in-memory map `eas-id → find` from each resolved `<objekte>`'s `_standard-eas/files/file/eas-id` list.
5. Inserts one `image` row per `<ressourcen>` element (keyed on `heidicon_id` = the asset's eas-id, scoped per find), linked to the find whose objekte owns the ressourcen's eas-id.
6. Links the photographer (looked up by GND URI on `specialist.gnd`)
   via the `image_specialist` table with `speciality = 'photographer'`.

The full data-mapping specification lives in
[docs/concept/heidICON.md](concept/heidICON.md).

## Usage

```bash
php bin/console heidicon:import [<directory>] [options]
```

### Arguments

| Argument    | Type     | Default          | Description |
| ----------- | -------- | ---------------- | ----------- |
| `directory` | optional | `data/heidICON`  | Directory scanned **recursively** for `*.xml` files. Relative paths are resolved from the project root; absolute paths are accepted. |

### Options

| Option              | Default | Description |
| ------------------- | ------- | ----------- |
| `--dry-run`         | off     | Parse, validate and report — no writes to the database. |
| `-b`, `--batch-size=N` | 50   | Flush/clear the Doctrine entity manager every N image upserts. |

## Examples

### Dry run on the default directory

```bash
php bin/console heidicon:import --dry-run
```

### Import a specific export folder

```bash
php bin/console heidicon:import data/heidICON/2026-05-28_3
```

### Import with a larger batch size

```bash
php bin/console heidicon:import data/heidICON -b 200
```

## Behaviour

### Find lookup

A single XML file may contain **multiple `<objekte>` elements**; each is
processed independently. For every `<objekte>` the find ID is extracted from
the URL stored in:

```
<objekte>/<custom name="obj_beschreibung_link">/<string name="url">
```

The integer at the end of the URL (`…/find/<id>`) is used to load
`berenike.find`. If the URL is missing, malformed, or the find does not
exist in the database, **only that `<objekte>` branch is skipped** — together
with every `<ressourcen>` that would have been linked to it. The XML file
itself still counts as processed and other `<objekte>` in the same file are
still imported. The condition is reported as a warning and counted under
`<objekte> skipped`.

### Image-to-find linking via `eas-id`

`<ressourcen>` are siblings of `<objekte>` under `<objects>`, not nested.
Each `<ressourcen>` carries a single `eas-id` at
`_standard-eas/files/file/eas-id`. Each `<objekte>` declares the eas-ids it
owns at the same path. The command builds a per-file map of
`eas-id → find` from all successfully resolved `<objekte>` and uses it to
attach every `<ressourcen>` to its rightful find.

A `<ressourcen>` whose eas-id is not present in the current file's map
(either because its owning `<objekte>` was skipped, or because that objekte
lives in a different export file) is itself skipped with a warning and
counted under `<ressourcen> orphaned`.

### Image upsert

Each `<ressourcen>` element becomes one `image` row, keyed by
`(heidicon_id, find_id)` where `heidicon_id` is the asset's **eas-id**
(`<ressourcen>/<_standard-eas>/files/file/eas-id`, not `ressourcen/_id`).
Because every matched find has its existing images wiped first (see the
introduction above), each ressourcen always becomes a fresh insert. The
same eas-id may appear on several finds at once (Sammelbilder — a single
heidICON asset depicting several finds): each find gets its own image row.
Fields written:

| Column                    | Source                                                    |
| ------------------------- | --------------------------------------------------------- |
| `find_id`                 | matched find                                              |
| `type`                    | constant `photo`                                          |
| `size`                    | `<width>,<height>` from `asset/files/file/technical_metadata` |
| `file`                    | `asset/files/file/original_filename`                      |
| `path`                    | empty string (column is `NOT NULL`)                       |
| `heidicon_id`             | `ressourcen/_standard-eas/files/file/eas-id` (asset eas-id) |
| `heidicon_uuid`           | `ressourcen/_uuid`                                        |
| `heidicon_system_object_id` | `ressourcen/_system_object_id`                          |

### Photographer link (`image_specialist`)

The GND URI is read from:

```
<ressourcen>/<_nested__ressourcen__res_autoren>/<ressourcen__res_autoren>
  /<custom name="res_autor_gnd">/<string name="conceptURI">
```

A specialist is matched by `specialist.gnd = <conceptURI>` (full GND URL,
e.g. `https://d-nb.info/gnd/1020326514`).

For each image, any pre-existing `image_specialist` row with
`speciality = 'photographer'` is removed before a fresh one is inserted, so
re-running the command is idempotent.

`year` is the four-digit year from `asset/files/file/date_created`,
or `NULL` if `<date_created/>` is empty.

### Edge cases

| Situation                                                         | Action                                                                 |
| ----------------------------------------------------------------- | ---------------------------------------------------------------------- |
| `obj_beschreibung_link` URL missing or malformed                  | Skip the `<objekte>` branch; warn.                                     |
| Find ID does not exist in `berenike.find`                         | Skip the `<objekte>` branch; warn.                                     |
| `<ressourcen>` eas-id not owned by any `<objekte>` in the same file | Skip the `<ressourcen>`; warn; counted under `<ressourcen> orphaned`.  |
| `<ressourcen>` without `_nested__ressourcen__res_autoren`         | Upsert the image; skip the specialist link; warn with the plain-text name from `_nested__ressourcen__res_autoren_lok` (if present). |
| GND URI not registered in `berenike.specialist`                   | Upsert the image; skip the specialist link; warn with the GND URI.     |
| `<date_created/>` is empty                                        | `year` set to `NULL`.                                                  |
| Malformed XML / no `<objekte>` element at all                     | Skip the whole file; warn (counted under `XML files with errors`).     |

## Output

A summary table is printed at the end:

| Metric                | Description                                                       |
| --------------------- | ----------------------------------------------------------------- |
| XML files processed   | Files that were successfully read and parsed.                     |
| XML files with errors | Files dropped entirely (invalid XML or no `<objekte>` element).   |
| `<objekte>` skipped   | `<objekte>` branches skipped because the find could not be resolved (no URL, malformed URL, or find not in DB). |
| Finds updated         | `berenike.find` rows whose heidICON identifiers were set.         |
| Images deleted        | Pre-existing `berenike.image` rows removed before re-inserting (one wipe per matched find per run; cascades to `image_specialist`). |
| Images inserted       | New rows in `berenike.image`.                                     |
| Images updated        | Existing `berenike.image` rows updated (normally `0` after the wipe-and-replace; non-zero only if multiple objekte in the same run target the same `(eas-id, find)` pair). |
| Specialist links set  | `image_specialist` rows written for photographers.                |
| `<ressourcen>` orphaned | `<ressourcen>` whose `eas-id` was not owned by any `<objekte>` in the same file (skipped). |
| Warnings              | Total warnings collected during the run.                          |

All warnings are then listed individually.

## Exit codes

- `0` — completed (possibly with warnings).
- `1` — fatal error (e.g. directory does not exist).
