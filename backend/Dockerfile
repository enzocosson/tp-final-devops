FROM node:20-alpine

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste des fichiers source
COPY . .

# Exposer le port utilisé par le backend
EXPOSE 3005

# Lancer le serveur avec la commande correcte
CMD ["node", "index.js"]