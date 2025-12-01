# chatbot.py
import streamlit as st
import pickle
import pandas as pd
import nltk
import string
from nltk.corpus import stopwords
from sklearn.metrics.pairwise import cosine_similarity
import requests
import json
import time

# ------------------------------
# CONFIG: set your Groq key here
# ------------------------------
import os
GROQ_API_KEY = os.getevn("GROQ_API_KEY")
GROQ_URL = "https://api.groq.com/openai/v1/chat/completions"
GROQ_MODEL = "llama-3.1-8b-instant"

# ------------------------------
# Utility - AI call to Groq (with error handling)
# ------------------------------
def ai_reply(prompt, history=None):
    messages = [{"role": "system", "content": "You are a friendly career guidance assistant. Keep replies concise and helpful."}]
    if history:
        messages += history
    messages.append({"role": "user", "content": prompt})

    headers = {
        "Authorization": f"Bearer {GROQ_API_KEY}",
        "Content-Type": "application/json"
    }
    data = {
        "model": GROQ_MODEL,
        "messages": messages,
        "temperature": 0.35,
        "max_tokens": 512
    }

    resp = requests.post(GROQ_URL, headers=headers, json=data, timeout=30)
    try:
        result = resp.json()
    except Exception as e:
        st.write("❌ Groq returned non-JSON response.", resp.text)
        return "Sorry — the AI returned a bad response.", history

    if "choices" not in result:
        # Show API error to the user (useful debugging info)
        st.write("❌ Groq Error:", result)
        return "Sorry — the AI couldn't produce a response due to an API error.", history

    ai_text = result["choices"][0]["message"]["content"]

    if history is None:
        history = []
    # store simplified history for context (not huge)
    history.append({"role": "user", "content": prompt})
    history.append({"role": "assistant", "content": ai_text})

    return ai_text, history

# ------------------------------
# Load TF-IDF and dataset
# ------------------------------
tfidf = pickle.load(open("tfidf.pkl", "rb"))
career_df = pickle.load(open("career_df.pkl", "rb"))

# Auto-detect columns for title & description
# We try several common names for human-readable columns.
possible_title_cols = ["name", "title", "career", "Career", "Course", "course", career_df.columns[0]]
possible_desc_cols = ["desc", "description", "details", "purpose statement", "purpose", "Purpose statement", "Purpose", "purpose_statement"]

title_col = None
desc_col = None

for c in career_df.columns:
    if title_col is None and any(x.lower() in c.lower() for x in possible_title_cols):
        title_col = c

for c in career_df.columns:
    if desc_col is None and any(x.lower() in c.lower() for x in possible_desc_cols):
        desc_col = c

# fallback: use first two columns if detection fails
if title_col is None:
    title_col = career_df.columns[0]
if desc_col is None:
    # prefer a long text-like column (largest average length)
    lengths = {c: career_df[c].astype(str).map(len).mean() for c in career_df.columns}
    desc_col = max(lengths, key=lengths.get)

# Make sure we have clean_desc (create if not present)
if "clean_desc" not in career_df.columns:
    nltk.download("stopwords", quiet=True)
    stop_words = set(stopwords.words("english"))

    def clean_text_local(text):
        text = str(text).lower()
        text = text.translate(str.maketrans("", "", string.punctuation))
        tokens = text.split()
        tokens = [w for w in tokens if w not in stop_words]
        return " ".join(tokens)

    career_df["clean_desc"] = career_df[desc_col].fillna("").apply(clean_text_local)
else:
    def clean_text_local(text):
        text = str(text).lower()
        text = text.translate(str.maketrans("", "", string.punctuation))
        tokens = text.split()
        return " ".join(tokens)

# ------------------------------
# Styling: CSS for bubbles & avatars
# ------------------------------
st.markdown(
    """
    <style>
    .chat-container { max-width: 800px; margin: 0 auto; font-family: 'Inter', sans-serif; }
    .bubble { padding: 12px 16px; border-radius: 16px; margin: 8px 0; display: inline-block; max-width: 78%; }
    .user { background: linear-gradient(135deg,#f6d365,#fda085); color: #111; float: right; border-bottom-right-radius: 4px;}
    .assistant { background: linear-gradient(135deg,#c3ecff,#89f7fe); color: #022; float: left; border-bottom-left-radius: 4px;}
    .meta { font-size: 12px; color: #666; margin-top: 4px; clear: both; }
    .avatar { width: 36px; height: 36px; border-radius: 50%; display:inline-block; vertical-align: middle; margin-right:8px;}
    .assistant-row { display:flex; align-items:flex-start; gap:8px; }
    .user-row { display:flex; align-items:flex-start; flex-direction:row-reverse; gap:8px; }
    .clear { clear: both; }
    .btn-grid { display:flex; gap:8px; flex-wrap:wrap; margin-top:8px; }
    .small-btn { padding:8px 12px; border-radius:8px; border:none; cursor:pointer; background:#eee; }
    .restart { background:#ff6b6b; color:white; padding:8px 12px; border-radius:10px; border:none; cursor:pointer;}
    </style>
    """,
    unsafe_allow_html=True
)

# ------------------------------
# Session state initialization
# ------------------------------
if "profile" not in st.session_state:
    st.session_state.profile = {
        "passion": None,
        "strength": None,
        "preference": None,
        "task_style": None,
        "value": None
    }
if "current_question_key" not in st.session_state:
    st.session_state.current_question_key = None
if "messages" not in st.session_state:
    st.session_state.messages = []   # stores dicts {"role":..,"content":..}
if "mode" not in st.session_state:
    st.session_state.mode = "interview"
if "history" not in st.session_state:
    st.session_state.history = []

# ------------------------------
# Questions & buttons map
# ------------------------------
QUESTIONS = {
    "passion": "What type of work excites you the most?",
    "strength": "What skills or strengths do you feel most confident in?",
    "preference": "Do you prefer working more with data, ideas, people, or technology?",
    "task_style": "Do you enjoy structured tasks or open-ended creative work?",
    "value": "What do you value more: stability, creativity, income, or social impact?"
}

# For certain questions present quick-choice buttons
CHOICES = {
    "preference": ["data", "ideas", "people", "technology"],
    "task_style": ["structured", "open-ended"],
    "value": ["stability", "creativity", "income", "social impact"]
}

def get_next_question(profile):
    for key, value in profile.items():
        if value is None:
            return key, QUESTIONS[key]
    return None, None

# ------------------------------
# UI header with restart
# ------------------------------
st.title("Career Guidance Chatbot — polished")
st.write("Free offline TF-IDF matching + Groq LLaMA-3 explanations (buttons, avatars, styled bubbles)")

# restart button
col1, col2 = st.columns([1,4])
with col1:
    if st.button("🔄 Restart", key="restart_btn"):
        # reset relevant session state keys
        st.session_state.profile = {k: None for k in st.session_state.profile}
        st.session_state.current_question_key = None
        st.session_state.messages = []
        st.session_state.mode = "interview"
        st.session_state.history = []
        st.experimental_rerun()
with col2:
    st.write("")

# initialize first message
if len(st.session_state.messages) == 0:
    first_key, first_q = get_next_question(st.session_state.profile)
    st.session_state.current_question_key = first_key
    # push the plain question (we will style it when rendering)
    st.session_state.messages.append({"role": "assistant", "content": first_q})

# Helper: render message as styled bubble
def render_message(msg):
    role = msg.get("role", "assistant")
    content = msg.get("content", "")
    if role == "assistant":
        html = f"""
        <div class='assistant-row'>
          <img class='avatar' src='https://api.dicebear.com/7.x/initials/svg?seed=AI' alt='avatar'/>
          <div class='bubble assistant'>{content}</div>
        </div>
        <div class='clear'></div>
        """
    else:
        html = f"""
        <div class='user-row'>
          <img class='avatar' src='https://api.dicebear.com/7.x/initials/svg?seed=You' alt='avatar'/>
          <div class='bubble user'>{content}</div>
        </div>
        <div class='clear'></div>
        """
    st.markdown(html, unsafe_allow_html=True)

# display chat history
for m in st.session_state.messages:
    render_message(m)

# Input area: either buttons (if question has choices) OR chat_input
current_key = st.session_state.current_question_key

if st.session_state.mode == "interview":
    if current_key in CHOICES:
        # show buttons for choices
        st.markdown("**Choose an option:**")
        cols = st.columns(len(CHOICES[current_key]))
        for i, opt in enumerate(CHOICES[current_key]):
            if cols[i].button(opt.capitalize()):
                # when user selects option
                st.session_state.messages.append({"role": "user", "content": opt})
                st.session_state.profile[current_key] = opt

                # decide next question
                next_key, next_q = get_next_question(st.session_state.profile)
                st.session_state.current_question_key = next_key

                if next_key is None:
                    st.session_state.mode = "recommend"
                else:
                    # show smallest spinner while generating
                    with st.spinner("AI is thinking..."):
                        ai_text, st.session_state.history = ai_reply(
                            f"Please ask the user this question politely: {next_q}",
                            st.session_state.history
                        )
                    st.session_state.messages.append({"role": "assistant", "content": ai_text})
                    st.rerun()   # re-render to show new messages

    else:
        # fallback: free text input
        user_text = st.text_input("Type your answer and press Enter", key="free_input")
        if user_text:
            st.session_state.messages.append({"role": "user", "content": user_text})
            st.session_state.profile[current_key] = user_text

            next_key, next_q = get_next_question(st.session_state.profile)
            st.session_state.current_question_key = next_key

            if next_key is None:
                st.session_state.mode = "recommend"
            else:
                with st.spinner("AI is thinking..."):
                    ai_text, st.session_state.history = ai_reply(
                        f"Please ask the user this question politely: {next_q}",
                        st.session_state.history
                    )
                st.session_state.messages.append({"role": "assistant", "content": ai_text})
                st.rerun()

# Recommendation stage
if st.session_state.mode == "recommend":
    # generate top match
    user_text = " ".join([str(v) for v in st.session_state.profile.values()])
    # clean minimal
    user_text_clean = user_text.lower().translate(str.maketrans("", "", string.punctuation))

    user_vec = tfidf.transform([user_text_clean])
    career_vecs = tfidf.transform(career_df["clean_desc"])
    scores = cosine_similarity(user_vec, career_vecs)[0]
    idx = int(scores.argmax())
    best_title = str(career_df.iloc[idx][title_col])
    best_desc = str(career_df.iloc[idx][desc_col])

    # Display result with explanation from AI
    st.markdown("---")
    st.markdown(f"## 🎓 Recommended: **{best_title}**")
    st.markdown(f"**Description (from dataset):**\n\n{best_desc}")

    # AI explanation (friendly)
    explanation_prompt = f"User profile: {user_text}. Explain simply and kindly why '{best_title}' is a suitable career. Also give 3 practical next steps the user can take to learn more or prepare."
    with st.spinner("Generating friendly explanation..."):
        explanation, st.session_state.history = ai_reply(explanation_prompt, st.session_state.history)

    st.markdown("**AI explanation & next steps:**")
    st.markdown(explanation)

    # final: offer restart
    if st.button("🔄 Start a new recommendation"):
        st.session_state.profile = {k: None for k in st.session_state.profile}
        st.session_state.current_question_key = None
        st.session_state.messages = []
        st.session_state.mode = "interview"
        st.session_state.history = []
        st.rerun()

