import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Task } from './task.class';
import { validation } from './task.controller';
const routerTask = express.Router();

routerTask.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((task: Task) => {
			success(res, task);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTask.get('/queryRead/:process', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((tasks: Task[]) => {
			res.status(200).send(tasks);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTask.get(
	'/byProcessQueryRead/:level/:process',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((tasks: Task[]) => {
				res.status(200).send(tasks);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerTask.get(
	'/byOfficialQueryRead/:official/:process',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((tasks: Task[]) => {
				res.status(200).send(tasks);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerTask.get(
	'/byLevelQueryRead/:level/:process',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((tasks: Task[]) => {
				res.status(200).send(tasks);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerTask.get('/specificRead/:id_task', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((task: Task) => {
			res.status(200).send(task);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTask.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((task: Task) => {
			success(res, task);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTask.patch('/reasign', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((task: Task) => {
			success(res, task);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTask.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerTask };
