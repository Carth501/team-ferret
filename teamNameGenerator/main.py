import json
import random
import os

def load_words(filename):
    try:
        with open(filename, 'r', encoding='utf-8') as file:
            return json.load(file)
    except Exception as e:
        print(f"Error loading JSON file: {e}")
        return None

def generate_team_name(words):
    if words is not None:
        return f"{random.choice(words['T1'])} {random.choice(words['O'])} {random.choice(words['T2'])} {random.choice(words['S'])}"
    else:
        return "Error: Word list is empty."

def main():
    script_dir = os.path.dirname(__file__)
    filename = os.path.join(script_dir, 'words.json')
    words = load_words(filename)
    team_name = generate_team_name(words)
    print("Team Name:", team_name)

if __name__ == "__main__":
    main()
