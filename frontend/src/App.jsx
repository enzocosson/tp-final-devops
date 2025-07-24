import { useEffect, useState } from "react";
import "./App.css";
const App = () => {
  const [count, setCount] = useState(0);
  const [todos, setTodos] = useState([]);

  useEffect(() => {
    fetch("http://localhost:3005/todos")
      .then((response) => {
        return response.json();
      })
      .then((todos) => {
        setTodos(todos);
      });
  }, []);

  console.log(todos);

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
          <h1>Todos</h1>
          <div>
            {todos.map((todo, index) => (
              <div key={todo.id}>
                {index + 1}. {todo.text}
              </div>
            ))}
          </div>
        </div>
      </div>
    </>
  );
};

export default App;
