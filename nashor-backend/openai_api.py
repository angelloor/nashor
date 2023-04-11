import openai

API_KEY = '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'

openai.api_key = API_KEY


model = 'text-davinci-003'

response = openai.Completion.create(
    prompt = 'How big is the moon',
    model=model
)
print(response)