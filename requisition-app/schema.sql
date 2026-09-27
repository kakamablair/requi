-- ============================================================
-- Kama Companies - Requisition & Calendar System
-- Supabase PostgreSQL Database Schema
-- ============================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. ACCOUNTS / USERS
CREATE TABLE IF NOT EXISTS public.accounts (
    id TEXT PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    dept TEXT NOT NULL CHECK (dept IN ('Sales', 'R and D', 'Executive', 'Engineering', 'Finance')),
    role TEXT NOT NULL CHECK (role IN ('employee', 'manager', 'admin')),
    password_salt TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. REQUISITIONS / REQUESTS
CREATE TABLE IF NOT EXISTS public.requests (
    id TEXT PRIMARY KEY,
    type TEXT NOT NULL,
    priority TEXT NOT NULL DEFAULT 'Normal' CHECK (priority IN ('Normal', 'High', 'Urgent')),
    title TEXT NOT NULL,
    details TEXT,
    quantity TEXT,
    estimated_cost TEXT,
    type_details JSONB DEFAULT '{}'::jsonb,
    needed_by TEXT,
    attachment_notes TEXT,
    attachments JSONB DEFAULT '[]'::jsonb,
    requester TEXT NOT NULL,
    requester_id TEXT REFERENCES public.accounts(id) ON DELETE SET NULL,
    department TEXT NOT NULL CHECK (department IN ('Sales', 'R and D', 'Executive', 'Engineering', 'Finance')),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'pending_manager', 'pending_finance', 'needs_revision', 'approved', 'rejected')),
    action_comment TEXT,
    action_by TEXT,
    action_at TIMESTAMPTZ,
    history JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. CALENDAR EVENTS
CREATE TABLE IF NOT EXISTS public.events (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    date DATE NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('activity', 'leave', 'meeting', 'other')),
    description TEXT,
    created_by TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. DEPARTMENT BUDGETS
CREATE TABLE IF NOT EXISTS public.budgets (
    department TEXT PRIMARY KEY CHECK (department IN ('Sales', 'R and D', 'Executive', 'Engineering', 'Finance')),
    allocated_amount NUMERIC NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed Initial Budgets
INSERT INTO public.budgets (department, allocated_amount)
VALUES
    ('Sales', 0),
    ('R and D', 0),
    ('Executive', 0),
    ('Engineering', 0),
    ('Finance', 0)
ON CONFLICT (department) DO NOTHING;

-- 5. USER PREFERENCES
CREATE TABLE IF NOT EXISTS public.preferences (
    user_id TEXT PRIMARY KEY REFERENCES public.accounts(id) ON DELETE CASCADE,
    theme TEXT NOT NULL DEFAULT 'light' CHECK (theme IN ('light', 'dark', 'system')),
    browser_notifications BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. NOTIFICATIONS
CREATE TABLE IF NOT EXISTS public.notifications (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    request_id TEXT REFERENCES public.requests(id) ON DELETE CASCADE,
    read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. AUDIT LOGS
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id TEXT PRIMARY KEY,
    action TEXT NOT NULL,
    description TEXT,
    entity_id TEXT,
    related_user_id TEXT REFERENCES public.accounts(id) ON DELETE SET NULL,
    actor_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (RLS) on all tables
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- Set up open access policies for app operations
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow anon read/write accounts') THEN
        CREATE POLICY "Allow anon read/write accounts" ON public.accounts FOR ALL USING (true) WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow anon read/write requests') THEN
        CREATE POLICY "Allow anon read/write requests" ON public.requests FOR ALL USING (true) WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow anon read/write events') THEN
        CREATE POLICY "Allow anon read/write events" ON public.events FOR ALL USING (true) WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow anon read/write budgets') THEN
        CREATE POLICY "Allow anon read/write budgets" ON public.budgets FOR ALL USING (true) WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow anon read/write preferences') THEN
        CREATE POLICY "Allow anon read/write preferences" ON public.preferences FOR ALL USING (true) WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow anon read/write notifications') THEN
        CREATE POLICY "Allow anon read/write notifications" ON public.notifications FOR ALL USING (true) WITH CHECK (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Allow anon read/write audit_logs') THEN
        CREATE POLICY "Allow anon read/write audit_logs" ON public.audit_logs FOR ALL USING (true) WITH CHECK (true);
    END IF;
END $$;

-- Enable Realtime for live cross-device sync
ALTER PUBLICATION supabase_realtime ADD TABLE public.requests;
ALTER PUBLICATION supabase_realtime ADD TABLE public.events;
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
ALTER PUBLICATION supabase_realtime ADD TABLE public.budgets;
