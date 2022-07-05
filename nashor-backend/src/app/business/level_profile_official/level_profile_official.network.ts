import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { LevelProfileOfficial } from './level_profile_official.class';
import { validation } from './level_profile_official.controller';
const routerLevelProfileOfficial = express.Router();

routerLevelProfileOfficial.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((levelProfileOfficial: LevelProfileOfficial) => {
			success(res, levelProfileOfficial);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerLevelProfileOfficial.get(
	'/byLevelProfileRead/:level_profile',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levelProfileOfficials: LevelProfileOfficial[]) => {
				res.status(200).send(levelProfileOfficials);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevelProfileOfficial.get(
	'/specificRead/:id_level_profile_official',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levelProfileOfficial: LevelProfileOfficial) => {
				res.status(200).send(levelProfileOfficial);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevelProfileOfficial.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((levelProfileOfficial: LevelProfileOfficial) => {
			success(res, levelProfileOfficial);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerLevelProfileOfficial.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerLevelProfileOfficial };
