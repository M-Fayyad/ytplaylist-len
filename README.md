# YouTube Playlist Length

Analyze YouTube playlists and videos with ease. Get detailed information about video durations, playlist lengths, and plan your watch schedule. Hosted at [ytplaylist-len.sharats.dev](https://ytplaylist-len.sharats.dev/).

## Features

- Analyze multiple playlists and individual videos in one request (up to 5)
- Calculate total duration at 1.25x, 1.50x, 1.75x, 2.00x and custom speeds
- Analyze specific video ranges within playlists (up to 500 videos)
- **Watch Schedule calculator** — enter hours per day + which days of the week you watch, get a real finish date and progress ring
- **Full internationalization** into 27 languages (URL-prefixed with `/es/`, `/fr/`, `/ja/`, `/ta/`, `/bn/`, etc. and `hreflang` alternates for SEO)
- **YouTube Thumbnail Downloader** at `/thumbnails`
- **YouTube Timestamp Link Generator** at `/timestamp`
- Redis-backed caching (24h TTL) and parallel async YouTube API calls
- Persistent request analytics with MongoDB


## Getting Started

You can run the application either using **Docker Compose** (recommended for production and zero-dependency local runs) or directly with **Python**.

### Option A: Running with Docker (Recommended)

Prerequisites: [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/).

1. **Clone the repository:**
```bash
git clone https://github.com/M-Fayyad/ytplaylist-len.git
cd ytplaylist-len
```


2. **Set up environment variables:**
```bash
cp .env.example .env

```


Edit `.env` and add your YouTube Data API v3 key:
```env
APIS=your_youtube_api_key
BASE_URL=http://localhost:8000

```


> You can supply multiple API keys separated by `;` (e.g. `key1;key2`) to distribute quota usage across hours.


3. **Start the stack:**
```bash
docker compose up -d --build

```


This spins up:
* **FastAPI Web App** on port `8000`
* **Redis 7** (with data persistence & health checks)
* **MongoDB 7** (with persistent volume & health checks)


4. Open `http://localhost:8000`.

To view logs:

```bash
docker compose logs -f web

```

To stop all services:

```bash
docker compose down

```

---

### Option B: Local Setup (Without Docker)

Prerequisites: Python 3.13, Redis, and MongoDB running locally.

1. **Clone and install dependencies:**
```bash
git clone https://github.com/M-Fayyad/ytplaylist-len.git
cd ytplaylist-len
pip install -r requirements.txt

```


2. **Configure `.env`:**
```env
APIS=your_youtube_api_key
REDIS_URL=redis://localhost:6379
MONGO_URL=mongodb://localhost:27017
BASE_URL=http://localhost:8000

```


3. **Run the development server:**
```bash
fastapi dev app.py

```


Then open `http://localhost:8000`.

---

## Tests

Install dev dependencies and run the offline unit tests (no YouTube API key required):

```bash
pip install -r requirements-dev.txt
pytest

```

Offline tests cover URL/ID parsing (`get_id`, `get_item_ids`), utility helpers (`extract_video_id`, `parse`, `pick_api_key`), and playlist range / video-order logic using mocked API responses.

### Online integration tests

With a real `APIS` key in `.env`, run live tests against the YouTube Data API:

```bash
pytest --run-online

```

Optional env overrides:

```bash
YOUTUBE_TEST_VIDEO_ID=dQw4w9WgXcQ
YOUTUBE_TEST_PLAYLIST_ID=PLxxxxxxxx   # skip auto-discovery when set

```

---

## Project Structure

```text
├── Dockerfile                 Production-ready container definition (Python 3.13-slim)
├── docker-compose.yml         Multi-container orchestration (Web, Redis, MongoDB)
├── .dockerignore              Excludes cache, virtual environments, and sensitive files
├── .env.example               Environment configuration template
├── app.py                     FastAPI app: routes, i18n middleware, sitemap, gzip
├── src/
│   ├── i18n.py                Locale loader + translator factory
│   ├── blog.py                Markdown blog post loader
│   ├── itemlist.py            Playlist/video parsing entry point
│   ├── playlist.py            Playlist API + Redis cache
│   ├── video.py               Video model
│   └── utils.py               YouTube API + duration helpers
├── locales/                   27 JSON translation files
├── content/blog/en/           Blog posts (Markdown + YAML frontmatter)
├── templates/
│   ├── base.html              Shared layout, SEO, JSON-LD
│   ├── home.html              Playlist calculator + schedule + FAQ + HowTo
│   ├── thumbnails.html        Thumbnail downloader
│   ├── timestamp.html         Timestamp link generator
│   └── blog/                  Blog list + post templates
├── static/
│   ├── favicon.png, logo.png
│   ├── form_validation.js     Inline form validation
│   └── js/schedule.js         Client-side reactive watch schedule calculator
└── tests/                     pytest unit tests (input parsing, utils, playlist logic)

```

---

## Adding a Language

1. Copy `locales/en.json` to `locales/xx.json`.
2. Translate the values (keep keys unchanged).
3. Add a `LocaleInfo` entry to `SUPPORTED_LOCALES` in `src/i18n.py`.
4. Restart the app. URL prefix routing and hreflang alternates will work automatically.

---

## Technologies

* [Python](https://www.python.org/?utm_source=gemini) 3.13
* [FastAPI](https://fastapi.tiangolo.com/?utm_source=gemini)
* [Docker](https://www.docker.com/?utm_source=gemini) & [Docker Compose](https://docs.docker.com/compose/?utm_source=gemini)
* [YouTube Data API v3](https://developers.google.com/youtube/v3?utm_source=gemini)
* [Jinja2](https://jinja.palletsprojects.com/?utm_source=gemini)
* [Tailwind CSS](https://tailwindcss.com/?utm_source=gemini) (CDN)
* [Redis](https://redis.io/?utm_source=gemini) — playlist caching
* [MongoDB](https://www.mongodb.com/?utm_source=gemini) — request analytics
* [Render](https://render.com/?utm_source=gemini) — hosting
