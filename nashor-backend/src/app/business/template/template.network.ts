import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Template } from './template.class';
import { validation } from './template.controller';
const routerTemplate = express.Router();

routerTemplate.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((template: Template) => {
			success(res, template);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTemplate.get('/queryRead/:name_template', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((templates: Template[]) => {
			res.status(200).send(templates);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTemplate.get(
	'/byCompanyQueryRead/:company/:name_template',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((templates: Template[]) => {
				res.status(200).send(templates);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerTemplate.get(
	'/byDocumentationProfileQueryRead/:documentation_profile/:name_template',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((templates: Template[]) => {
				res.status(200).send(templates);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerTemplate.get('/specificRead/:id_template', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((template: Template) => {
			res.status(200).send(template);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTemplate.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((template: Template) => {
			success(res, template);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTemplate.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerTemplate };
