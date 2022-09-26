import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { PluginItemColumn } from './plugin_item_column.class';
import { validation } from './plugin_item_column.controller';
const routerPluginItemColumn = express.Router();

routerPluginItemColumn.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((pluginItemColumn: PluginItemColumn) => {
			success(res, pluginItemColumn);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerPluginItemColumn.get(
	'/queryRead/:name_plugin_item_column',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((pluginItemColumns: PluginItemColumn[]) => {
				res.status(200).send(pluginItemColumns);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerPluginItemColumn.get(
	'/byPluginItemQueryRead/:plugin_item/:name_plugin_item_column',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((pluginItemColumns: PluginItemColumn[]) => {
				res.status(200).send(pluginItemColumns);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerPluginItemColumn.get(
	'/specificRead/:id_plugin_item_column',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((pluginItemColumn: PluginItemColumn) => {
				res.status(200).send(pluginItemColumn);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerPluginItemColumn.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((pluginItemColumn: PluginItemColumn) => {
			success(res, pluginItemColumn);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerPluginItemColumn.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerPluginItemColumn };
