import express from "express";
import cors from "cors";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
  GetCommand,
  UpdateCommand,
  DeleteCommand,
} from "@aws-sdk/lib-dynamodb";
import { v4 as uuidv4 } from "uuid";

const app = express();
const PORT = process.env.PORT || 3005;

// Configuration AWS DynamoDB
const client = new DynamoDBClient({
  region: process.env.AWS_REGION || "eu-west-1",
});

const ddbDocClient = DynamoDBDocumentClient.from(client);
const TABLE_NAME =
  process.env.DYNAMODB_TABLE_NAME || "tp2-bis-react-app-todos-production";

// Middleware
app.use(cors());
app.use(express.json());

// Route de santé
app.get("/health", (req, res) => {
  res.json({ status: "OK", timestamp: new Date().toISOString() });
});

// GET /todos - Récupérer tous les todos
app.get("/todos", async (req, res) => {
  try {
    const command = new ScanCommand({
      TableName: TABLE_NAME,
    });

    const result = await ddbDocClient.send(command);

    // Trier par date de création (le plus récent en premier)
    const todos =
      result.Items?.sort(
        (a, b) => new Date(b.createdAt) - new Date(a.createdAt)
      ) || [];

    res.json(todos);
  } catch (error) {
    console.error("Error fetching todos:", error);
    res.status(500).json({ error: "Failed to fetch todos" });
  }
});

// POST /todos - Créer un nouveau todo
app.post("/todos", async (req, res) => {
  try {
    const { text } = req.body;

    if (!text || text.trim() === "") {
      return res.status(400).json({ error: "Text is required" });
    }

    const todo = {
      id: uuidv4(),
      text: text.trim(),
      completed: false,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    const command = new PutCommand({
      TableName: TABLE_NAME,
      Item: todo,
    });

    await ddbDocClient.send(command);
    res.status(201).json(todo);
  } catch (error) {
    console.error("Error creating todo:", error);
    res.status(500).json({ error: "Failed to create todo" });
  }
});

// PUT /todos/:id - Mettre à jour un todo
app.put("/todos/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { text, completed } = req.body;

    const updateExpression = [];
    const expressionAttributeValues = {};

    if (text !== undefined) {
      updateExpression.push("text = :text");
      expressionAttributeValues[":text"] = text.trim();
    }

    if (completed !== undefined) {
      updateExpression.push("completed = :completed");
      expressionAttributeValues[":completed"] = completed;
    }

    updateExpression.push("updatedAt = :updatedAt");
    expressionAttributeValues[":updatedAt"] = new Date().toISOString();

    const command = new UpdateCommand({
      TableName: TABLE_NAME,
      Key: { id },
      UpdateExpression: `SET ${updateExpression.join(", ")}`,
      ExpressionAttributeValues: expressionAttributeValues,
      ReturnValues: "ALL_NEW",
    });

    const result = await ddbDocClient.send(command);
    res.json(result.Attributes);
  } catch (error) {
    console.error("Error updating todo:", error);
    res.status(500).json({ error: "Failed to update todo" });
  }
});

// DELETE /todos/:id - Supprimer un todo
app.delete("/todos/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const command = new DeleteCommand({
      TableName: TABLE_NAME,
      Key: { id },
      ReturnValues: "ALL_OLD",
    });

    const result = await ddbDocClient.send(command);

    if (!result.Attributes) {
      return res.status(404).json({ error: "Todo not found" });
    }

    res.json({ message: "Todo deleted successfully", todo: result.Attributes });
  } catch (error) {
    console.error("Error deleting todo:", error);
    res.status(500).json({ error: "Failed to delete todo" });
  }
});

// Ajouter des todos d'exemple au démarrage (optionnel)
async function seedData() {
  try {
    const scanCommand = new ScanCommand({
      TableName: TABLE_NAME,
      Limit: 1,
    });

    const result = await ddbDocClient.send(scanCommand);

    // Si la table est vide, ajouter des exemples
    if (!result.Items || result.Items.length === 0) {
      const sampleTodos = [
        {
          id: uuidv4(),
          text: "Apprendre Terraform",
          completed: false,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        },
        {
          id: uuidv4(),
          text: "Déployer avec Docker",
          completed: true,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        },
      ];

      for (const todo of sampleTodos) {
        const putCommand = new PutCommand({
          TableName: TABLE_NAME,
          Item: todo,
        });
        await ddbDocClient.send(putCommand);
      }

      console.log("Sample todos added to database");
    }
  } catch (error) {
    console.error("Error seeding data:", error);
  }
}

app.listen(PORT, async () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Using DynamoDB table: ${TABLE_NAME}`);
  console.log(`AWS Region: ${process.env.AWS_REGION || "eu-west-1"}`);

  // Initialiser les données d'exemple
  await seedData();
});
