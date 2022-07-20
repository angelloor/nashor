import express from 'express';
import { error, success } from '../../../network/response';
import { uploadFile } from '../../../utils/fileStorage';
import { MessageAPI } from '../../../utils/message/message.type';
import { ProcessAttached } from './process_attached.class';
import { validation } from './process_attached.controller';
const routerProcessAttached = express.Router();

routerProcessAttached.post(
	'/create',
	uploadFile.single(`file`),
	async (req: any, res: any) => {
		const _process_attached = {
			...req.body,
			id_user_: parseInt(req.body.id_user_),
			official: {
				id_official: parseInt(req.body.id_official),
			},
			process: {
				id_process: parseInt(req.body.id_process),
			},
			task: {
				id_task: parseInt(req.body.id_task),
			},
			level: {
				id_level: parseInt(req.body.id_level),
			},
			attached: {
				id_attached: parseInt(req.body.id_attached),
			},
		};

		delete _process_attached.id_official;
		delete _process_attached.id_process;
		delete _process_attached.id_task;
		delete _process_attached.id_level;
		delete _process_attached.id_attached;

		await validation(_process_attached, req.url, req.headers.token)
			.then((processAttached: ProcessAttached) => {
				success(res, processAttached);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessAttached.get(
	'/byOfficialRead/:official',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processAttacheds: ProcessAttached[]) => {
				res.status(200).send(processAttacheds);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessAttached.get(
	'/byProcessRead/:process',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processAttacheds: ProcessAttached[]) => {
				res.status(200).send(processAttacheds);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessAttached.get('/byTaskRead/:task', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processAttacheds: ProcessAttached[]) => {
			res.status(200).send(processAttacheds);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessAttached.get('/byLevelRead/:level', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processAttacheds: ProcessAttached[]) => {
			res.status(200).send(processAttacheds);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessAttached.get(
	'/byAttachedRead/:attached',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processAttacheds: ProcessAttached[]) => {
				res.status(200).send(processAttacheds);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessAttached.get(
	'/specificRead/:id_process_attached',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processAttached: ProcessAttached) => {
				res.status(200).send(processAttached);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessAttached.post('/downloadFile', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((data: any) => {
			res.sendFile(data);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessAttached.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processAttached: ProcessAttached) => {
			success(res, processAttached);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessAttached.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerProcessAttached };
