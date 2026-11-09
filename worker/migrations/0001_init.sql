CREATE TABLE IF NOT EXISTS records (id TEXT PRIMARY KEY, owner TEXT NOT NULL, section TEXT NOT NULL, title TEXT NOT NULL, body TEXT NOT NULL DEFAULT '', metadata TEXT NOT NULL DEFAULT '{}', created_at TEXT NOT NULL, updated_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_records_owner_section ON records(owner,section,updated_at);
CREATE TABLE IF NOT EXISTS settings (owner TEXT PRIMARY KEY, data TEXT NOT NULL DEFAULT '{}', updated_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS mood_entries (id TEXT PRIMARY KEY, owner TEXT NOT NULL, day TEXT NOT NULL, mood INTEGER NOT NULL CHECK(mood BETWEEN 1 AND 5), energy INTEGER NOT NULL CHECK(energy BETWEEN 1 AND 5), stress INTEGER NOT NULL CHECK(stress BETWEEN 1 AND 5), notes TEXT NOT NULL DEFAULT '', updated_at TEXT NOT NULL, UNIQUE(owner,day));
CREATE INDEX IF NOT EXISTS idx_mood_owner_day ON mood_entries(owner,day);
CREATE TABLE IF NOT EXISTS habit_completions (owner TEXT NOT NULL, habit_id TEXT NOT NULL, day TEXT NOT NULL, PRIMARY KEY(owner,habit_id,day));
CREATE TABLE IF NOT EXISTS transactions (id TEXT PRIMARY KEY, owner TEXT NOT NULL, title TEXT NOT NULL, amount REAL NOT NULL, category TEXT NOT NULL, day TEXT NOT NULL, created_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_transactions_owner_day ON transactions(owner,day);
