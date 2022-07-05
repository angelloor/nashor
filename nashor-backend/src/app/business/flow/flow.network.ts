import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Flow } from './flow.class';
import { validation } from './flow.controller';
const routerFlow = express.Router();

routerFlow.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((flow: Flow) => {
			success(res, flow);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlow.get('/queryRead/:name_flow', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((flows: Flow[]) => {
			res.status(200).send(flows);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlow.get(
	'/byCompanyQueryRead/:company/:name_flow',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((flows: Flow[]) => {
				res.status(200).send(flows);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerFlow.get(
	'/byProcessTypeQueryRead/:process_type/:name_flow',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((flows: Flow[]) => {
				res.status(200).send(flows);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerFlow.get('/specificRead/:id_flow', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((flow: Flow) => {
			res.status(200).send(flow);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlow.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((flow: Flow) => {
			success(res, flow);
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
