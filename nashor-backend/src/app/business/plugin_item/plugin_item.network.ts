import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { PluginItem } from './plugin_item.class';
import { validation } from './plugin_item.controller';
const routerPluginItem = express.Router();

routerPluginItem.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((pluginItem: PluginItem) => {
			success(res, pluginItem);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerPluginItem.get(
	'/queryRead/:name_plugin_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((pluginItems: PluginItem[]) => {
				res.status(200).send(pluginItems);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerPluginItem.get(
	'/byCompanyQueryRead/:company/:name_plugin_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((pluginItems: PluginItem[]) => {
				res.status(200).send(pluginItems);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerPluginItem.get(
	'/specificRead/:id_plugin_item',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((pluginItem: PluginItem) => {
				res.status(200).send(pluginItem);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerPluginItem.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((pluginItem: PluginItem) => {
			success(res, pluginItem);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerPluginItem.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerPluginItem };
