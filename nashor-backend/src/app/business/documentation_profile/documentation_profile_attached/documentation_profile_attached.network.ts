import express from 'express';
import { error, success } from '../../../../network/response';
import { MessageAPI } from '../../../../utils/message/message.type';
import { DocumentationProfileAttached } from './documentation_profile_attached.class';
import { validation } from './documentation_profile_attached.controller';
const routerDocumentationProfileAttached = express.Router();

routerDocumentationProfileAttached.post(
	'/create',
	async (req: any, res: any) => {
		await validation(req.body, req.url, req.headers.token)
			.then((documentationProfileAttached: DocumentationProfileAttached) => {
				success(res, documentationProfileAttached);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerDocumentationProfileAttached.get(
	'/byDocumentationProfileRead/:documentation_profile',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((documentationProfileAttacheds: DocumentationProfileAttached[]) => {
				res.status(200).send(documentationProfileAttacheds);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerDocumentationProfileAttached.get(
	'/byAttachedRead/:attached',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((documentationProfileAttacheds: DocumentationProfileAttached[]) => {
				res.status(200).send(documentationProfileAttacheds);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerDocumentationProfileAttached.get(
	'/specificRead/:id_documentation_profile_attached',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((documentationProfileAttached: DocumentationProfileAttached) => {
				res.status(200).send(documentationProfileAttached);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerDocumentationProfileAttached.patch(
	'/update',
	async (req: any, res: any) => {
		await validation(req.body, req.url, req.headers.token)
			.then((documentationProfileAttached: DocumentationProfileAttached) => {
				success(res, documentationProfileAttached);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerDocumentationProfileAttached.delete(
	'/delete',
	async (req: any, res: any) => {
		await validation(req.query, req.url, req.headers.token)
			.then((response: boolean) => {
				success(res, response);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

export { routerDocumentationProfileAttached };
