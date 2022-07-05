import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Attached } from './attached.class';
import { validation } from './attached.controller';
const routerAttached = express.Router();

routerAttached.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((attached: Attached) => {
			success(res, attached);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerAttached.get('/queryRead/:name_attached', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((attacheds: Attached[]) => {
			res.status(200).send(attacheds);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerAttached.get(
	'/byCompanyQueryRead/:company/:name_attached',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((attacheds: Attached[]) => {
				res.status(200).send(attacheds);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerAttached.get('/specificRead/:id_attached', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((attached: Attached) => {
			res.status(200).send(attached);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerAttached.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((attached: Attached) => {
			success(res, attached);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerAttached.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerAttached };
