## Hi there 👋

<!--
**chidozinyakatira/chidozinyakatira** is a ✨ _special_ ✨ repository because its `README.md` (this file) appears on your GitHub profile.

Here are some ideas to get you started:

- 🔭 I’m currently working on ...
- 🌱 I’m currently learning ...
- 👯 I’m looking to collaborate on ...
- 🤔 I’m looking for help with ...
- 💬 Ask me about ...
- 📫 How to reach me: ...
- 😄 Pronouns: ...
- ⚡ Fun fact: ...
-->
Career Guidance Chatbot (NLP + LLM + Streamlit)

An intelligent career guidance chatbot built using Natural Language Processing, Recommendation Systems, and LLM-powered conversation.
This project collects a user’s preferences through a friendly interview-style chat, analyzes their responses, matches them to the most relevant academic programs, and provides personalized explanations using Groq LLaMA-3.1.

 Live Demo: []
 Repository: 

 Features
 AI Conversation (Groq LLaMA-3.1)

Asks follow-up questions politely

Generates friendly, clear explanations

Uses conversation history for contextual responses

100% free to run (using Groq API)

 NLP Career Matching

TF-IDF vectorization

Cosine similarity ranking

Auto-selection of dataset columns

Robust data cleaning & preprocessing (NLTK)

 Modern UI/UX with Streamlit

Colored chat bubbles

Avatars for user + AI

Loading animation during AI replies

Buttons for quick multiple-choice answers

Restart conversation button

Responsive layout

 Dataset Integration

Supports any dataset with:

Career/program title

Purpose/description column

Automatically detects best description column

Includes your uploaded .pkl dataset

 Tech Stack
Area	Tools
Frontend	Streamlit (custom HTML/CSS for chat UI)
Backend	Python
AI Engine	Groq LLaMA-3.1 (llama-3.1-8b-instant)
NLP	TF-IDF, NLTK
Data	pandas, pickle
Deployment	Streamlit Cloud / GitHub
 How It Works
1️ User Interview

The chatbot asks the user 5 structured questions:

Work interests

Strengths

Work preferences (data/ideas/people/tech)

Task style (structured vs creative)

Career values (stability, creativity, income, impact)

Users can answer via:

Text input

OR smart buttons (for selected questions)

2️ Profile Vectorization

All answers are combined and cleaned:

Lowercased

Punctuation removed

Stopwords removed

Then transformed using TF-IDF.

3️ Career Matching

Each career description in the dataset is vectorized.

Similarity is computed using:

cosine_similarity(user_profile, career_profiles)


The highest-scoring career is selected.

4️ Career Explanation

Groq LLaMA-3.1 is asked:

“Explain why this career is a good match for the user, and give 3 next steps.”

It generates a personalized, natural-language explanation.

5️ Display Results

The app shows:

✔ Recommended Career
✔ Description from your dataset
✔ AI-generated explanation
✔ Next recommended actions
✔ Option to restart the interview

 Installation

Clone the repository:

git clone https://github.com/chidoinyakatira/chidozinyakatira.git
cd YOUR_REPO


Install dependencies:

pip install -r requirements.txt


Run the Streamlit app:

streamlit run chatbot.py

🔐 Environment Variables

Create Streamlit Cloud secrets or a local .env file.

Set:

GROQ_API_KEY = your_api_key_here

 Project Structure
.
├── chatbot.py
├── tfidf.pkl
├── career_df.pkl
├── requirements.txt
└── README.md

 Sample Career Entry

From your dataset (career_df.pkl):

0  Higher Certificate in Banking (98225)
1  Higher Certificate in Economic and Management Sciences
2  Higher Certificate in Marketing
...


Includes program titles + long purpose statements.

 Future Improvements

Add top-3 career recommendations

Add sentiment analysis on user profile

Integrate a fine-tuned embedding model

Add user analytics dashboard

Allow export as PDF career report

 Why This Project Matters

This project showcases:

✔ NLP Skills

TF-IDF

similarity search

text cleaning

stopword removal

✔ LLM Integration

Groq’s ultra-fast inference

conversational AI

contextual reasoning

✔ Data Science + UX

Clean architecture

Interactive Streamlit UI

Real-world application

Perfect for jobs in:

Data Science

Machine Learning

AI Engineering

NLP

Data Engineering

 
