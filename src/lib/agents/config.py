from google.genai import types

llm_model = 'gemini-2.5-flash'

generation_config = types.GenerateContentConfig(
    temperature=0.25,
    max_output_tokens=2500,
    top_p=0.95
)
