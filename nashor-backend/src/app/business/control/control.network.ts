import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { Control } from './control.class';
import { validation } from './control.controller';
const routerControl = express.Router();

routerControl.get(
	'/queryRead/:form_name_control',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((controls: Control[]) => {
				res.status(200).send(controls);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerControl.get(
	'/byCompanyQueryRead/:company/:form_name_control',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((controls: Control[]) => {
				res.status(200).send(controls);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerControl.get(
	'/byPositionLevel/:id_user_/:form_name_control',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((controls: Control[]) => {
				res.status(200).send(controls);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerControl.get('/specificRead/:id_control', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((control: Control) => {
			res.status(200).send(control);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerControl.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((control: Control) => {
			success(res, control);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerControl.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerControl.delete('/cascadeDelete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerControl };
