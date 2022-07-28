import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Flow } from './flow.class';
import { validation } from './flow.controller';
const routerFlow = express.Router();

routerFlow.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processType: Flow) => {
			success(res, processType);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlow.get('/queryRead/:name_flow', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processTypes: Flow[]) => {
			res.status(200).send(processTypes);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlow.get(
	'/byCompanyQueryRead/:company/:name_flow',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processTypes: Flow[]) => {
				res.status(200).send(processTypes);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerFlow.get('/specificRead/:id_flow', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processType: Flow) => {
			res.status(200).send(processType);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlow.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processType: Flow) => {
			success(res, processType);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlow.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerFlow };
