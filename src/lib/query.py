import vertexai
from vertexai.generative_models import GenerativeModel

PROJECT_ID = 'project-d4c985c2-9db2-4bb7-a6c'
LOCATION = 'us-central1'

vertexai.init(project=PROJECT_ID, location=LOCATION)

model = GenerativeModel("gemini-2.0-flash-001")

def query_gemini(prompt: str):
    response = model.generate_content(prompt)

    return response
