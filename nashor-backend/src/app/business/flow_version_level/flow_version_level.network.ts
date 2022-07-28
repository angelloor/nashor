import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { FlowVersionLevel } from './flow_version_level.class';
import { validation } from './flow_version_level.controller';
const routerFlowVersionLevel = express.Router();

routerFlowVersionLevel.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((flowVersionLevel: FlowVersionLevel) => {
			success(res, flowVersionLevel);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlowVersionLevel.get(
	'/byFlowVersionRead/:flow_version',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((flowVersionLevels: FlowVersionLevel[]) => {
				res.status(200).send(flowVersionLevels);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerFlowVersionLevel.get(
	'/byFlowVersionExcludeConditionalRead/:flow_version',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((flowVersionLevels: FlowVersionLevel[]) => {
				res.status(200).send(flowVersionLevels);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerFlowVersionLevel.get(
	'/byLevelRead/:level',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((flowVersionLevels: FlowVersionLevel[]) => {
				res.status(200).send(flowVersionLevels);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerFlowVersionLevel.get(
	'/specificRead/:id_flow_version_level',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((flowVersionLevel: FlowVersionLevel) => {
				res.status(200).send(flowVersionLevel);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerFlowVersionLevel.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((flowVersionLevel: FlowVersionLevel) => {
			success(res, flowVersionLevel);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlowVersionLevel.patch('/reset', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlowVersionLevel.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerFlowVersionLevel };
