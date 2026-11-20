const API_BASE = "/api";

// HTML elements
const taskForm = document.getElementById("task-form");
const taskInput = document.getElementById("task-input");
const taskList = document.getElementById("task-list");
const totalTasks = document.getElementById("total-tasks");
const completedTasks = document.getElementById("completed-tasks");
const emptyMessage = document.getElementById("empty-message");
const errorMessage = document.getElementById("error-message");

// Send HTTP requests to the Backend
async function apiRequest(endpoint, options = {}) {
    const response = await fetch(`${API_BASE}${endpoint}`, {
        ...options,
        headers: {
            "Content-Type": "application/json",
            ...options.headers
        }
    });

    const data = await response.json().catch(() => ({}));

    if (!response.ok) {
        throw new Error(data.error || `Request failed: ${response.status}`);
    }

    return data;
}

// Display tasks in the UI
function renderTasks(tasks) {
    // حماية تامة: التأكد أن tasks مصفوفة دائماً لتجنب خطأ filter is not a function
    if (!Array.isArray(tasks)) {
        tasks = [];
    }

    taskList.replaceChildren();

    totalTasks.textContent = tasks.length;

    const completedCount = tasks.filter(
        task => task.completed
    ).length;

    completedTasks.textContent = completedCount;
    emptyMessage.hidden = tasks.length > 0;

    tasks.forEach(task => {
        const item = document.createElement("div");
        item.className = "task-item";

        const title = document.createElement("span");
        title.className = "task-title";
        title.textContent = task.title;

        if (task.completed) {
            title.classList.add("completed");
        }

        const actions = document.createElement("div");
        actions.className = "task-actions";

        const completeButton = document.createElement("button");
        completeButton.className = "complete-btn";
        completeButton.textContent = task.completed
            ? "Undo"
            : "Complete";

        completeButton.addEventListener("click", () => {
            updateTask(task.id, !task.completed);
        });

        const deleteButton = document.createElement("button");
        deleteButton.className = "delete-btn";
        deleteButton.textContent = "Delete";

        deleteButton.addEventListener("click", () => {
            deleteTask(task.id);
        });

        actions.append(completeButton, deleteButton);
        item.append(title, actions);
        taskList.appendChild(item);
    });
}

// Get all tasks from Backend
async function loadTasks() {
    try {
        errorMessage.textContent = "";

        const data = await apiRequest("/tasks");
        // التأكد أن البيانات القادمة من الـ API مصفوفة صالحة
        const tasks = Array.isArray(data) ? data : [];
        renderTasks(tasks);
    } catch (error) {
        errorMessage.textContent = error.message;
        renderTasks([]); // عرض واجهة فارغة وسليمة حتى عند حدوث خطأ
    }
}

// Create a new task
async function addTask(event) {
    event.preventDefault();

    const title = taskInput.value.trim();

    if (!title) {
        return;
    }

    try {
        errorMessage.textContent = "";

        await apiRequest("/tasks", {
            method: "POST",
            body: JSON.stringify({ title })
        });

        taskInput.value = "";
        await loadTasks();
    } catch (error) {
        errorMessage.textContent = error.message;
    }
}

// Update task completion status
async function updateTask(taskId, completed) {
    try {
        errorMessage.textContent = "";

        await apiRequest(`/tasks/${taskId}`, {
            method: "PUT",
            body: JSON.stringify({ completed })
        });

        await loadTasks();
    } catch (error) {
        errorMessage.textContent = error.message;
    }
}

// Delete a task
async function deleteTask(taskId) {
    try {
        errorMessage.textContent = "";

        await apiRequest(`/tasks/${taskId}`, {
            method: "DELETE"
        });

        await loadTasks();
    } catch (error) {
        errorMessage.textContent = error.message;
    }
}

// Listen for form submission
taskForm.addEventListener("submit", addTask);

// Load tasks when the page opens
loadTasks();