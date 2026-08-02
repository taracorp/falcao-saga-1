-- Falcao Saga - Migration 001
-- Applied to Supabase self-hosted on VPS 31.97.49.146
-- Date: 2026-08-02

-- All tables in public schema with fs_ prefix

CREATE TABLE IF NOT EXISTS public.fs_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  avatar_jersey_id INT DEFAULT 0,
  total_xp INT DEFAULT 0,
  total_coins INT DEFAULT 500,
  total_rpp INT DEFAULT 0,
  current_season INT DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fs_player_cards (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID NOT NULL REFERENCES fs_profiles(id) ON DELETE CASCADE,
  card_id INT NOT NULL,
  quantity INT DEFAULT 1,
  is_foil BOOLEAN DEFAULT false,
  acquired_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(profile_id, card_id)
);

CREATE TABLE IF NOT EXISTS public.fs_jerseys (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID NOT NULL REFERENCES fs_profiles(id) ON DELETE CASCADE,
  jersey_id INT NOT NULL,
  acquired_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(profile_id, jersey_id)
);

CREATE TABLE IF NOT EXISTS public.fs_point_transactions (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID NOT NULL REFERENCES fs_profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('coin_earn','coin_spend','xp_earn','rpp_earn','rpp_spend')),
  amount INT NOT NULL,
  source TEXT NOT NULL,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fs_leaderboard (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID NOT NULL REFERENCES fs_profiles(id) ON DELETE CASCADE,
  username TEXT NOT NULL,
  xp INT NOT NULL DEFAULT 0,
  rank INT,
  cards_collected INT DEFAULT 0,
  week_start DATE NOT NULL DEFAULT date_trunc('week', now()),
  UNIQUE(profile_id, week_start)
);

CREATE TABLE IF NOT EXISTS public.fs_reward_catalog (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  rpp_cost INT NOT NULL,
  tier TEXT CHECK (tier IN ('bronze','silver','gold','diamond','crown')),
  stock_total INT,
  stock_remaining INT,
  is_active BOOLEAN DEFAULT true,
  image_url TEXT
);

CREATE TABLE IF NOT EXISTS public.fs_redemptions (
  id BIGSERIAL PRIMARY KEY,
  profile_id UUID NOT NULL REFERENCES fs_profiles(id) ON DELETE CASCADE,
  reward_id INT NOT NULL REFERENCES fs_reward_catalog(id),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending','verified','shipped','delivered','cancelled')),
  shipping_info JSONB DEFAULT '{}',
  admin_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
