import os
import logging
import sys

from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate  

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s: %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)

logger = logging.getLogger(__name__)

app = Flask(__name__)

# Database configuration
app_env = os.getenv("APP_ENV", "development").lower()

database_url = os.getenv("DATABASE_URL")

if not database_url:
    db_host = os.getenv("DB_HOST")
    db_port = os.getenv("DB_PORT", "5432")
    db_name = os.getenv("DB_NAME")
    db_user = os.getenv("DB_USERNAME")
    db_password = os.getenv("DB_PASSWORD")

    if all([db_host, db_name, db_user, db_password]):
        from urllib.parse import quote_plus

        database_url = (
            f"postgresql+psycopg://{quote_plus(db_user)}:"
            f"{quote_plus(db_password)}@{db_host}:{db_port}/{db_name}"
        )

    elif app_env == "development":
        database_url = "sqlite:///tasks.db"

    else:
        raise RuntimeError(
            "Database configuration is missing in production"
        )

app.config["SQLALCHEMY_DATABASE_URI"] = database_url
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)


# Database Model
class Task(db.Model):
    __tablename__ = 'task'
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    completed = db.Column(db.Boolean, default=False)
    description = db.Column(db.String(500), nullable=True)


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "healthy"}), 200


# Get all tasks
@app.route("/api/tasks", methods=["GET"])
def get_tasks():
    try:
        tasks = Task.query.all()
        return jsonify([
            {
                "id": task.id,
                "title": task.title,
                "completed": task.completed
            }
            for task in tasks
        ]), 200
    except Exception as e:
        logger.exception("Error while fetching tasks")
        return jsonify({"error": "Internal server error"}), 500


# Create a task
@app.route("/api/tasks", methods=["POST"])
def create_task():
    logger.info("New task creation request received")
    
    data = request.get_json(silent=True) or {}
    title = data.get("title")

    if not isinstance(title, str) or not title.strip():
        return jsonify({"error": "Task title is required"}), 400

    try:
        new_task = Task(title=title.strip())
        db.session.add(new_task)
        db.session.commit()

        return jsonify({
            "id": new_task.id,
            "title": new_task.title,
            "completed": new_task.completed
        }), 201
    except Exception as e:
        db.session.rollback()
        logger.exception("Unexpected error while processing request")
        return jsonify({"error": "Internal server error"}), 500


# Update a task
@app.route("/api/tasks/<int:task_id>", methods=["PUT"])
def update_task(task_id):
    task = db.session.get(Task, task_id)

    if task is None:
        return jsonify({"error": "Task not found"}), 404

    data = request.get_json(silent=True) or {}

    if "completed" in data:
        if not isinstance(data["completed"], bool):
            return jsonify({"error": "completed must be true or false"}), 400
        task.completed = data["completed"]

    try:
        db.session.commit()
        return jsonify({
            "id": task.id,
            "title": task.title,
            "completed": task.completed
        }), 200
    except Exception as e:
        db.session.rollback()
        logger.exception("Error while updating task")
        return jsonify({"error": "Internal server error"}), 500


# Delete a task
@app.route("/api/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    task = db.session.get(Task, task_id)

    if task is None:
        return jsonify({"error": "Task not found"}), 404

    try:
        db.session.delete(task)
        db.session.commit()
        return jsonify({"message": "Task deleted"}), 200
    except Exception as e:
        db.session.rollback()
        logger.exception("Error while deleting task")
        return jsonify({"error": "Internal server error"}), 500


if __name__ == "__main__":
    debug_mode = os.getenv("FLASK_DEBUG", "false").lower() == "true"

    app.run(
        host="0.0.0.0",
        port=5000,
        debug=debug_mode
    )