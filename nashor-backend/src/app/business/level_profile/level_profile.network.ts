import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { LevelProfile } from './level_profile.class';
import { validation } from './level_profile.controller';
const routerLevelProfile = express.Router();

routerLevelProfile.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((levelProfile: LevelProfile) => {
			success(res, levelProfile);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerLevelProfile.get(
	'/queryRead/:name_level_profile',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levelProfiles: LevelProfile[]) => {
				res.status(200).send(levelProfiles);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevelProfile.get(
	'/byCompanyQueryRead/:company/:name_level_profile',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levelProfiles: LevelProfile[]) => {
				res.status(200).send(levelProfiles);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevelProfile.get(
	'/specificRead/:id_level_profile',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((levelProfile: LevelProfile) => {
				res.status(200).send(levelProfile);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerLevelProfile.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((levelProfile: LevelProfile) => {
			success(res, levelProfile);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerLevelProfile.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerLevelProfile };
