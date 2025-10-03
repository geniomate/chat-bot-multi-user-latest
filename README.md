# AI Chatbot Docker Image

A production-ready Docker image that bundles the React frontend, Flask backend, and Nginx proxy for the AI chatbot project. MongoDB runs in a separate container and stores user chat history.

## Prerequisites
- Docker Desktop or Docker Engine 24+
- (Optional) Docker Compose V2 `docker compose`
- A Google Gemini API key (`GEMINI_API_KEY`)

## Quick Start (pull the published image)
1. Create a `.env` file alongside `docker-compose.yml` and add your API key:
   ```env
   GEMINI_API_KEY=your_real_key_here
   ```
2. Pull the application image and MongoDB:
   ```bash
   docker pull mohamedabozaid/chat-ai:latest
   docker pull mongo:5.0
   ```
3. Start the stack with Docker Compose:
   ```bash
   docker compose up -d
   ```
4. Open http://localhost:8081 to use the chatbot.

The provided `docker-compose.yml` wires the app container to MongoDB on the same bridge network and passes the default `MONGO_URI`. Chat history is stored in the `mongodb_data` volume.

## Running Without Compose
```bash
docker pull mohamedabozaid/chat-ai:latest

docker network create chat-ai-net

docker run -d \
  --name chatbot_mongodb \
  --network chat-ai-net \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  mongo:5.0

docker run -d \
  --name chatbot_combined \
  --network chat-ai-net \
  -p 8081:80 \
  -e GEMINI_API_KEY=your_real_key_here \
  -e MONGO_URI="mongodb://admin:password@chatbot_mongodb:27017/chatbot_db?authSource=admin" \
  mohamedabozaid/chat-ai:latest
```

## Building and Pushing Yourself (optional)
```bash
# Build using the project sources
docker compose -f docker-compose.build.yml build app

# Push to your own registry
docker tag mohamedabozaid/chat-ai:latest your-username/chat-ai:latest
docker push your-username/chat-ai:latest
```

## Troubleshooting
- **Cannot reach backend**: confirm containers are running (`docker compose ps`) and that you are using port 8081.
- **AI errors**: verify `GEMINI_API_KEY` is set and valid; check logs with `docker logs chatbot_combined`.
- **Mongo connection issues**: ensure the Mongo container is healthy and accessible on the shared network.

## API Endpoints
| Method | Endpoint | Purpose |
| --- | --- | --- |
| GET | `/api/messages` | Last 5 messages for a user |
| POST | `/api/messages` | Save a user/bot message |
| POST | `/api/chat` | Ask Gemini and persist the response |
| GET | `/api/history` | Full history for a user |
| DELETE | `/api/clear` | Remove all messages for a user |
| GET | `/api/health` | Service health check |

MIT License. See `LICENSE`.
