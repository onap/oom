// Database Setup
use ${MONGO_DATABASE}

// UserCreation Setup
db.createUser(
  {
    user: "${MONGODB_USER}",
    pwd: "${MONGODB_PASSWORD}",
    roles: [ { role: "readWrite", db: "${MONGO_DATABASE}" } ]
  }
)
