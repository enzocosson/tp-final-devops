FROM node:20-alpine

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste des fichiers source
COPY . .

# Exposer le port utilisé par Vite
EXPOSE 5173

# Lancer le serveur de développement Vite
CMD ["npm", "run", "dev"]