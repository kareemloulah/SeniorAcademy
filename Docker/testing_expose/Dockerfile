FROM ubuntu:noble

# Update package lists and install Nginx
RUN apt-get update && \
    apt-get install -y curl \
    nginx 

# Expose port 80 for Nginx
# EXPOSE 80

# Copy a custom Nginx configuration if desired (optional)
# COPY nginx.conf /etc/nginx/nginx.conf

# Copy your website content (optional)
COPY html/index.html /var/www/html/index.html
# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]