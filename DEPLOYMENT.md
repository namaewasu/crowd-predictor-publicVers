# Traffic Predictor - Deployment Guide

## Railway Deployment Steps

1. Create a Railway account at https://railway.app/

2. Install Railway CLI:
```bash
npm i -g @railway/cli
```

3. Login to Railway:
```bash
railway login
```

4. Initialize Railway project:
```bash
railway init
```

5. Add MySQL Database:
- Go to Railway Dashboard
- Click "New Project"
- Choose "Database" > "MySQL"
- Wait for provisioning
- Copy the connection details

6. Set environment variables in Railway Dashboard:
- MYSQL_HOST
- MYSQL_USER
- MYSQL_PASSWORD
- MYSQL_DATABASE
- JWT_SECRET_KEY
- GOOGLE_API_KEY

7. Deploy the application:
```bash
railway up
```

8. Your application will be deployed with:
- Backend API at: https://your-app-name.up.railway.app
- MySQL Database (automatically managed by Railway)

## Local Development

1. Create `.env` file in `/backend`:
```
MYSQL_HOST=localhost
MYSQL_USER=your-user
MYSQL_PASSWORD=your-password
MYSQL_DATABASE=traffic_predictor
JWT_SECRET_KEY=your-secret-key
GOOGLE_API_KEY=your-google-api-key
```

2. Create `.env` file in `/traffic-map`:
```
REACT_APP_API_URL=http://localhost:5050
REACT_APP_GOOGLE_MAPS_KEY=your-google-maps-key
```

3. Install dependencies and run:
```bash
# Backend
cd backend
pip install -r requirements.txt
python app.py

# Frontend
cd traffic-map
npm install
npm start
```

## Database Backup and Restore

Railway provides automatic backups, but you can also manually backup:

1. Export database:
```bash
railway connect
mysqldump -u root -p traffic_predictor > backup.sql
```

2. Import database:
```bash
railway connect
mysql -u root -p traffic_predictor < backup.sql
```