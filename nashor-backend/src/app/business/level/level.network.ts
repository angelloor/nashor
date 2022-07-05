import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Level } from './level.class';
import { validation } from './level.controller';
const routerLevel = express.Router();

routerLevel.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((level: Level) => {
			success(res, level);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerLevel.get('/queryRead/:name_level', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((levels: Level[]) => {
			res.status(200).send(levels);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerLevel.get(
	'/byCompanyQueryRead/:company/:name_level',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levels: Level[]) => {
				res.status(200).send(levels);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevel.get(
	'/byTemplateQueryRead/:template/:name_level',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levels: Level[]) => {
				res.status(200).send(levels);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevel.get(
	'/byLevelProfileQueryRead/:level_profile/:name_level',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levels: Level[]) => {
				res.status(200).send(levels);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevel.get(
	'/byLevelStatusQueryRead/:level_status/:name_level',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levels: Level[]) => {
				res.status(200).send(levels);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevel.get('/specificRead/:id_level', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((level: Level) => {
			res.status(200).send(level);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerLevel.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((level: Level) => {
			success(res, level);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerLevel.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerLevel };
