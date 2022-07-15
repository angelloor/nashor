import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Official } from './official.class';
import { validation } from './official.controller';
const routerOfficial = express.Router();

routerOfficial.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((official: Official) => {
			success(res, official);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerOfficial.get('/queryRead/:user', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((officials: Official[]) => {
			res.status(200).send(officials);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerOfficial.get(
	'/byCompanyQueryRead/:company/:user',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((officials: Official[]) => {
				res.status(200).send(officials);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerOfficial.get('/byUserRead/:user', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((officials: Official[]) => {
			res.status(200).send(officials);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerOfficial.get(
	'/byAreaQueryRead/:area/:user',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((officials: Official[]) => {
				res.status(200).send(officials);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerOfficial.get(
	'/byPositionQueryRead/:position/:user',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((officials: Official[]) => {
				res.status(200).send(officials);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerOfficial.get('/specificRead/:id_official', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((official: Official) => {
			res.status(200).send(official);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerOfficial.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((official: Official) => {
			success(res, official);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerOfficial.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerOfficial };
