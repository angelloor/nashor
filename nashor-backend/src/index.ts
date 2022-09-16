// import cluster from 'cluster';
import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';
import useragent from 'express-useragent';
import http from 'http';
import os from 'os';
import path from 'path';
import { appRoutes } from './network/routes';
const app = express();
let numCpu = os.cpus().length;

numCpu = numCpu === 0 ? 1 : numCpu;

if (process.env.NODE_ENV == 'production') {
	console.log(`Cores -> ${numCpu}`);
}

const PRODUCTION_PORT = 80;
const DEVELOPMENT_PORT = 3000;

process.setMaxListeners(0);

dotenv.config({
	path: path.join(path.resolve('./env'), process.env.NODE_ENV + '.env'),
});

const whitelist: string[] = ['http://localhost:4200', 'https://nashor.web.app'];

const corsOptionsDelegate = (req: any, callback: any) => {
	let corsOptions = {
		origin: false,
		optionsSuccessStatus: 200,
		exposedHeaders: ['name_report', 'message'],
	};

	if (whitelist.indexOf(req.header('Origin')) !== -1) {
		corsOptions = { ...corsOptions, origin: true }; // reflect (enable) the requested origin in the CORS response
	} else {
		corsOptions = { ...corsOptions, origin: false }; // disable CORS for this request
	}
	callback(null, corsOptions); // callback expects two parameters: error and options
};

app.use(useragent.express());
app.use(express.json());
app.use(cors(corsOptionsDelegate));
app.use(express.urlencoded({ extended: false }));
app.use('/', express.static('./public'));
/**
 * Redirect http to https
 */
// if (process.env.NODE_ENV == 'production') {
//     app.enable('trust proxy')
//     app.use((req, res, next) => {
//         req.secure ? next() : res.redirect('https://' + 'facturacion.puyo.gob.ec' + req.url)
//     })
// }

app.get('/*', (req: any, res: any, next: any) => {
	/**
	 * Condition the url, if is rest then continue opposite case redirect html, because
	 * they are assumed to be webapp routes
	 */
	if (
		!(req.url.substring(1, 5) == 'rest' || req.url.substring(1, 4) == 'app')
	) {
		res.sendFile(
			path.join(path.resolve('./'), 'public/index.html'),
			(err: any) => {
				if (err) {
					res.status(500).send(err);
				}
			}
		);
	} else {
		next();
	}
});

appRoutes(app);

/**
 * Cluster
 */
// if (cluster.isPrimary) {
// 	for (let i = 0; i < numCpu; i++) {
// 		cluster.fork();
// 	}
// 	cluster.on('exit', (worker, code, signal) => {
// 		console.log(`worker ${worker.process.pid} died`);
// 		cluster.fork();
// 	});
// } else {
// 	var httpServer = http.createServer(app);
// 	httpServer.listen(
// 		process.env.NODE_ENV == 'production' ? PRODUCTION_PORT : DEVELOPMENT_PORT
// 	);
// 	console.log(
// 		`The app is listening on http://localhost:${
// 			process.env.NODE_ENV == 'production' ? PRODUCTION_PORT : DEVELOPMENT_PORT
// 		} PID ${process.pid}`
// 	);
// }
/**
 * Cluster
 */
var httpServer = http.createServer(app);
httpServer.listen(
	process.env.NODE_ENV == 'production' ? PRODUCTION_PORT : DEVELOPMENT_PORT
);
console.log(
	`The app is listening on http://localhost:${
		process.env.NODE_ENV == 'production' ? PRODUCTION_PORT : DEVELOPMENT_PORT
	} PID ${process.pid}`
);
