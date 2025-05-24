
import http from 'http';
import dotenv from 'dotenv';
import app from './app';

dotenv.config();

const server = http.createServer(app);

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
