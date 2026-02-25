-- Flyway migration V1: Create hello_table and seed initial data

CREATE TABLE IF NOT EXISTS hello_table (
    id   BIGINT PRIMARY KEY,
    alias VARCHAR(100) NOT NULL
);

INSERT INTO hello_table (id, alias) VALUES
    (1,  'persuasive-donkey'),
    (2,  'hopeful-stair'),
    (3,  'curious-mountain'),
    (4,  'brave-lantern'),
    (5,  'gentle-river'),
    (6,  'witty-compass'),
    (7,  'radiant-pebble'),
    (8,  'daring-feather'),
    (9,  'serene-anchor'),
    (10, 'vivid-horizon');
