-- Additive only: existing records and owner-only policies are unchanged.
ALTER TABLE public.homework ADD COLUMN IF NOT EXISTS location TEXT;
