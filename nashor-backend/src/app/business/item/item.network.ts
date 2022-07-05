import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Item } from './item.class';
import { validation } from './item.controller';
const routerItem = express.Router();

routerItem.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((item: Item) => {
			success(res, item);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerItem.get('/queryRead/:name_item', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((items: Item[]) => {
			res.status(200).send(items);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerItem.get(
	'/byCompanyQueryRead/:company/:name_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((items: Item[]) => {
				res.status(200).send(items);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerItem.get(
	'/byItemCategoryQueryRead/:item_category/:name_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((items: Item[]) => {
				res.status(200).send(items);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerItem.get('/specificRead/:id_item', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((item: Item) => {
			res.status(200).send(item);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerItem.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((item: Item) => {
			success(res, item);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerItem.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerItem };
