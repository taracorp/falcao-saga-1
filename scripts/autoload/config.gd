extends Node
## Global configuration constants for Falcao Saga

# Supabase
const SUPABASE_URL = "http://supabasekong-zurmq2lrm9hj510fmnj1seqr.31.97.49.146.sslip.io"
const SUPABASE_ANON_KEY = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBhYmFzZSIsImlhdCI6MTc4NTI1MjYwMCwiZXhwIjo0OTQwOTI2MjAwLCJyb2xlIjoiYW5vbiJ9.WoeLAuy5jLAlVVQfKJKIIrb870Bt3ZwKtmyBvvksLBY"

# Game
const GAME_NAME = "Falcao Saga"
const GAME_VERSION = "1.0.0"
const GRID_COLS = 8
const GRID_ROWS = 8
const CELL_SIZE = 72
const MAX_LIVES = 5
const LIFE_REGEN_MINUTES = 20
const INITIAL_COINS = 500

# XP
const XP_PER_LEVEL = 10
const XP_BONUS_3STAR = 20
const XP_COMBO_4 = 5
const XP_COMBO_5 = 15
const XP_NEW_CARD = 50
const XP_SEASON_COMPLETE = 500

# Coins
const COINS_PER_LEVEL = 20
const COINS_BONUS_3STAR = 30
const COINS_DUPLICATE_COMMON = 10
const COINS_DUPLICATE_RARE = 25
const COINS_DUPLICATE_EPIC = 50
const COINS_DUPLICATE_LEGENDARY = 100
const COINS_DUPLICATE_MYTHIC = 200

# RPP
const RPP_SEASON_100 = 100
const RPP_TOP10_WEEKLY = 50
const RPP_TOP10_MONTHLY = 200
const RPP_LOGIN_30 = 30
const RPP_WINSTREAK_10 = 20
const RPP_REFERRAL = 50

# Rarity (use int constants)
const RARITY_COMMON = 0
const RARITY_RARE = 1
const RARITY_EPIC = 2
const RARITY_LEGENDARY = 3
const RARITY_MYTHIC = 4

static func get_rarity_color(rarity: int) -> Color:
	match rarity:
		0: return Color.GRAY
		1: return Color.DODGER_BLUE
		2: return Color.MEDIUM_PURPLE
		3: return Color.GOLD
		4: return Color.HOT_PINK
	return Color.GRAY

static func get_rarity_name(rarity: int) -> String:
	match rarity:
		0: return "Common"
		1: return "Rare"
		2: return "Epic"
		3: return "Legendary"
		4: return "Mythic"
	return "Common"

static func get_drop_rate(rarity: int) -> int:
	match rarity:
		0: return 50
		1: return 30
		2: return 13
		3: return 5
		4: return 2
	return 50

# Item Types
enum ItemType { BALL, EAGLE, STADIUM, JERSEY, TROPHY, STAR }

static func get_item_color(item: ItemType) -> Color:
	match item:
		ItemType.BALL: return Color(0.0, 0.41, 0.22)
		ItemType.EAGLE: return Color(0.89, 0.68, 0.0)
		ItemType.STADIUM: return Color(0.3, 0.3, 0.35)
		ItemType.JERSEY: return Color(1.0, 1.0, 1.0)
		ItemType.TROPHY: return Color(0.85, 0.65, 0.13)
		ItemType.STAR: return Color(1.0, 0.84, 0.0)
	return Color.WHITE

# Seasons
static func get_season_config() -> Array:
	return [
		{ "id": 1, "name": "Super League", "years": "2024-2026", "color": Color.GREEN, "count": 15 },
		{ "id": 2, "name": "Liga 1 Modern", "years": "2021-2023", "color": Color.GREEN, "count": 15 },
		{ "id": 3, "name": "Debut Liga 1", "years": "2018-2020", "color": Color.GREEN, "count": 15 },
		{ "id": 4, "name": "ISC B & Liga 2", "years": "2015-2017", "color": Color.GREEN, "count": 15 },
		{ "id": 5, "name": "Juara Umum", "years": "2012-2014", "color": Color.GOLDENROD, "count": 15 },
		{ "id": 6, "name": "Profesional Awal", "years": "2008-2011", "color": Color.GOLDENROD, "count": 15 },
		{ "id": 7, "name": "Gempa & Maguwoharjo", "years": "2005-2007", "color": Color.GOLDENROD, "count": 15 },
		{ "id": 8, "name": "Puncak Prestasi", "years": "2001-2004", "color": Color.ORANGE, "count": 15 },
		{ "id": 9, "name": "Promosi DU", "years": "1996-2000", "color": Color.ORANGE, "count": 15 },
		{ "id": 10, "name": "Dominasi Div II", "years": "1990-1995", "color": Color.ORANGE, "count": 15 },
		{ "id": 11, "name": "Fondasi", "years": "1983-1989", "color": Color.RED, "count": 15 },
		{ "id": 12, "name": "Legenda 1976", "years": "1976-1982", "color": Color.RED, "count": 15 },
	]
