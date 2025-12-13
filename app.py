import os
import time
import logging
from flask import Flask, render_template, request, jsonify
from flask_mysqldb import MySQL
from MySQLdb import OperationalError
# --------------------
# Logging (Kubernetes friendly)
# --------------------
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')
app = Flask(__name__)
# --------------------
# Load DB config safely
# --------------------
required_env = ["MYSQL_HOST", "MYSQL_USER", "MYSQL_PASSWORD", "MYSQL_DB"]
# Check for missing variables log them (using warning to allow app to start even if config is bad)
missing_vars = [env for env in required_env if not os.environ.get(env)]
if missing_vars:
    logging.error(f"Missing required environment variables: {missing_vars}")
app.config['MYSQL_HOST'] = os.getenv('MYSQL_HOST')
app.config['MYSQL_USER'] = os.getenv('MYSQL_USER')
app.config['MYSQL_PASSWORD'] = os.getenv('MYSQL_PASSWORD')
app.config['MYSQL_DB'] = os.getenv('MYSQL_DB')
# Convert port to int, default to 3306 if missing
app.config['MYSQL_PORT'] = int(os.getenv('MYSQL_PORT', 3306))
mysql = MySQL(app)
# --------------------
# Safe DB Connect Helper (Retry Logic)
# --------------------
def get_db_cursor(retries=10, delay=5):
    """
    Ensures the pod does NOT crash if RDS is temporarily unreachable.
    Retries connection instead of failing immediately.
    """
    for attempt in range(1, retries + 1):
        try:
            # In flask_mysqldb, accessing .connection triggers the connect attempt
            # If we are in an app_context, this should work or raise an exception.
            if not mysql.connection:
                 # This might happen if context is missing, but we handle it now.
                 raise OperationalError("MySQL connection object is None (check app context).")
            cur = mysql.connection.cursor()
            return cur
        except OperationalError as e:
            logging.warning(f"[Attempt {attempt}/{retries}] MySQL connection failed: {e}")
            time.sleep(delay)
        except Exception as e:
            logging.error(f"Unexpected DB error: {e}")
            time.sleep(delay)
    logging.error("Max retries reached. Could not connect to DB.")
    return None
# --------------------
# Initialize DB one time
# --------------------
def init_db():
    cur = get_db_cursor()
    if cur is None:
        logging.error("Skipping DB initialization due to no DB connection.")
        return
    try:
        cur.execute("""
        CREATE TABLE IF NOT EXISTS messages (
            id INT AUTO_INCREMENT PRIMARY KEY,
            message TEXT
        );
        """)
        mysql.connection.commit()
        logging.info("Database initialized successfully.")
    except Exception as e:
        logging.error(f"DB initialization error: {e}")
    finally:
        if cur:
            cur.close()
# --------------------
# Routes
# --------------------
@app.route('/')
def hello():
    cur = get_db_cursor()
    if cur is None:
        return "Database unavailable. Try again later.", 503
    cur.execute("SELECT message FROM messages")
    messages = cur.fetchall()
    cur.close()
    return render_template('index.html', messages=messages)
@app.route('/submit', methods=['POST'])
def submit():
    new_message = request.form.get('new_message')
    cur = get_db_cursor()
    if cur is None:
        return jsonify({"error": "Database unavailable"}), 503
    cur.execute("INSERT INTO messages (message) VALUES (%s)", [new_message])
    mysql.connection.commit()
    cur.close()
    return jsonify({'message': new_message})
# --------------------
# Application Start
# --------------------
if __name__ == '__main__':
    # CRITICAL FIX: Wrap init_db in app_context so mysql.connection works
    with app.app_context():
        init_db()
    app.run(host='0.0.0.0', port=5000)
