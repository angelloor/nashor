import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Process } from './process.class';
import { validation } from './process.controller';
const routerProcess = express.Router();

routerProcess.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((process: Process) => {
			success(res, process);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcess.get('/queryRead/:number_process', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processs: Process[]) => {
			res.status(200).send(processs);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcess.get(
	'/byProcessTypeQueryRead/:process_type/:number_process',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processs: Process[]) => {
				res.status(200).send(processs);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcess.get(
	'/byOfficialQueryRead/:official/:number_process',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processs: Process[]) => {
				res.status(200).send(processs);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcess.get(
	'/byFlowVersionQueryRead/:flow_version/:number_process',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processs: Process[]) => {
				res.status(200).send(processs);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcess.get('/specificRead/:id_process', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((process: Process) => {
			res.status(200).send(process);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcess.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((process: Process) => {
			success(res, process);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcess.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerProcess };
