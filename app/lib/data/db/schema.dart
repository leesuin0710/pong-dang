const int kSchemaVersion = 2;

/// Statements added between schema v1 and v2 (F7/F8 다꾸 캘린더).
/// Also included in [kCreateTableStatements] so a fresh install gets them
/// in one pass — [AppDatabase]'s upgrade path re-runs just this list for
/// existing v1 databases.
const List<String> kV2CreateTableStatements = [
  '''
  CREATE TABLE deco_entries (
    id TEXT PRIMARY KEY,
    date TEXT NOT NULL,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL
  )
  ''',
  '''
  CREATE TABLE deco_placements (
    id TEXT PRIMARY KEY,
    entry_id TEXT NOT NULL REFERENCES deco_entries(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('sticker', 'text')),
    item_id TEXT REFERENCES items(id) ON DELETE CASCADE,
    text TEXT,
    text_color_hex TEXT,
    x REAL NOT NULL,
    y REAL NOT NULL,
    scale REAL NOT NULL DEFAULT 1.0,
    rotation REAL NOT NULL DEFAULT 0.0,
    z_index INTEGER NOT NULL DEFAULT 0,
    CHECK (
      (type = 'sticker' AND item_id IS NOT NULL AND text IS NULL)
      OR (type = 'text' AND text IS NOT NULL AND item_id IS NULL)
    )
  )
  ''',
  'CREATE INDEX idx_deco_entries_date ON deco_entries(date)',
  'CREATE INDEX idx_deco_placements_entry_id ON deco_placements(entry_id)',
  'CREATE INDEX idx_deco_placements_item_id ON deco_placements(item_id)',
];

const List<String> kCreateTableStatements = [
  '''
  CREATE TABLE folders (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    parent_id TEXT REFERENCES folders(id) ON DELETE CASCADE,
    icon_emoji TEXT,
    color_hex TEXT,
    created_at INTEGER NOT NULL
  )
  ''',
  '''
  CREATE TABLE items (
    id TEXT PRIMARY KEY,
    doc_number INTEGER NOT NULL UNIQUE,
    image_path TEXT NOT NULL,
    thumbnail_path TEXT NOT NULL,
    rating INTEGER NOT NULL DEFAULT 0 CHECK (rating BETWEEN 0 AND 5),
    memo TEXT,
    created_at INTEGER NOT NULL,
    folder_id TEXT REFERENCES folders(id) ON DELETE SET NULL
  )
  ''',
  '''
  CREATE TABLE labels (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
  )
  ''',
  '''
  CREATE TABLE item_labels (
    item_id TEXT NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    label_id TEXT NOT NULL REFERENCES labels(id) ON DELETE CASCADE,
    PRIMARY KEY (item_id, label_id)
  )
  ''',
  'CREATE INDEX idx_items_folder_id ON items(folder_id)',
  'CREATE INDEX idx_items_created_at ON items(created_at)',
  'CREATE INDEX idx_items_doc_number ON items(doc_number)',
  'CREATE INDEX idx_item_labels_label_id ON item_labels(label_id)',
  ...kV2CreateTableStatements,
];
