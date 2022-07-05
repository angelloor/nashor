import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { ProcessType } from './process_type.class';
import { validation } from './process_type.controller';
const routerProcessType = express.Router();

routerProcessType.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processType: ProcessType) => {
			success(res, processType);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessType.get(
	'/queryRead/:name_process_type',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processTypes: ProcessType[]) => {
				res.status(200).send(processTypes);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessType.get(
	'/byCompanyQueryRead/:company/:name_process_type',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processTypes: ProcessType[]) => {
				res.status(200).send(processTypes);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessType.get(
	'/specificRead/:id_process_type',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processType: ProcessType) => {
				res.status(200).send(processType);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessType.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processType: ProcessType) => {
			success(res, processType);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessType.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerProcessType };
