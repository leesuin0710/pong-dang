const int kSchemaVersion = 1;

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
];
