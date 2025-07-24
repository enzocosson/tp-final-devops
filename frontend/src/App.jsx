import { useEffect, useState } from "react";
import "./App.css";

const API_BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:3005";

const App = () => {
  const [count, setCount] = useState(0);
  const [todos, setTodos] = useState([]);
  const [newTodoText, setNewTodoText] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  // Charger les todos au démarrage
  useEffect(() => {
    fetchTodos();
  }, []);

  const fetchTodos = async () => {
    setLoading(true);
    setError("");
    try {
      const response = await fetch(`${API_BASE_URL}/todos`);
      if (!response.ok) {
        throw new Error("Failed to fetch todos");
      }
      const todosData = await response.json();
      setTodos(todosData);
    } catch (err) {
      console.error("Error fetching todos:", err);
      setError(
        "Erreur lors du chargement des todos. Vérifiez que l'API est démarrée."
      );
    } finally {
      setLoading(false);
    }
  };

  const addTodo = async (e) => {
    e.preventDefault();
    if (!newTodoText.trim()) return;

    setLoading(true);
    setError("");
    try {
      const response = await fetch(`${API_BASE_URL}/todos`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ text: newTodoText.trim() }),
      });

      if (!response.ok) {
        throw new Error("Failed to add todo");
      }

      const newTodo = await response.json();
      setTodos([newTodo, ...todos]);
      setNewTodoText("");
    } catch (err) {
      console.error("Error adding todo:", err);
      setError("Erreur lors de l'ajout du todo");
    } finally {
      setLoading(false);
    }
  };

  const toggleTodo = async (id, completed) => {
    setError("");
    try {
      const response = await fetch(`${API_BASE_URL}/todos/${id}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ completed: !completed }),
      });

      if (!response.ok) {
        throw new Error("Failed to update todo");
      }

      const updatedTodo = await response.json();
      setTodos(todos.map((todo) => (todo.id === id ? updatedTodo : todo)));
    } catch (err) {
      console.error("Error updating todo:", err);
      setError("Erreur lors de la mise à jour du todo");
    }
  };

  const deleteTodo = async (id) => {
    setError("");
    try {
      const response = await fetch(`${API_BASE_URL}/todos/${id}`, {
        method: "DELETE",
      });

      if (!response.ok) {
        throw new Error("Failed to delete todo");
      }

      setTodos(todos.filter((todo) => todo.id !== id));
    } catch (err) {
      console.error("Error deleting todo:", err);
      setError("Erreur lors de la suppression du todo");
    }
  };

  return (
    <>
      <div className="app-container">
        <div className="app-subcontainer">
          <div className="container-btns">
            <button onClick={() => setCount((count) => count + 1)}>
              count is {count}!!
            </button>
            <button onClick={() => setCount(0)}>Reset count</button>
          </div>

          <h1>Todo List</h1>

          {error && (
            <div
              style={{
                color: "red",
                margin: "10px 0",
                padding: "10px",
                backgroundColor: "#ffe6e6",
                borderRadius: "4px",
              }}
            >
              {error}
            </div>
          )}

          <form onSubmit={addTodo} style={{ margin: "20px 0" }}>
            <input
              type="text"
              value={newTodoText}
              onChange={(e) => setNewTodoText(e.target.value)}
              placeholder="Ajouter une nouvelle tâche..."
              style={{
                padding: "10px",
                marginRight: "10px",
                border: "1px solid #ccc",
                borderRadius: "4px",
                minWidth: "300px",
              }}
              disabled={loading}
            />
            <button
              type="submit"
              disabled={loading || !newTodoText.trim()}
              style={{
                padding: "10px 20px",
                backgroundColor: "#007bff",
                color: "white",
                border: "none",
                borderRadius: "4px",
                cursor: loading ? "not-allowed" : "pointer",
              }}
            >
              {loading ? "Ajout..." : "Ajouter"}
            </button>
          </form>

          {loading && todos.length === 0 ? (
            <div>Chargement des todos...</div>
          ) : (
            <div>
              {todos.length === 0 ? (
                <p style={{ color: "#666", fontStyle: "italic" }}>
                  Aucune tâche pour le moment. Ajoutez-en une !
                </p>
              ) : (
                todos.map((todo, index) => (
                  <div
                    key={todo.id}
                    style={{
                      display: "flex",
                      alignItems: "center",
                      padding: "10px",
                      margin: "5px 0",
                      backgroundColor: todo.completed ? "#f0f8ff" : "#f9f9f9",
                      border: "1px solid #ddd",
                      borderRadius: "4px",
                    }}
                  >
                    <input
                      type="checkbox"
                      checked={todo.completed}
                      onChange={() => toggleTodo(todo.id, todo.completed)}
                      style={{ marginRight: "10px" }}
                    />
                    <span
                      style={{
                        flex: 1,
                        textDecoration: todo.completed
                          ? "line-through"
                          : "none",
                        color: todo.completed ? "#666" : "#000",
                      }}
                    >
                      {index + 1}. {todo.text}
                    </span>
                    <button
                      onClick={() => deleteTodo(todo.id)}
                      style={{
                        marginLeft: "10px",
                        padding: "5px 10px",
                        backgroundColor: "#dc3545",
                        color: "white",
                        border: "none",
                        borderRadius: "4px",
                        cursor: "pointer",
                      }}
                    >
                      Supprimer
                    </button>
                  </div>
                ))
              )}
            </div>
          )}

          <div style={{ marginTop: "20px", fontSize: "0.9em", color: "#666" }}>
            Total: {todos.length} tâche(s) | Terminée(s):{" "}
            {todos.filter((t) => t.completed).length} | En cours:{" "}
            {todos.filter((t) => !t.completed).length}
          </div>
        </div>
      </div>
    </>
  );
};

export default App;
