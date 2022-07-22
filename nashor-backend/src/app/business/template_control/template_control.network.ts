import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { TemplateControl } from './template_control.class';
import { validation } from './template_control.controller';
const routerTemplateControl = express.Router();

routerTemplateControl.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((templateControl: TemplateControl) => {
			success(res, templateControl);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTemplateControl.post(
	'/createWithNewControl',
	async (req: any, res: any) => {
		await validation(req.body, req.url, req.headers.token)
			.then((templateControl: TemplateControl) => {
				success(res, templateControl);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
	
// );

routerTemplateControl.get(
	'/byTemplateRead/:template',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((templateControls: TemplateControl[]) => {
				res.status(200).send(templateControls);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerTemplateControl.get(
	'/byControlRead/:control',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((templateControls: TemplateControl[]) => {
				res.status(200).send(templateControls);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerTemplateControl.get(
	'/specificRead/:id_template_control',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((templateControl: TemplateControl) => {
				res.status(200).send(templateControl);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerTemplateControl.patch(
	'/updateControlProperties',
	async (req: any, res: any) => {
		await validation(req.body, req.url, req.headers.token)
			.then((templateControl: TemplateControl) => {
				success(res, templateControl);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerTemplateControl.patch('/updatePositions', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((templateControl: TemplateControl) => {
			success(res, templateControl);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerTemplateControl.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerTemplateControl };
