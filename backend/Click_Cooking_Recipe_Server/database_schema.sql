-- Click Cooking Recipe Database Schema
-- PostgreSQL schema for ingredient-based recipe recommendation.
-- This file defines only the table structure.

CREATE TABLE IF NOT EXISTS public.igr (
    igr_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS public.rcp (
    rcp_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    image_url TEXT
);

CREATE TABLE IF NOT EXISTS public.igr_alias (
    alias_id SERIAL PRIMARY KEY,
    igr_id INTEGER NOT NULL REFERENCES public.igr(igr_id) ON DELETE CASCADE,
    alias_name VARCHAR(50) NOT NULL,
    UNIQUE (igr_id, alias_name)
);

CREATE TABLE IF NOT EXISTS public.rcp_igr (
    rcp_id INTEGER NOT NULL REFERENCES public.rcp(rcp_id) ON DELETE CASCADE,
    igr_id INTEGER NOT NULL REFERENCES public.igr(igr_id) ON DELETE CASCADE,
    amount VARCHAR(50),
    PRIMARY KEY (rcp_id, igr_id)
);

CREATE INDEX IF NOT EXISTS idx_rcp_igr_rcp_id ON public.rcp_igr (rcp_id);
CREATE INDEX IF NOT EXISTS idx_rcp_igr_igr_id ON public.rcp_igr (igr_id);

CREATE TABLE IF NOT EXISTS public.rcp_step (
    step_id SERIAL PRIMARY KEY,
    rcp_id INTEGER NOT NULL REFERENCES public.rcp(rcp_id) ON DELETE CASCADE,
    step_number INTEGER NOT NULL,
    description TEXT NOT NULL,
    UNIQUE (rcp_id, step_number)
);
