import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { FlowVersion } from './flow_version.class';
import { validation } from './flow_version.controller';
const routerFlowVersion = express.Router();

routerFlowVersion.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((flowVersion: FlowVersion) => {
			success(res, flowVersion);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlowVersion.get('/byFlowRead/:flow', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((flowVersions: FlowVersion[]) => {
			res.status(200).send(flowVersions);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlowVersion.get(
	'/specificRead/:id_flow_version',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((flowVersion: FlowVersion) => {
				res.status(200).send(flowVersion);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerFlowVersion.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((flowVersion: FlowVersion) => {
			success(res, flowVersion);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerFlowVersion.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerFlowVersion };
