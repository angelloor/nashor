import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { ColumnProcessItem } from './column_process_item.class';
import { validation } from './column_process_item.controller';
const routerColumnProcessItem = express.Router();

routerColumnProcessItem.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((columnProcessItem: ColumnProcessItem) => {
			success(res, columnProcessItem);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerColumnProcessItem.get(
	'/queryRead/:value_column_process_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((columnProcessItems: ColumnProcessItem[]) => {
				res.status(200).send(columnProcessItems);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerColumnProcessItem.get(
	'/byPluginItemColumnQueryRead/:plugin_item_column/:value_column_process_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((columnProcessItems: ColumnProcessItem[]) => {
				res.status(200).send(columnProcessItems);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerColumnProcessItem.get(
	'/byProcessItemQueryRead/:process_item/:value_column_process_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((columnProcessItems: ColumnProcessItem[]) => {
				res.status(200).send(columnProcessItems);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerColumnProcessItem.get(
	'/byPluginItemColumnAndProcessItemRead/:plugin_item_column/:process_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((columnProcessItems: ColumnProcessItem[]) => {
				res.status(200).send(columnProcessItems);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerColumnProcessItem.get(
	'/specificRead/:id_column_process_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((columnProcessItem: ColumnProcessItem) => {
				res.status(200).send(columnProcessItem);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerColumnProcessItem.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((columnProcessItem: ColumnProcessItem) => {
			success(res, columnProcessItem);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerColumnProcessItem.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerColumnProcessItem };
