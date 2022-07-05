import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Area } from './area.class';
import { validation } from './area.controller';
const routerArea = express.Router();

routerArea.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((area: Area) => {
			success(res, area);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerArea.get('/queryRead/:name_area', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((areas: Area[]) => {
			res.status(200).send(areas);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerArea.get(
	'/byCompanyQueryRead/:company/:name_area',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((areas: Area[]) => {
				res.status(200).send(areas);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerArea.get('/specificRead/:id_area', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((area: Area) => {
			res.status(200).send(area);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerArea.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((area: Area) => {
			success(res, area);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerArea.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerArea };
