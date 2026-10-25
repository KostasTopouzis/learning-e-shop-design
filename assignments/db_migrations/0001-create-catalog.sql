-- Create database for The Edit e-commerce platform
-- I leave the create database sql commented,
-- since I am not yet sure what options would be
-- appropriate for an e-commerce database
-- CREATE DATABASE the_edit_eshop_db
-- OWNER postgres
-- ENCODING 'UTF8'
-- TEMPLATE template0;

-- Close all migration statements into a transaction.
-- Tools like Prisma do this for you.
BEGIN;
    -- Create product types table
    -- This is not a categorey tree per Amazon
    -- but rather a template per Saleor
    CREATE TABLE product_types(
        id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        slug TEXT UNIQUE NOT NULL,
        display_name VARCHAR(100) NOT NULL
    );

    -- Create products table
    CREATE TABLE products(
        id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        handle TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        product_type_id INTEGER NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (product_type_id) REFERENCES product_types(id) ON DELETE RESTRICT
    );

    -- Create product variants table
    CREATE TABLE product_variants(
        id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        sku TEXT UNIQUE NOT NULL,
        product_id INTEGER NOT NULL,
        price_cents INTEGER NOT NULL,
        stock NOT NULL INTEGER CHECK (stock >= 0),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
    );

    -- Create product options table
    CREATE TABLE product_options(
        id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        product_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        position INTEGER NOT NULL DEFAULT 0,
        UNIQUE (product_id, name),
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
    );

    -- Create product option values table
    CREATE TABLE product_option_values(
        id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        product_option_id INTEGER,
        value TEXT NOT NULL,
        UNIQUE (product_option_id, value),
        FOREIGN KEY (product_option_id) REFERENCES product_options(id) ON DELETE CASCADE
    );

    -- Create variant option values table
    CREATE TABLE variant_option_values(
        product_variant_id INTEGER,
        product_option_value_id INTEGER,
        PRIMARY KEY (product_variant_id, product_option_value_id),
        FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE CASCADE,
        FOREIGN KEY (product_option_value_id) REFERENCES product_option_values(id) ON DELETE CASCADE
    );
COMMIT;

