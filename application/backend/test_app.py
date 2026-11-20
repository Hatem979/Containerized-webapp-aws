
import os

# Force tests to use an isolated in-memory SQLite database.
# This prevents tests from connecting to AWS RDS.
os.environ["DATABASE_URL"] = "sqlite://"

from app import app, db
import pytest


@pytest.fixture()
def client():
    app.config.update(TESTING=True)

    with app.app_context():
        db.drop_all()
        db.create_all()

    with app.test_client() as client:
        yield client

    with app.app_context():
        db.session.remove()
        db.drop_all()


def test_health_check(client):
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json == {"status": "healthy"}


def test_get_empty_tasks(client):
    response = client.get("/api/tasks")

    assert response.status_code == 200
    assert response.json == []


def test_create_task(client):
    response = client.post(
        "/api/tasks",
        json={"title": "Learn CI/CD"}
    )

    assert response.status_code == 201
    assert response.json["title"] == "Learn CI/CD"
    assert response.json["completed"] is False
    assert "id" in response.json


def test_create_task_without_title(client):
    response = client.post(
        "/api/tasks",
        json={}
    )

    assert response.status_code == 400
    assert response.json["error"] == "Task title is required"


def test_update_task(client):
    create_response = client.post(
        "/api/tasks",
        json={"title": "Test Update"}
    )

    task_id = create_response.json["id"]

    response = client.put(
        f"/api/tasks/{task_id}",
        json={"completed": True}
    )

    assert response.status_code == 200
    assert response.json["completed"] is True


def test_delete_task(client):
    create_response = client.post(
        "/api/tasks",
        json={"title": "Test Delete"}
    )

    task_id = create_response.json["id"]

    response = client.delete(f"/api/tasks/{task_id}")

    assert response.status_code == 200
    assert response.json == {"message": "Task deleted"}

    get_response = client.get("/api/tasks")

    assert get_response.json == []


def test_update_nonexistent_task(client):
    response = client.put(
        "/api/tasks/999",
        json={"completed": True}
    )

    assert response.status_code == 404


def test_delete_nonexistent_task(client):
    response = client.delete("/api/tasks/999")

    assert response.status_code == 404
