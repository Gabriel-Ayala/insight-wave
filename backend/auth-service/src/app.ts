import express from 'express';
import helmet from 'helmet'; 

import router from './routes/routes';

const app = express();

app.use(express.json())
   .use(router)
   .use(helmet());

export default app;
