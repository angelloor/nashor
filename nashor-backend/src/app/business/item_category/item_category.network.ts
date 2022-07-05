import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { ItemCategory } from './item_category.class';
import { validation } from './item_category.controller';
const routerItemCategory = express.Router();

routerItemCategory.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((itemCategory: ItemCategory) => {
			success(res, itemCategory);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerItemCategory.get(
	'/queryRead/:name_item_category',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((itemCategorys: ItemCategory[]) => {
				res.status(200).send(itemCategorys);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerItemCategory.get(
	'/byCompanyQueryRead/:company/:name_item_category',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((itemCategorys: ItemCategory[]) => {
				res.status(200).send(itemCategorys);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerItemCategory.get(
	'/specificRead/:id_item_category',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((itemCategory: ItemCategory) => {
				res.status(200).send(itemCategory);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerItemCategory.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((itemCategory: ItemCategory) => {
			success(res, itemCategory);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerItemCategory.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerItemCategory };
