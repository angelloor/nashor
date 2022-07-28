import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { Flow } from './flow.class';

export const validation = (flow: Flow, url: string, token: string) => {
	return new Promise<Flow | Flow[] | boolean | any>(async (resolve, reject) => {
		/**
		 * Capa de Autentificación con el token
		 */
		let validationStatus: boolean = false;

		if (token) {
			await verifyToken(token)
				.then(async () => {
					/**
					 * Capa de validaciones
					 */
					if (url == '/create' || url == '/update') {
						attributeValidate('id_user_', flow.id_user_, 'number', 10).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update') {
						attributeValidate('id_flow', flow.id_flow, 'number', 5).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update') {
						attributeValidate('name_flow', flow.name_flow, 'string', 100).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update') {
						attributeValidate(
							'description_flow',
							flow.description_flow,
							'string',
							250
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					if (url == '/update') {
						attributeValidate(
							'acronym_flow',
							flow.acronym_flow,
							'string',
							20
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					if (url == '/update') {
						attributeValidate(
							'acronym_task',
							flow.acronym_task,
							'string',
							20
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					if (url == '/update') {
						attributeValidate(
							'sequential_flow',
							flow.sequential_flow,
							'number',
							10
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					/**
					 * Validation company
					 */

					if (url == '/create' || url == '/update') {
						attributeValidate(
							'id_company',
							flow.company.id_company,
							'number',
							5
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					/**
					 * Continuar solo si no ocurrio errores en la validación
					 */
					if (!validationStatus) {
						/**
						 * Instance the class
						 */
						const _flow = new Flow();
						/**
						 * Execute the url depending on the path
						 */
						if (url == '/create') {
							/** set required attributes for action */
							_flow.id_user_ = flow.id_user_;
							_flow.company = flow.company;
							await _flow
								.create()
								.then((_flow: Flow) => {
									resolve(_flow);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 10) == '/queryRead') {
							/** set required attributes for action */
							_flow.name_flow = flow.name_flow;
							await _flow
								.queryRead()
								.then((_processTypes: Flow[]) => {
									resolve(_processTypes);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
							const id_company: any = flow.company;

							if (id_company >= 1) {
								/** set required attributes for action */
								_flow.company = flow.company;
								_flow.name_flow = flow.name_flow;
								await _flow
									.byCompanyQueryRead()
									.then((_flows: Flow[]) => {
										resolve(_flows);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else {
								reject({
									..._messages[11],
									description: _messages[11].description.replace(
										'name_entity',
										'company'
									),
								});
							}
						} else if (url.substring(0, 13) == '/specificRead') {
							const id_flow: any = flow.id_flow;

							if (id_flow >= 1) {
								/** set required attributes for action */
								_flow.id_flow = flow.id_flow;
								await _flow
									.specificRead()
									.then((_flow: Flow) => {
										resolve(_flow);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else {
								reject({
									..._messages[11],
									description: _messages[11].description.replace(
										'name_entity',
										'flow'
									),
								});
							}
						} else if (url == '/update') {
							/** set required attributes for action */
							_flow.id_user_ = flow.id_user_;
							_flow.id_flow = flow.id_flow;
							_flow.company = flow.company;
							_flow.name_flow = flow.name_flow;
							_flow.description_flow = flow.description_flow;
							_flow.acronym_flow = flow.acronym_flow;
							_flow.acronym_task = flow.acronym_task;
							_flow.sequential_flow = flow.sequential_flow;
							await _flow
								.update()
								.then((_flow: Flow) => {
									resolve(_flow);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 7) == '/delete') {
							/** set required attributes for action */
							_flow.id_user_ = flow.id_user_;
							_flow.id_flow = flow.id_flow;
							await _flow
								.delete()
								.then((response: boolean) => {
									resolve(response);
								})
								.catch((error: any) => {
									reject(error);
								});
						}
					}
				})
				.catch((error) => {
					reject(error);
				});
		} else {
			reject(_messages[5]);
		}
	});
};

/**
 * Función para validar un campo de acuerdo a los criterios ingresados
 * @param attribute nombre del atributo a validar
 * @param value valor a validar
 * @param type tipo de dato correcto del atributo (string, number, boolean, object)
 * @param _length longitud correcta del atributo
 * @returns true || error
 */
const attributeValidate = (
	attribute: string,
	value: any,
	type: string,
	_length: number = 0
) => {
	return new Promise<Boolean>((resolve, reject) => {
		if (value != undefined || value != null) {
			if (typeof value == `${type}`) {
				if (typeof value == 'string' || typeof value == 'number') {
					if (value.toString().length > _length) {
						reject({
							..._messages[8],
							description: _messages[8].description
								.replace('_nameAttribute', `${attribute}`)
								.replace('_expectedCharacters', `${_length}`),
						});
					} else {
						resolve(true);
					}
				} else {
					resolve(true);
				}
			} else {
				reject({
					..._messages[7],
					description: _messages[7].description
						.replace('_nameAttribute', `${attribute}`)
						.replace('_expectedType', `${type}`),
				});
			}
		} else {
			reject({
				..._messages[6],
				description: _messages[6].description.replace(
					'_nameAttribute',
					`${attribute}`
				),
			});
		}
	});
};
