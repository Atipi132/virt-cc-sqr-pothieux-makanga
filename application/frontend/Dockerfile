FROM nginx:latest

# Copie des fichiers de l'application dans le répertoire par défaut de NGINX
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY app.js /usr/share/nginx/html/

# Exposition du port 80 (port par défaut de NGINX)
EXPOSE 80
