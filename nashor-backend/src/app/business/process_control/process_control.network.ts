import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { ProcessControl } from './process_control.class';
import { validation } from './process_control.controller';
const routerProcessControl = express.Router();

routerProcessControl.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processControl: ProcessControl) => {
			success(res, processControl);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessControl.get(
	'/byOfficialRead/:official',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processControls: ProcessControl[]) => {
				res.status(200).send(processControls);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessControl.get(
	'/byProcessRead/:process',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processControls: ProcessControl[]) => {
				res.status(200).send(processControls);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessControl.get('/byTaskRead/:task', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processControls: ProcessControl[]) => {
			res.status(200).send(processControls);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessControl.get('/byLevelRead/:level', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processControls: ProcessControl[]) => {
			res.status(200).send(processControls);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessControl.get(
	'/byControlRead/:control',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processControls: ProcessControl[]) => {
				res.status(200).send(processControls);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessControl.get(
	'/specificRead/:id_process_control',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processControl: ProcessControl) => {
				res.status(200).send(processControl);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessControl.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processControl: ProcessControl) => {
			success(res, processControl);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessControl.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerProcessControl };
