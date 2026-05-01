# BearViSor

An AI-powered academic advising platform that helps students navigate course logistics, plan their academic journey, and explore career pathways all through intelligent, context-aware conversations.

## Overview
 
**BearViSor** is a web application that brings together specialized AI agents to support students throughout their academic experience. By combining real-time access to student records with comprehensive university data, BearViSor delivers personalized guidance for course selection, degree progress, scheduling, and career planning.
 
Whether a student is mapping out next semester, exploring a new major, or trying to understand prerequisite chains, BearViSor provides answers grounded in their actual academic history and the university's catalog.
 
## Key Features
 
### Advisor Chat
 
A unified chat interface where students can seamlessly switch between two purpose-built AI agents depending on what they need.
 
#### Advising Agent
The Advising Agent acts as a personal academic advisor. It connects directly to the student database to retrieve a student's academic history and uses that context to deliver tailored guidance.
 
Capabilities include:
- Reviewing completed and in-progress coursework
- Analyzing GPA trends across terms
- Tracking credit accumulation and degree progress
- Recommending courses for upcoming semesters based on the student's trajectory
- Answering career-related questions in the context of the student's academic profile

#### Catalog Agent
The Catalog Agent serves as an expert on the university's structure and offerings. It queries a comprehensive database of institutional information to answer questions about anything the university has to offer.
 
Knowledge domains include:
- **Courses**: descriptions, prerequisites, credit hours, and offerings
- **Departments**: programs, requirements, and specializations
- **Colleges & Schools**: for example, the School of Computer, Mathematics, and Natural Sciences
- **Professors**: faculty information and course associations
- And more across the academic catalog

### Builder
 
The Builder feature is powered by a dedicated AI agent that constructs personalized course schedules. It pulls from the student's academic history and accepts custom input, preferences, constraints, target courses, time-of-day preferences to assemble a schedule tailored to the individual.
 
This goes beyond static degree audits by combining what a student has already done with what they want to do next, producing actionable schedule recommendations.
 
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
- Gemini model `gemini-2.5-flash` for the ADK agent
- Google Agent Development Kit (ADK) with `AdkApp` from `vertexai.agent_engines`

**Auth & Sessions**
- SHA-256 password hashing (`hashlib`)
- Cryptographic tokens (`secrets.token_urlsafe`) stored as SHA-256 digests
- HTTP-only session cookies issued on login

## Database

The database is designed in such a way to store as much relevant information as possible about a university system. Many tables are interconnected in some way in order to achieve the network structure of the unversity system such as Colleges > Departments > (Courses, Staff) ; Courses > Sections > Section Meetings, etc..

## Agent

Unlike traditional ways of inputting data to an agent via a massive text files full of information, our agents are designed in a way that minimizes hallucination rates. By providing the agents with tools that can directly query a database, it is able to extract exact bits of information on demand without having to read a massive file with unnecessary information. This optimization also provides a performance boost, lowering overall response times to about ~4s. 

**Tools**
- **course_info**: Returns information about a course and sections for when the course is offered given it's code (ex. COSC 111)
- **course_info_name**: Returns information about a course given it's name. (ex. Introduction to Computer Science I)
- **courses_by_department**: Returns a list of courses given a department code. (ex. COSC)
- **courses_by_department_name**: Returns a list of courses given a department name. (ex. Computer Science)

- **department_info**: Returns information about a department given it's code. It provides information such as department name, description, and department staff like the chair.
- **department_info_name**: Returns a list of departments.
- **staff_info**: Returns information about a staff member.
- **department_staff**: Returns a list of staff given a department name

- **get_user_stats**: Returns information about the user such as GPA, Credits, Course History (grades, term included), and Current Enrollments.

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
   It is recommended that a python virtual environment is used when attempting to install dependancies such as `google-adk` to prevent any installation issues on the global environment. 

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

   OR run for dev environment:

   ```
   cd src
   fastapi dev
   ```

6. **Open the site in your browser:**

   - Landing page: http://127.0.0.1:8000/
   - Login: http://127.0.0.1:8000/login
   - Signup: http://127.0.0.1:8000/signup
   - Dashboard: http://127.0.0.1:8000/dashboard
   - Admin panel: http://127.0.0.1:8000/panel
   - Auto-generated API docs: http://127.0.0.1:8000/docs