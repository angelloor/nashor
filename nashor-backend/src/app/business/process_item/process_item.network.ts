import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { ProcessItem } from './process_item.class';
import { validation } from './process_item.controller';
const routerProcessItem = express.Router();

routerProcessItem.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processItem: ProcessItem) => {
			success(res, processItem);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessItem.get(
	'/byOfficialRead/:official',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processItems: ProcessItem[]) => {
				res.status(200).send(processItems);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessItem.get('/byProcessRead/:process', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processItems: ProcessItem[]) => {
			res.status(200).send(processItems);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessItem.get('/byTaskRead/:task', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processItems: ProcessItem[]) => {
			res.status(200).send(processItems);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessItem.get('/byLevelRead/:level', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processItems: ProcessItem[]) => {
			res.status(200).send(processItems);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessItem.get('/byItemRead/:item', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processItems: ProcessItem[]) => {
			res.status(200).send(processItems);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessItem.get(
	'/specificRead/:id_process_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processItem: ProcessItem) => {
				res.status(200).send(processItem);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessItem.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processItem: ProcessItem) => {
			success(res, processItem);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessItem.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerProcessItem };
