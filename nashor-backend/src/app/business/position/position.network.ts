import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Position } from './position.class';
import { validation } from './position.controller';
const routerPosition = express.Router();

routerPosition.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((position: Position) => {
			success(res, position);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerPosition.get('/queryRead/:name_position', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((positions: Position[]) => {
			res.status(200).send(positions);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerPosition.get(
	'/byCompanyQueryRead/:company/:name_position',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((positions: Position[]) => {
				res.status(200).send(positions);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerPosition.get('/specificRead/:id_position', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((position: Position) => {
			res.status(200).send(position);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerPosition.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((position: Position) => {
			success(res, position);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerPosition.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerPosition };
