# BearViSor AI

## Description

Bearvisor-AI is an academic advising agent that automatically makes course recommendations based on the current degree completion status of a particular student. Students will be able to connect their Degree Works to the advising agent and ask for feedback and course recommendations. This AI agent can be deployed in cases where academic advisors are too overwhelmed during the registration season. The agent will only serve as a substitute as a fail-safe due to AI hallucinations. An academic advisor will still step in and review the advice given by the agent and greenlight course schedules generated. This tool is only meant as an aid to both academic advisors and students, not as a replacement to the entire process.

## Advising

The agent will be able to automatically schedule appointments with advisors on the users request, automatically checking availability and selecting the next best date. The student will be able to provide their schedule in order to help the agent select a time that does not conflict with other tasks. A confirmation request will be sent to the user before the agent schedules the appointment and sends the details to the advisor. In the case where appointments need to be rescheduled, upon notification to the agent, the agent will immediately select the next best date (still using the information provided previously by the user) to schedule the next best appointment.

## Course Selection

The agent will be equipped with a module to generate degree plans and course schedules during the registration period to aid students in finding an optimal path to degree completion. The agent will be able to send these generated course schedules to advisors for review through a similar portal the students use. Faculty will be able to log in and review the generated schedules and either accept them or deny them with a specific reason. The agent will use the reasoning provided by staff in order to regenerate the schedule with the accommodations suggested. Upon reviewing and acceptance, the agent will be able to register the reviewed schedule automatically without human intervention. This process could greatly help pipeline the process of registration, and take a load of advisors back.

## GPA monitoring and prediction

The final module in the agent will be a GPA monitor and prediction model that will be able to forecast a person's GPA based on current and past course performance. It will be able to provide feedback and advice to a student on how to increase their GPA and what their maximum possible GPA could be provided ideal performance.

## Tech Stack

**Backend**
- Python 3.10+
- FastAPI (web framework)
- Uvicorn (ASGI server)
- Jinja2 (server-side HTML templating)
- Pydantic (request/response validation)

**Frontend**
- HTML rendered via Jinja2 templates (`src/pages/`)
- Vanilla CSS (`src/static/css/`)
- Vanilla JavaScript (`src/static/js/`)

**Database**
- SQLite (`db/database.db`) accessed via Python's built-in `sqlite3`
- Schema split across `db/schema/*.sql` and aggregated in `db/schema.sql`

**AI / Agent**
- Google Cloud Vertex AI
- Gemini models (`gemini-2.0-flash-001` for direct queries, `gemini-2.5-flash` for the ADK agent)
- Google Agent Development Kit (ADK) with `AdkApp` from `vertexai.agent_engines`

**Auth & Sessions**
- SHA-256 password hashing (`hashlib`)
- Cryptographic tokens (`secrets.token_urlsafe`) stored as SHA-256 digests
- HTTP-only session cookies issued on login

## Setup & Running the Webpage

### Prerequisites

1. **Python 3.10+** (the codebase uses modern type hints like `str | None`).
2. **Git**.
3. **Google Cloud SDK** installed and authenticated, since `src/lib/query.py` and `src/agent/agent.py` use Vertex AI. Authenticate with:

   ```
   gcloud auth application-default login
   ```

   Make sure the project ID in `src/lib/query.py` and `src/agent/agent.py` (`project-d4c985c2-9db2-4bb7-a6c`) matches a GCP project you have access to with Vertex AI enabled.

### Step-by-step setup

1. **Clone the repository and open a terminal at the repo root:**

   ```
   git clone <repo-url>
   cd cosc-490-senior-project-team-3
   ```

2. **Create and activate a virtual environment:**

   ```
   python -m venv .venv
   ```

   Then activate it for your platform:

   - Windows (PowerShell): `.venv\Scripts\Activate.ps1`
   - Windows (cmd): `.venv\Scripts\activate.bat`
   - macOS / Linux: `source .venv/bin/activate`

   (`.venv` is already in `.gitignore`.)

3. **Install dependencies.** The root `requirements.txt` is incomplete, so install at minimum:

   ```
   pip install "fastapi[standard]" uvicorn jinja2 pydantic
   pip install google-cloud-aiplatform vertexai google-genai google-adk
   ```

4. **Verify the database is in place.** `db/database.db` exists in the repo, and `src/lib/database.py` will run `db/schema.sql` on startup to ensure tables exist. If you want fresh data, you can call the `populate_db()` helper in `src/lib/database.py` (loads `db/populate.sql`).

5. **Run the server.** The imports in `src/main.py` are package-relative (`from pages.router import router`, etc.), so you must launch from inside the `src/` directory:

   ```
   cd src
   uvicorn main:app --reload --host 127.0.0.1 --port 8000
   ```

6. **Open the site in your browser:**

   - Landing page: http://127.0.0.1:8000/
   - Login: http://127.0.0.1:8000/login
   - Signup: http://127.0.0.1:8000/signup
   - Dashboard: http://127.0.0.1:8000/dashboard
   - Admin panel: http://127.0.0.1:8000/panel
   - Auto-generated API docs: http://127.0.0.1:8000/docs

