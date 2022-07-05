import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { LevelStatus } from './level_status.class';
import { validation } from './level_status.controller';
const routerLevelStatus = express.Router();

routerLevelStatus.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((levelStatus: LevelStatus) => {
			success(res, levelStatus);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerLevelStatus.get(
	'/queryRead/:name_level_status',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levelStatuss: LevelStatus[]) => {
				res.status(200).send(levelStatuss);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevelStatus.get(
	'/byCompanyQueryRead/:company/:name_level_status',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levelStatuss: LevelStatus[]) => {
				res.status(200).send(levelStatuss);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevelStatus.get(
	'/specificRead/:id_level_status',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levelStatus: LevelStatus) => {
				res.status(200).send(levelStatus);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevelStatus.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((levelStatus: LevelStatus) => {
			success(res, levelStatus);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerLevelStatus.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerLevelStatus };
